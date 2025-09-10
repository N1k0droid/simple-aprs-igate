FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install required packages
RUN apt-get update && apt-get install -y \
    rtl-sdr \
    direwolf \
    netcat \
    gettext-base \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /logs

# Working directory
WORKDIR /

# Default command will be overridden by docker-compose
CMD ["/scripts/startup.sh"]
