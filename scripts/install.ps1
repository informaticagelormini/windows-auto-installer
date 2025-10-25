# ============================================================================
# Windows Auto-Installer - Script di Installazione Automatica Software
# ============================================================================
# Questo script viene eseguito automaticamente dopo l'installazione di Windows
# Installa tutti i software selezionati dall'utente tramite la GUI
# ============================================================================

# Richiede diritti di amministratore
#Requires -RunAsAdministrator

# Impostazioni
$ErrorActionPreference = "Continue"
$LogFile = "C:\Windows\Temp\AutoInstall.log"
$ConfigFile = "C:\AutoInstall\user_selection.json"

# Funzione di logging
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"

    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

# Banner
Write-Log "========================================"
Write-Log "  Windows Auto-Installer v1.0"
Write-Log "  Installazione Automatica Software"
Write-Log "========================================"

# Verifica presenza file di configurazione
if (-not (Test-Path $ConfigFile)) {
    Write-Log "File di configurazione non trovato: $ConfigFile" "ERROR"
    Write-Log "Creazione configurazione di esempio..."

    # Crea una configurazione di esempio
    $ExampleConfig = @{
        software = @(
            @{ name = "Google Chrome"; command = "winget install -e --id Google.Chrome --accept-package-agreements --accept-source-agreements" }
            @{ name = "7-Zip"; command = "winget install -e --id 7zip.7zip --accept-package-agreements --accept-source-agreements" }
        )
    }

    New-Item -ItemType Directory -Path "C:\AutoInstall" -Force | Out-Null
    $ExampleConfig | ConvertTo-Json | Set-Content -Path $ConfigFile
}

# Carica configurazione
try {
    Write-Log "Caricamento configurazione..."
    $Config = Get-Content -Path $ConfigFile -Raw | ConvertFrom-Json
    Write-Log "Configurazione caricata: $($Config.software.Count) software da installare"
} catch {
    Write-Log "Errore nel caricamento della configurazione: $_" "ERROR"
    exit 1
}

# Verifica connessione internet
Write-Log "Verifica connessione internet..."
try {
    $null = Test-Connection -ComputerName "8.8.8.8" -Count 1 -ErrorAction Stop
    Write-Log "Connessione internet: OK"
} catch {
    Write-Log "ATTENZIONE: Nessuna connessione internet rilevata!" "WARNING"
    Write-Log "L'installazione dei software richiede una connessione internet attiva."

    $Response = Read-Host "Vuoi attendere la connessione? (S/N)"
    if ($Response -eq "S") {
        Write-Log "In attesa della connessione internet..."
        while (-not (Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet)) {
            Start-Sleep -Seconds 5
        }
        Write-Log "Connessione internet stabilita!"
    } else {
        Write-Log "Installazione annullata dall'utente." "WARNING"
        exit 0
    }
}

# Verifica e installa Winget se necessario
Write-Log "Verifica disponibilita Winget..."
$WingetPath = Get-Command winget -ErrorAction SilentlyContinue

if (-not $WingetPath) {
    Write-Log "Winget non trovato, installazione in corso..." "WARNING"

    try {
        # Installa Winget (App Installer)
        $ProgressPreference = 'SilentlyContinue'
        Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
        Write-Log "Winget installato con successo"
    } catch {
        Write-Log "Errore nell'installazione di Winget: $_" "ERROR"
        Write-Log "Tentativo di installazione manuale..."

        # Download e installazione manuale
        $WingetUrl = "https://aka.ms/getwinget"
        $WingetInstaller = "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"

        Invoke-WebRequest -Uri $WingetUrl -OutFile $WingetInstaller
        Add-AppxPackage -Path $WingetInstaller

        Write-Log "Winget installato manualmente"
    }
} else {
    Write-Log "Winget trovato: $($WingetPath.Source)"
}

# Aggiorna Winget sources
Write-Log "Aggiornamento repository Winget..."
try {
    winget source update
    Write-Log "Repository Winget aggiornati"
} catch {
    Write-Log "Errore nell'aggiornamento dei repository: $_" "WARNING"
}

# Installazione software
$TotalSoftware = $Config.software.Count
$CurrentSoftware = 0
$SuccessCount = 0
$FailedSoftware = @()

Write-Log "========================================"
Write-Log "Inizio installazione $TotalSoftware software..."
Write-Log "========================================"

foreach ($Software in $Config.software) {
    $CurrentSoftware++
    $SoftwareName = $Software.name
    $InstallCommand = $Software.command

    Write-Log ""
    Write-Log "[$CurrentSoftware/$TotalSoftware] Installazione: $SoftwareName"
    Write-Log "Comando: $InstallCommand"

    try {
        # Esegui il comando di installazione
        $Process = Start-Process -FilePath "powershell.exe" `
                                  -ArgumentList "-NoProfile", "-Command", $InstallCommand `
                                  -Wait `
                                  -PassThru `
                                  -NoNewWindow

        if ($Process.ExitCode -eq 0) {
            Write-Log "OK $SoftwareName installato con successo" "SUCCESS"
            $SuccessCount++
        } else {
            Write-Log "X Errore nell'installazione di $SoftwareName (Exit Code: $($Process.ExitCode))" "ERROR"
            $FailedSoftware += $SoftwareName
        }
    } catch {
        Write-Log "X Errore nell'installazione di $SoftwareName : $_" "ERROR"
        $FailedSoftware += $SoftwareName
    }

    # Piccola pausa tra le installazioni
    Start-Sleep -Seconds 2
}

# Riepilogo finale
Write-Log ""
Write-Log "========================================"
Write-Log "  INSTALLAZIONE COMPLETATA"
Write-Log "========================================"
Write-Log "Software installati con successo: $SuccessCount / $TotalSoftware"

if ($FailedSoftware.Count -gt 0) {
    Write-Log ""
    Write-Log "Software non installati:" "WARNING"
    foreach ($Failed in $FailedSoftware) {
        Write-Log "  X $Failed" "WARNING"
    }
    Write-Log ""
    Write-Log "SUGGERIMENTO: Controlla il log per dettagli: $LogFile"
}

Write-Log ""
Write-Log "Log completo salvato in: $LogFile"

# Pulizia
Write-Log ""
Write-Log "Pulizia file temporanei..."
try {
    Remove-Item -Path "C:\AutoInstall" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Log "Pulizia completata"
} catch {
    Write-Log "Errore durante la pulizia: $_" "WARNING"
}

# Opzione riavvio
Write-Log ""
Write-Log "========================================"
$Reboot = Read-Host "Vuoi riavviare il computer ora? (S/N)"
if ($Reboot -eq "S") {
    Write-Log "Riavvio del sistema in corso..."
    Restart-Computer -Force
} else {
    Write-Log "Riavvio posticipato. Ricordati di riavviare il computer."
}

Write-Log "Script terminato."
Write-Log "========================================"
