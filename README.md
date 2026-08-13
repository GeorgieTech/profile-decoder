# Profile Decoder

**Savant / RacePoint control system profile XML → plain-English explanation**

A client-side web tool that turns dense device profile XML into readable control logic, zone-stack timing, and field notes. Built for AV integrators and Savant programmers.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Client-side](https://img.shields.io/badge/runs-100%25%20in%20browser-brightgreen.svg)
![TrueNAS](https://img.shields.io/badge/TrueNAS%20SCALE-Custom%20App-blue.svg)

## What it does

- **Decoder** — upload one RacePoint profile: identity, power timing, control path, services, field implications  
- **Zone Stack** — load up to 6 profiles: combined timing, preferable interconnects, realized services  
- **Case Study** — theater startup narrative (host triggers, Meridian zone path, 13 s / 65 s masking)  
- **Field stopwatches** — three timers that stay visible across tabs for cold-start testing  

Everything runs in the browser. Profile files are not uploaded to a server.

**v1.1** focuses on real-world zone behavior: timing, state gates, host/extender backbone, and multi-device stacks.

## Quick start (desktop)

1. Open [`index.html`](index.html) in Chrome (or any modern browser).  
2. Drop a Savant/RacePoint profile XML (or `.txt` export).  
3. Read the decoded output; use **Zone Stack** / **Case Study** as needed.

## Install on TrueNAS SCALE

This repo is packaged as a small **nginx** container for TrueNAS **Custom Apps**.

| File | Purpose |
|------|---------|
| `Dockerfile` | Build image (`nginx:alpine` + static UI) |
| `nginx.conf` | Static site + `/healthz` |
| `compose.yaml` | Port **8088→80**, read-only rootfs |
| [`TRUENAS.md`](TRUENAS.md) | Step-by-step SCALE install |

```bash
docker compose build
docker compose up -d
# → http://<truenas-ip>:8088/
```

See **[TRUENAS.md](TRUENAS.md)** for UI-based Custom App deployment, bind-mount updates, and reverse proxy notes.

## Project layout

```
profile-decoder/
├── index.html      # Full application (single page)
├── Dockerfile      # TrueNAS / Docker image
├── nginx.conf      # Static nginx config
├── compose.yaml    # Compose for SCALE Custom App
├── TRUENAS.md      # TrueNAS install guide
├── LICENSE         # MIT
└── README.md
```

## License

MIT © 2026 George Carrillo

## Author

**George Carrillo**  
Email: [carrilloslife@gmail.com](mailto:carrilloslife@gmail.com)  
GitHub: [github.com/GeorgieTech](https://github.com/GeorgieTech)
