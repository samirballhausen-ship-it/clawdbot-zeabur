FROM node:22-slim

# System-Dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clawdbot global installieren
RUN npm install -g clawdbot@latest

# Config-Files kopieren
COPY clawdbot.json /root/.clawdbot/clawdbot.json
COPY workspace/ /app/workspace/

# Health-Check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:${PORT:-18789}/health || exit 1

# Port (wird von Zeabur dynamisch gesetzt)
EXPOSE ${PORT:-18789}

# Start-Script mit Logging
CMD ["sh", "-c", "echo 'Starting Clawdbot Gateway...' && \
     echo 'Port: $PORT' && \
     clawdbot gateway start --port ${PORT:-18789} --bind 0.0.0.0"]
