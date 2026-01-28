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

# Run with Xvfb for virtual display
CMD Xvfb :99 -screen 0 1280x1024x24 -nolisten tcp & python src/main.py
