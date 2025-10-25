# 🚀 Windows Auto-Installer
**Crea chiavette USB bootable di Windows 11 con installazione automatica di software personalizzati**
![Windows 11](https://img.shields.io/badge/Windows-11-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.8+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
---
## 📖 Cos'è questo progetto?
## 📖 Cos'è questo progetto?

**Windows Auto-Installer** è uno strumento che ti permette di creare chiavette USB bootable di Windows 11 con installazione automatica di tutti i software che desideri. Perfetto per chi deve installare Windows su più macchine con la stessa configurazione!

### ✨ Funzionalità principali:

- ✅ **Interfaccia grafica semplice** - Nessun comando da ricordare
- ✅ **Selezione software personalizzata** - Scegli quali programmi installare
- ✅ **Installazione completamente automatica** - Avvii e torni quando è finito
- ✅ **Supporto Windows 11** - Sempre aggiornato
- ✅ **Multi-macchina** - Perfetto per installazioni ripetute

---

## 🎯 Software supportati

### Browser
- Google Chrome
- Mozilla Firefox
- Microsoft Edge
- Brave Browser

### Office
- LibreOffice
- Microsoft Office 365
- ONLYOFFICE

### PDF Reader
- Adobe Acrobat Reader
- Foxit Reader
- Sumatra PDF

### Compressione
- 7-Zip
- WinRAR
- PeaZip

### Antivirus
- Avast Free
- AVG Free
- Malwarebytes

### Utilità
- VLC Media Player
- Notepad++
- GIMP
- Paint.NET
- CCleaner
- TeamViewer
- AnyDesk

### Sviluppo
- Visual Studio Code
- Git
- Python 3
- Node.js
- Docker Desktop

### Comunicazione
- Discord
- Zoom
- Telegram Desktop
- WhatsApp Desktop

---

## 📋 Prerequisiti

Prima di iniziare, assicurati di avere:

### Hardware
- 💾 **Chiavetta USB** da almeno 16 GB (verrà formattata!)
- 💻 **PC Windows** per creare la chiavetta

### Software
- 🪟 **Windows 10/11** sul PC che prepara la chiavetta
- 🐍 **Python 3.8 o superiore** - [Download qui](https://www.python.org/downloads/)
- 💿 **File ISO di Windows 11** - [Download ufficiale Microsoft](https://www.microsoft.com/it-it/software-download/windows11)

### Permessi
- 👨‍💼 **Diritti di amministratore** sul PC

---

## 🚀 Guida rapida - 5 minuti

### Passo 1: Scarica il progetto

\\\ash
git clone https://github.com/informaticagelormini/windows-auto-installer.git
cd windows-auto-installer
\\\

### Passo 2: Installa le dipendenze

\\\ash
pip install -r requirements.txt
\\\

### Passo 3: Avvia l'interfaccia

\\\ash
python src/gui.py
\\\

### Passo 4: Configura nella GUI

1. ✅ Seleziona il file ISO di Windows 11
2. ✅ Scegli la chiavetta USB di destinazione
3. ✅ Seleziona i software da installare automaticamente
4. ✅ Clicca su "Crea USB"

### Passo 5: Usa la chiavetta

1. 🔌 Inserisci la chiavetta nel PC da formattare
2. 🔄 Avvia il PC dalla USB (Boot Menu)
3. ☕ Rilassati - tutto si installerà automaticamente!

---

## 📚 Documentazione completa

### 📁 Struttura del progetto

\\\
windows-auto-installer/
├── src/                    # Codice sorgente
│   ├── gui.py             # Interfaccia grafica principale
│   └── __init__.py        # Package init
├── scripts/               # Script PowerShell
│   ├── install.ps1        # Script installazione automatica
│   └── setup.ps1          # Setup iniziale Windows
├── config/                # File di configurazione
│   └── software.json      # Lista software disponibili
├── docs/                  # Documentazione
│   └── FAQ.md            # Domande frequenti
├── requirements.txt       # Dipendenze Python
├── .gitignore
├── LICENSE
└── README.md             # Questo file
\\\

---

## 🔧 Installazione dettagliata

### 1. Installare Python

1. Scarica Python da: https://www.python.org/downloads/
2. **IMPORTANTE:** Durante l'installazione, spunta "Add Python to PATH"
3. Verifica l'installazione:
   \\\ash
   python --version
   \\\

### 2. Scaricare il progetto

**Opzione A - Con Git:**
\\\ash
git clone https://github.com/informaticagelormini/windows-auto-installer.git
cd windows-auto-installer
\\\

**Opzione B - Senza Git:**
1. Vai su https://github.com/informaticagelormini/windows-auto-installer
2. Clicca su "Code" → "Download ZIP"
3. Estrai la cartella

### 3. Installare le dipendenze

\\\ash
cd windows-auto-installer
pip install -r requirements.txt
\\\

---

## 💻 Come usare

### Interfaccia grafica (consigliato)

\\\ash
python src/gui.py
\\\

Segui i passaggi nell'interfaccia:

1. **Seleziona ISO**: Clicca su "Sfoglia" e scegli il file ISO di Windows 11
2. **Scegli USB**: Seleziona la chiavetta dal menu a tendina
3. **Seleziona software**: Spunta i programmi da installare automaticamente
4. **Personalizza**: Aggiungi altri software se necessario
5. **Crea**: Clicca su "Crea USB Bootable" e attendi

---

## 📦 Aggiungere software personalizzati

Puoi aggiungere qualsiasi software modificando \config/software.json\:

\\\json
{
  "nome_software": {
    "display_name": "Nome Visualizzato",
    "install_command": "winget install -e --id Publisher.SoftwareName",
    "category": "Categoria",
    "description": "Descrizione breve"
  }
}
\\\

Trova pacchetti disponibili:
\\\ash
winget search "nome software"
\\\

---

## 🐛 Risoluzione problemi

### La chiavetta non si avvia

1. Verifica di aver configurato il BIOS per il boot da USB
2. Controlla che Secure Boot sia disabilitato (se richiesto)
3. Ricrea la chiavetta

### Software non si installa

1. Verifica la connessione internet durante l'installazione
2. Controlla i log in \C:\Windows\Temp\AutoInstall.log\
3. Alcuni software potrebbero richiedere licenza

### Errori Python

\\\ash
# Reinstalla le dipendenze
pip install -r requirements.txt --force-reinstall
\\\

---

## 📝 FAQ - Domande frequenti

**Q: Posso usare Windows 10?**
A: Sì, il progetto supporta anche Windows 10. Basta usare un ISO di Windows 10.

**Q: Quanto tempo ci vuole?**
A: Creazione USB: 10-30 minuti. Installazione completa: 30-60 minuti (dipende dal numero di software).

**Q: Posso usare più volte la stessa chiavetta?**
A: Sì! Una volta creata, puoi usarla per installare su più PC.

**Q: I software sono legali?**
A: Sì, vengono installati dai repository ufficiali (Winget/Chocolatey). Assicurati di avere le licenze necessarie.

**Q: Funziona offline?**
A: L'installazione di Windows sì, ma i software richiedono connessione internet per il download.

Vedi [FAQ complete](docs/FAQ.md) per altre domande.

---

## 🤝 Contribuire

Contributi, segnalazioni di bug e richieste di funzionalità sono benvenuti!

1. Fork il progetto
2. Crea un branch (\git checkout -b feature/nuova-funzionalita\)
3. Commit delle modifiche (\git commit -m 'Aggiunta nuova funzionalità'\)
4. Push al branch (\git push origin feature/nuova-funzionalita\)
5. Apri una Pull Request

Vedi [CONTRIBUTING.md](CONTRIBUTING.md) per dettagli.

---

## 📄 Licenza

Questo progetto è distribuito sotto licenza MIT. Vedi il file [LICENSE](LICENSE) per maggiori dettagli.

---

## 🙏 Crediti

- **Winget** - Package manager Microsoft
- **Chocolatey** - Package manager Windows
- **Rufus** - Ispirazione per la creazione USB

---

## 📞 Supporto

Hai bisogno di aiuto?

- 🐛 Issues: [GitHub Issues](https://github.com/informaticagelormini/windows-auto-installer/issues)
- 💬 Discussioni: [GitHub Discussions](https://github.com/informaticagelormini/windows-auto-installer/discussions)

---

**Realizzato con ❤️ per semplificare l'installazione di Windows**

🤖 Generated with [Claude Code](https://claude.com/claude-code)
