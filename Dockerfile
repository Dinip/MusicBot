FROM alpine:3.11

# Add project source
WORKDIR /opt/musicbot
COPY . ./

# Install dependencies
RUN apk update \
&& apk add --no-cache \
  ca-certificates \
  ffmpeg \
  opus \
  python3 \
  libsodium-dev \
  git

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps \
  gcc \
  git \
  libffi-dev \
  make \
  musl-dev \
  python3-dev


# Install pip dependencies
RUN cd /opt/musicbot && \
    pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# Clean up build dependencies
RUN apk del .build-deps

WORKDIR /opt/musicbot

# Create volume for mapping the config
VOLUME /opt/musicbot/config
VOLUME /opt/musicbot/audio_cache

ENV APP_ENV=docker

ENTRYPOINT ["python3", "dockerentry.py"]