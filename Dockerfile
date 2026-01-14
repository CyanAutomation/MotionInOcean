FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg curl ca-certificates && \
    curl -Lfs https://archive.raspberrypi.org/debian/raspberrypi.gpg.key -o /tmp/raspberrypi.gpg.key && \
    gpg --dearmor -o /usr/share/keyrings/raspberrypi.gpg /tmp/raspberrypi.gpg.key && \
    echo "deb [signed-by=/usr/share/keyrings/raspberrypi.gpg] http://archive.raspberrypi.org/debian/ bookworm main" > /etc/apt/sources.list.d/raspi.list && \
    rm /tmp/raspberrypi.gpg.key && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        python3-picamera2 \
        python3-opencv \
        python3-flask && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------------------------
# Build and run application
# ------------------------------------------------------------------------------------------------
# Set the working directory
WORKDIR /app

# Copy the Python files
COPY pi_camera_in_docker /app/pi_camera_in_docker

# Set the entry point
CMD ["python3", "/app/pi_camera_in_docker/main.py"]
