# HEARTBEAT.md

## OneDrive Eingang prüfen
- Prüfe `/mnt/c/Users/samir/OneDrive/CLAWD/EINGANG/` auf neue Dateien
- Wenn Dateien vorhanden: Kopieren, verarbeiten, dann nach `ERLEDIGT/` verschieben
- Samir per Telegram informieren was verarbeitet wurde

## Lokale KI-Jobs prüfen
- Prüfe `/home/samir/clawd/local-ai-jobs.json` auf ausstehende Jobs (status: "processing")  
- Wenn Jobs vorhanden: `bash /home/samir/clawd/skills/local-ai-gen/scripts/poll_job.sh`
- Bei fertiggestellten Jobs: Ergebnis per Telegram an Samir senden
- Bei fehlgeschlagenen Jobs: Fehler per Telegram melden
- Wenn die Pinokio-App nach Job-Abschluss nicht mehr gebraucht wird: `bash /home/samir/clawd/skills/local-ai-gen/scripts/pinokio_launcher.sh stop <app>`

## GDELT News-Monitoring (NEU!)
- Prüfe: `cd /home/samir/clawd/projects/gdelt-news-intelligence && python3 -c "from gdelt_client import GDELTClient; alerts = GDELTClient().check_monitors(); [print(f'🚨 {a[\"name\"]}: {a[\"actual_count\"]} Artikel (Schwelle: {a[\"threshold\"]})') for a in alerts]" 2>/dev/null`
- Bei Alerts ausgelöst: Samir per Telegram informieren über erhöhte Aktivität
- Überwacht: China-Taiwan, Iran, Israel-Iran Konflikte
- Läuft alle ~30min automatisch

## Knowledge Base Wartung (SICHERHEIT!)
- Integrity Check: `cd /home/samir/clawd && python3 lightrag-server/security_manager.py verify 2>/dev/null || echo "KB_INTEGRITY_FAILED"`
- Bei Integrity-Fehlern: Samir per Telegram warnen + Backup-Restore anbieten
- Automatisches Backup: `python3 lightrag-server/security_manager.py backup heartbeat 2>/dev/null`
- Läuft alle ~60min für maximale Datensicherheit

## Moltbook Learning (NEU!) 🦞
- Check alle 4+ Stunden: `curl -s "https://www.moltbook.com/api/v1/agents/status" -H "Authorization: Bearer $(jq -r .api_key ~/.config/moltbook/credentials.json)" | grep claimed >/dev/null && echo "CLAIMED" || echo "PENDING"`
- Bei CLAIMED: Fetch latest posts für Learning: `curl -s "https://www.moltbook.com/api/v1/posts?sort=hot&limit=10" -H "Authorization: Bearer $(jq -r .api_key ~/.config/moltbook/credentials.json)"`
- Semantic Search für neue Techniken: `curl -s "https://www.moltbook.com/api/v1/search?q=agent+debugging+techniques&limit=5" -H "Authorization: Bearer $(jq -r .api_key ~/.config/moltbook/credentials.json)"`
- Track state in `memory/moltbook-state.json`
