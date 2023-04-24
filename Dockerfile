FROM alpine:3.17.1

RUN --mount=type=cache,sharing=private,target=/var/cache/apk \
  set -eux; \
  apk upgrade

ARG HEADSCALE_VERSION=0.21.0
ARG HEADSCALE_SHA256=d34e93f3cf530edfe342723d0d9d05e0cce7b17c260faf3c4065d9edd55c5ff3
ARG HEADSCALE_CHIPSET=linux_amd64

RUN --mount=type=cache,target=/var/cache/apk \
  --mount=type=tmpfs,target=/tmp \
  set -eux; \
  cd /tmp; \
  { \
  export \
  HEADSCALE_VERSION=${HEADSCALE_VERSION} \
  HEADSCALE_SHA256=${HEADSCALE_SHA256} \
  HEADSCALE_CHIPSET=${HEADSCALE_CHIPSET}; \
  wget -q -O headscale https://github.com/juanfont/headscale/releases/download/v${HEADSCALE_VERSION}/headscale_${HEADSCALE_VERSION}_${HEADSCALE_CHIPSET}; \
  echo "${HEADSCALE_SHA256} *headscale" | sha256sum -c - >/dev/null 2>&1; \
  chmod +x headscale; \
  mv headscale /usr/local/bin/; \
  }; \
  # smoke tests
  [ "$(command -v headscale)" = '/usr/local/bin/headscale' ]; \
  headscale version