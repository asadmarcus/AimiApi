FROM python:3.11-slim

# Install system dependencies for browsers (including GTK3 and Xvfb for headless)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 libgbm1 \
    libpango-1.0-0 libcairo2 libasound2 \
    libxshmfence1 libglu1-mesa fonts-liberation \
    libgtk-3-0 libgdk-pixbuf-2.0-0 \
    libdbus-glib-1-2 libxt6 libx11-xcb1 \
    xvfb dbus-x11 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Create necessary directories
RUN mkdir -p chrome_grecaptcha

# Set display for headless browser
ENV DISPLAY=:99

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/api/v1/models', timeout=5)"

# Create startup script with proper Xvfb management
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Starting Xvfb..."\n\
Xvfb :99 -screen 0 1280x1024x24 -nolisten tcp -ac +extension GLX +render -noreset &\n\
XVFB_PID=$!\n\
echo "Xvfb started with PID $XVFB_PID"\n\
sleep 3\n\
export DISPLAY=:99\n\
echo "DISPLAY set to $DISPLAY"\n\
echo "Starting Python application..."\n\
python src/main.py' > /app/start.sh && chmod +x /app/start.sh

# Run with startup script
CMD ["/bin/bash", "/app/start.sh"]
