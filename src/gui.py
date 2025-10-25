#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Windows Auto-Installer - GUI Principal
Interfaccia grafica per creare USB bootable con installazione automatica
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import json
import os
from pathlib import Path

class WindowsAutoInstallerGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Windows Auto-Installer - Creatore USB Bootable")
        self.root.geometry("900x700")
        self.root.resizable(True, True)

        # Variabili
        self.iso_path = tk.StringVar()
        self.usb_drive = tk.StringVar()
        self.software_vars = {}

        # Carica configurazione software
        self.load_software_config()

        # Crea interfaccia
        self.create_widgets()

    def load_software_config(self):
        """Carica la configurazione dei software disponibili"""
        config_path = Path(__file__).parent.parent / "config" / "software.json"
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                self.software_config = json.load(f)
        except FileNotFoundError:
            # Configurazione di default se il file non esiste
            self.software_config = self.get_default_software_config()

    def get_default_software_config(self):
        """Configurazione software di default"""
        return {
            "browsers": {
                "chrome": {
                    "display_name": "Google Chrome",
                    "install_command": "winget install -e --id Google.Chrome",
                    "description": "Browser web veloce e sicuro"
                },
                "firefox": {
                    "display_name": "Mozilla Firefox",
                    "install_command": "winget install -e --id Mozilla.Firefox",
                    "description": "Browser open source"
                }
            },
            "utilities": {
                "7zip": {
                    "display_name": "7-Zip",
                    "install_command": "winget install -e --id 7zip.7zip",
                    "description": "Compressore file gratuito"
                },
                "vlc": {
                    "display_name": "VLC Media Player",
                    "install_command": "winget install -e --id VideoLAN.VLC",
                    "description": "Lettore multimediale universale"
                }
            }
        }

    def create_widgets(self):
        """Crea tutti i widget dell'interfaccia"""

        # Header
        header_frame = tk.Frame(self.root, bg="#0078D4", height=80)
        header_frame.pack(fill=tk.X)
        header_frame.pack_propagate(False)

        title_label = tk.Label(
            header_frame,
            text="Windows Auto-Installer",
            font=("Segoe UI", 20, "bold"),
            bg="#0078D4",
            fg="white"
        )
        title_label.pack(pady=20)

        # Contenitore principale con scrollbar
        main_container = tk.Frame(self.root)
        main_container.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        # Canvas per scrolling
        canvas = tk.Canvas(main_container)
        scrollbar = ttk.Scrollbar(main_container, orient="vertical", command=canvas.yview)
        scrollable_frame = tk.Frame(canvas)

        scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )

        canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)

        # Sezione 1: Selezione ISO
        iso_frame = tk.LabelFrame(
            scrollable_frame,
            text="1. Seleziona ISO di Windows 11",
            font=("Segoe UI", 12, "bold"),
            padx=15,
            pady=15
        )
        iso_frame.pack(fill=tk.X, pady=10)

        iso_entry = tk.Entry(iso_frame, textvariable=self.iso_path, font=("Segoe UI", 10), width=60)
        iso_entry.pack(side=tk.LEFT, padx=(0, 10))

        iso_button = tk.Button(
            iso_frame,
            text="Sfoglia...",
            command=self.browse_iso,
            font=("Segoe UI", 10),
            bg="#0078D4",
            fg="white",
            padx=20
        )
        iso_button.pack(side=tk.LEFT)

        # Sezione 2: Selezione USB
        usb_frame = tk.LabelFrame(
            scrollable_frame,
            text="2. Selezione Chiavetta USB",
            font=("Segoe UI", 12, "bold"),
            padx=15,
            pady=15
        )
        usb_frame.pack(fill=tk.X, pady=10)

        tk.Label(
            usb_frame,
            text="ATTENZIONE: Tutti i dati sulla chiavetta verranno cancellati!",
            font=("Segoe UI", 9),
            fg="red"
        ).pack(anchor=tk.W, pady=(0, 10))

        usb_combo = ttk.Combobox(
            usb_frame,
            textvariable=self.usb_drive,
            font=("Segoe UI", 10),
            width=50,
            state="readonly"
        )
        usb_combo['values'] = self.get_usb_drives()
        usb_combo.pack(side=tk.LEFT, padx=(0, 10))

        refresh_button = tk.Button(
            usb_frame,
            text="Aggiorna",
            command=lambda: usb_combo.config(values=self.get_usb_drives()),
            font=("Segoe UI", 10)
        )
        refresh_button.pack(side=tk.LEFT)

        # Sezione 3: Selezione Software
        software_frame = tk.LabelFrame(
            scrollable_frame,
            text="3. Seleziona Software da Installare",
            font=("Segoe UI", 12, "bold"),
            padx=15,
            pady=15
        )
        software_frame.pack(fill=tk.BOTH, expand=True, pady=10)

        # Crea checkbox per ogni categoria
        for category, software_list in self.software_config.items():
            category_label = tk.Label(
                software_frame,
                text=f"{category.upper().replace('_', ' ')}",
                font=("Segoe UI", 11, "bold")
            )
            category_label.pack(anchor=tk.W, pady=(10, 5))

            for sw_id, sw_info in software_list.items():
                var = tk.BooleanVar()
                self.software_vars[f"{category}_{sw_id}"] = {
                    'var': var,
                    'info': sw_info
                }

                cb = tk.Checkbutton(
                    software_frame,
                    text=f"{sw_info['display_name']} - {sw_info['description']}",
                    variable=var,
                    font=("Segoe UI", 10)
                )
                cb.pack(anchor=tk.W, padx=20)

        # Pulsanti Seleziona/Deseleziona
        select_buttons_frame = tk.Frame(software_frame)
        select_buttons_frame.pack(fill=tk.X, pady=10)

        tk.Button(
            select_buttons_frame,
            text="Seleziona Tutti",
            command=self.select_all,
            font=("Segoe UI", 9)
        ).pack(side=tk.LEFT, padx=5)

        tk.Button(
            select_buttons_frame,
            text="Deseleziona Tutti",
            command=self.deselect_all,
            font=("Segoe UI", 9)
        ).pack(side=tk.LEFT, padx=5)

        # Pack canvas e scrollbar
        canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        # Sezione 4: Azioni
        action_frame = tk.Frame(self.root, pady=15)
        action_frame.pack(fill=tk.X, padx=10)

        create_button = tk.Button(
            action_frame,
            text="Crea USB Bootable",
            command=self.create_usb,
            font=("Segoe UI", 14, "bold"),
            bg="#0078D4",
            fg="white",
            padx=30,
            pady=15
        )
        create_button.pack(side=tk.LEFT, padx=10)

        preview_button = tk.Button(
            action_frame,
            text="Anteprima Configurazione",
            command=self.preview_config,
            font=("Segoe UI", 12),
            padx=20,
            pady=10
        )
        preview_button.pack(side=tk.LEFT, padx=10)

        # Progress bar
        self.progress = ttk.Progressbar(
            self.root,
            mode='indeterminate',
            length=300
        )

    def browse_iso(self):
        """Apri dialog per selezionare file ISO"""
        filename = filedialog.askopenfilename(
            title="Seleziona file ISO di Windows 11",
            filetypes=[("File ISO", "*.iso"), ("Tutti i file", "*.*")]
        )
        if filename:
            self.iso_path.set(filename)

    def get_usb_drives(self):
        """Rileva chiavette USB disponibili"""
        return ["Nessuna chiavetta rilevata (feature in sviluppo)"]

    def select_all(self):
        """Seleziona tutti i software"""
        for sw in self.software_vars.values():
            sw['var'].set(True)

    def deselect_all(self):
        """Deseleziona tutti i software"""
        for sw in self.software_vars.values():
            sw['var'].set(False)

    def preview_config(self):
        """Mostra anteprima della configurazione"""
        selected = self.get_selected_software()

        preview_text = "CONFIGURAZIONE SELEZIONATA\n\n"
        preview_text += f"ISO: {self.iso_path.get() or 'Non selezionato'}\n"
        preview_text += f"USB: {self.usb_drive.get() or 'Non selezionato'}\n\n"
        preview_text += f"SOFTWARE DA INSTALLARE ({len(selected)}):\n"

        if selected:
            for sw in selected:
                preview_text += f"  - {sw['display_name']}\n"
        else:
            preview_text += "  Nessun software selezionato\n"

        messagebox.showinfo("Anteprima Configurazione", preview_text)

    def get_selected_software(self):
        """Ottieni lista dei software selezionati"""
        selected = []
        for sw_id, sw_data in self.software_vars.items():
            if sw_data['var'].get():
                selected.append(sw_data['info'])
        return selected

    def create_usb(self):
        """Avvia la creazione della USB bootable"""
        if not self.iso_path.get():
            messagebox.showerror("Errore", "Seleziona un file ISO di Windows 11!")
            return

        selected_software = self.get_selected_software()

        # Salva configurazione
        self.save_config(selected_software)

        messagebox.showinfo(
            "In Sviluppo",
            "Questa funzionalita e in fase di sviluppo.\n\n"
            "La configurazione e stata salvata in:\n"
            "config/user_selection.json\n\n"
            "Gli script PowerShell verranno eseguiti\n"
            "durante l'installazione automatica di Windows."
        )

    def save_config(self, selected_software):
        """Salva la configurazione selezionata"""
        config = {
            "iso_path": self.iso_path.get(),
            "usb_drive": self.usb_drive.get(),
            "software": [
                {
                    "name": sw['display_name'],
                    "command": sw['install_command']
                }
                for sw in selected_software
            ]
        }

        config_dir = Path(__file__).parent.parent / "config"
        config_dir.mkdir(exist_ok=True)

        config_path = config_dir / "user_selection.json"
        with open(config_path, 'w', encoding='utf-8') as f:
            json.dump(config, f, indent=2, ensure_ascii=False)

        print(f"Configurazione salvata in: {config_path}")

def main():
    """Funzione principale"""
    root = tk.Tk()
    app = WindowsAutoInstallerGUI(root)
    root.mainloop()

if __name__ == "__main__":
    main()
