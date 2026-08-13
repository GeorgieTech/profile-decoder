# Profile Decoder — static web UI for TrueNAS SCALE / any Docker host
# Serves the single-page app with nginx (client-side only; no uploads leave the browser)

FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="Profile Decoder"
LABEL org.opencontainers.image.description="Savant RacePoint profile XML decoder — client-side field tool"
LABEL org.opencontainers.image.authors="George Carrillo <carrilloslife@gmail.com>"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/GeorgieTech"

# Minimal static site config
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html

# Optional: drop a favicon-free health response is handled in nginx.conf
EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1/healthz >/dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]
