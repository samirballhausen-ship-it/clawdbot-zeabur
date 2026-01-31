# TOOLS.md - Local Notes

## OneDrive Eingang/Erledigt

- **Pfad:** `/mnt/c/Users/samir/OneDrive/CLAWD/`
- **EINGANG:** Dateien die Samir nicht per Telegram senden kann → hier ablegen
- **ERLEDIGT:** Nach Verarbeitung dorthin verschieben
- **Ablauf:** Eingang prüfen → kopieren & verarbeiten → nach ERLEDIGT verschieben

---

## 📁 **GROSSE DATEIEN - WORKAROUNDS**

### Wenn "too large files" Fehler auftreten:

**🎵 Audio-Dateien:**
- **Transkribieren** statt Originaldatei (OpenAI Whisper API)
- **Zusammenfassung** erstellen
- **Metadata** extrahieren (Länge, Format, etc.)

**🎬 Video-Dateien:**
- **Komprimieren** (ffmpeg, kleinere Bitrate)
- **Keyframes** extrahieren als Bilder
- **Audio-Track** separieren und transkribieren
- **Zusammenfassung** der Inhalte

**🖼️ Bild-Dateien:**
- **Komprimieren** (JPEG-Qualität reduzieren)
- **Resize** (kleinere Auflösung)
- **Beschreibung** via Vision-Model erstellen

**📄 Dokumente:**
- **Text extrahieren** (OCR)
- **Zusammenfassung** generieren
- **Chunks** verarbeiten (Split in kleinere Teile)

### ✅ **Erfolgreiche Beispiele:**
- **WhatsApp-DB:** 45 Audios → Whisper-Transkription (statt 86 Originaldateien)
- **Video-Frames:** ffmpeg für Keyframe-Extraktion

**REGEL:** Kreative Lösungen finden, nicht aufgeben! 🎯

---

## Dateisystem & Workspace-Struktur

- **Samirs Dokumente (Windows):** `/mnt/c/users/samir`
  - Immer diesen Pfad nutzen wenn nach Dateien gefragt wird
  - WSL-Umgebung → Windows-Dateien über /mnt/c erreichbar

### Workspace (`~/clawd/`)
```
clawd/
├── *.md, costs.json          # System-Files (Root)
├── memory/                    # Tagesnotizen (YYYY-MM-DD.md)
├── media/                     # Generierte Medien
│   ├── images/               # Bilder
│   ├── videos/               # Videos
│   └── audio/                # Audio
├── projects/                  # Alle Projekte
│   ├── kikurier/             # KI-Kurier Newsletter
│   ├── essensplaner/         # Essensplaner-App
│   ├── flappy-duck/          # Flappy Duck Game
│   ├── mpp-build/            # MPP Projekt
│   ├── safetybase-pro/       # SafetyBase Pro (MILLIONEN-POTENZIAL!)
│   └── research/             # Analysen & Konzepte
├── dokumente/                 # Persönliche Dokumente
├── scripts/                   # Utility-Scripts
├── gen/                       # Lokale KI-Outputs (3D etc.)
├── skills/                    # Clawdbot Skills (System)
└── canvas/                    # Canvas (System)
```

### Sortierregeln
- **Neue Bilder** → `media/images/` (Format: YYYY-MM-DD-beschreibung.png)
- **Neue Videos** → `media/videos/`
- **Neue Audio** → `media/audio/`
- **Neue Projekte** → `projects/<name>/`
- **Analysen/Konzepte** → `projects/research/`
- **Tagesnotizen** → `memory/YYYY-MM-DD.md`
- **NIE lose Dateien im Workspace-Root ablegen!**

---

## Bildgenerierung

- **Immer nano-banana-pro** (Gemini 3 Pro Image) verwenden
- API Key in Config hinterlegt

## Video-Generierung (Veo 3)

```bash
# Video generieren
curl -s "https://generativelanguage.googleapis.com/v1beta/models/veo-3.0-fast-generate-001:predictLongRunning" \
  -H "x-goog-api-key: $GEMINI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"instances": [{"prompt": "..."}], "parameters": {"sampleCount": 1}}'

# Operation pollen (bis "done": true)
curl -s "https://generativelanguage.googleapis.com/v1beta/models/veo-3.0-fast-generate-001/operations/OPERATION_ID?key=$GEMINI_API_KEY"

# Video downloaden (WICHTIG: -L für Redirect!)
curl -sL -o output.mp4 "DOWNLOAD_URI&key=$GEMINI_API_KEY"
```

Verfügbare Modelle: veo-2.0 (Billing nötig), veo-3.0, veo-3.0-fast, veo-3.1, veo-3.1-fast

---

## Lokale KI-Generierung (Pinokio: ComfyUI + Hunyuan3D)

- **Skill**: local-ai-gen (automatisch geladen)
- **Kosten**: $0.00 (komplett lokal, nur Strom/GPU)
- **Apps werden on-demand gestartet** und nach Abschluss gestoppt

### ComfyUI (Bildgenerierung + 3D via Workflows)
- **Port**: http://localhost:8188
- **Modelle**: JuggernautXL v8 (SDXL), Hunyuan3D v2.1
- **Install-Pfad**: C:\pinokio\api\comfy.git\app
- **Output**: /mnt/c/pinokio/api/comfy.git/app/output/

### Hunyuan3D (Image-to-3D)
- **Port**: Dynamisch (Pinokio weist zu, z.B. 42003). Script discovert automatisch.
- **Modell**: Hunyuan3D-2mini Turbo (fp16, mmgp Profile 4)
- **API**: Gradio Client API (`gradio_client` Python-Paket)
- **Install-Pfad**: C:\pinokio\api\Hunyuan3D-2-lowvram.git\app
- **Performance**: ~20s total (5 Diffusion Steps, Turbo)
- **Output**: GLB-Dateien (in gen/ Verzeichnis)
- **WICHTIG**: Muss manuell in Pinokio gestartet werden (mmgp braucht Pinokio)

### Pipeline: Bild → 3D-Modell
1. Referenzbild generieren (nano-banana-pro)
2. Hunyuan3D in Pinokio manuell starten
3. 3D generieren: `uv run skills/local-ai-gen/scripts/hunyuan3d_api.py --action generate --image <bild>`
4. Synchron (~20s) → Ergebnis als GLB in gen/ gespeichert
5. Ergebnis per Telegram zugestellt

---

## Suno AI Musikgenerierung

- **suno-api** laeuft auf http://localhost:3100 (systemd service: suno-api)
- **Skill**: suno (automatisch geladen bei Musik-Anfragen)
- **Credits**: 2500/Monat, jede Generierung kostet 10 Credits (2 Varianten)
- **Cookie-Refresh**: Bei Session-Fehlern Chrome mit CDP muss laufen