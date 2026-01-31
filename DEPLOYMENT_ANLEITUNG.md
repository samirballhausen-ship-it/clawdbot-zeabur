# 🚀 Zeabur Deployment - Manuelle Fertigstellung

## ✅ Was bereits vorbereitet ist:

1. **Zeabur Project**: `untitled` in Frankfurt, Germany (AWS)
2. **Deployment-Files**: Alle in `C:\Users\samir\zeabur-clawdbot\`
   - `package.json` - Node.js Dependencies
   - `Dockerfile` - Container Config
   - `README.md` - Dokumentation
   - `.env.example` - Environment Variables Template

## 📁 Nächste Schritte (Manuell):

### 1️⃣ Files hochladen

Im Browser (bereits offen auf https://zeabur.com):

1. Dialog "Upload local project" ist bereits offen
2. Klicke auf den Upload-Bereich
3. Wähle den Ordner: `C:\Users\samir\zeabur-clawdbot\`
4. ODER: Drag & Drop den kompletten Ordner in den Browser

### 2️⃣ Environment Variables setzen

Nach dem Upload, gehe zu **Settings** → **Environment Variables** und füge hinzu:

**ERFORDERLICH:**
```
ANTHROPIC_API_KEY=<dein_api_key>
```

**OPTIONAL (aus deiner Config):**
```
TELEGRAM_BOT_TOKEN=8583702683:AAG3zSGOOHDTy8dbbe02Wn9uViK_vXXcrug
PORT=18789
GATEWAY_MODE=remote
GATEWAY_BIND=0.0.0.0
PRIMARY_MODEL=sonnet
```

### 3️⃣ Deploy starten

1. Klicke auf **Deploy** Button
2. Warte ca. 2-3 Minuten (Build + Start)
3. Check Logs für Errors

### 4️⃣ Nach erfolgreichem Deploy

1. **Domain notieren**: `https://your-service.zeabur.app`
2. **Gateway Token holen**: Aus Logs oder Settings
3. **Testen**:
   - Öffne `https://your-service.zeabur.app`
   - WebChat sollte verfügbar sein
   - Telegram Bot sollte antworten

## 🔧 Troubleshooting

**Build Failed?**
- Check Logs: Node.js Version kompatibel?
- Dockerfile korrekt?

**Gateway startet nicht?**
- ANTHROPIC_API_KEY gesetzt?
- Port-Config korrekt (Zeabur setzt `$PORT` automatisch)?

**Telegram funktioniert nicht?**
- TELEGRAM_BOT_TOKEN korrekt?
- Webhook URL in Telegram Bot Settings anpassen?

## 💰 Kosten

- Shared Cluster: ~$0.007/Stunde = ca. $2-5/Monat
- Abhängig von Traffic und Runtime

## 📞 Support

Bei Fragen: Check Zeabur Docs (https://zeabur.com/docs) oder Clawdbot Docs (https://docs.clawd.bot)
