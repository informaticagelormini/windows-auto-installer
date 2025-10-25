# ============================================================================
# Windows Auto-Installer - Script di Setup Iniziale
# ============================================================================
# Questo script viene eseguito dopo l'installazione di Windows
# Configura le impostazioni di base del sistema
# ============================================================================

#Requires -RunAsAdministrator

$ErrorActionPreference = "Continue"
$LogFile = "C:\Windows\Temp\AutoSetup.log"

function Write-Log {
    param([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "========================================"
Write-Log "  Windows Auto-Installer"
Write-Log "  Configurazione Iniziale Sistema"
Write-Log "========================================"

# 1. Disabilita suggerimenti di Windows
Write-Log "Disabilitazione suggerimenti Windows..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0 -Type DWord -Force

# 2. Abilita Esplora File per mostrare estensioni file
Write-Log "Configurazione Esplora File..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Type DWord -Force

# 3. Abilita Dark Mode (opzionale)
Write-Log "Abilitazione Dark Mode..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Type DWord -Force

# 4. Configura fuso orario (Italia)
Write-Log "Configurazione fuso orario..."
Set-TimeZone -Id "W. Europe Standard Time"

# 5. Configura lingua italiana
Write-Log "Configurazione lingua italiana..."
Set-WinUserLanguageList -LanguageList it-IT -Force

# 6. Pulisci applicazioni preinstallate non necessarie
Write-Log "Rimozione bloatware..."
$BloatwareApps = @(
    "Microsoft.BingNews"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MixedReality.Portal"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
)

foreach ($App in $BloatwareApps) {
    try {
        Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
        Write-Log "  OK Rimosso: $App"
    } catch {
        Write-Log "  X Impossibile rimuovere: $App"
    }
}

# 7. Configura prestazioni visive
Write-Log "Ottimizzazione prestazioni visive..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord -Force

# 8. Abilita Ripristino Configurazione di Sistema
Write-Log "Abilitazione Ripristino Configurazione di Sistema..."
Enable-ComputerRestore -Drive "C:\"

# 9. Crea punto di ripristino iniziale
Write-Log "Creazione punto di ripristino..."
Checkpoint-Computer -Description "Installazione Iniziale Windows Auto-Installer" -RestorePointType "MODIFY_SETTINGS"

Write-Log ""
Write-Log "========================================"
Write-Log "Configurazione iniziale completata!"
Write-Log "========================================"
Write-Log "Log salvato in: $LogFile"
Write-Log ""
Write-Log "Prossimo passo: Installazione software..."
Write-Log "Esecuzione di install.ps1..."

# Esegui lo script di installazione software
$InstallScriptPath = Join-Path $PSScriptRoot "install.ps1"
if (Test-Path $InstallScriptPath) {
    & $InstallScriptPath
} else {
    Write-Log "Script install.ps1 non trovato!" "ERROR"
}
