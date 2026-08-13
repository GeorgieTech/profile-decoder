# Install Profile Decoder on TrueNAS SCALE

Profile Decoder is a **static** web app. XML profiles are parsed **in the browser** — nothing is uploaded to the TrueNAS host beyond loading the page itself.

Recommended path: run the included **Docker / Compose** package as a TrueNAS **Custom App**.

---

## Requirements

- TrueNAS SCALE with **Apps** enabled  
- Ability to deploy a **Custom App** (or Docker Compose app, depending on SCALE version)  
- ~10 MB disk for the image  

Port default in `compose.yaml`: **8088** → container **80**.

---

## Option A — Compose (recommended)

### 1. Copy the project to the NAS

Example dataset path (adjust to your pool):

```text
/mnt/tank/apps/profile-decoder/
```

Include at least:

```text
Dockerfile
nginx.conf
index.html
compose.yaml
```

### 2. Install via TrueNAS UI

**SCALE 24.10+ / 25.x (Apps → Discover → Custom App / YAML):**

1. **Apps** → **Discover Apps** → **Custom App** (or **Install via YAML**).  
2. Paste or upload the contents of `compose.yaml`.  
3. If the UI builds from a directory, set the app directory to the folder that contains `Dockerfile` + `index.html`.  
4. Confirm port mapping **8088:80** (or change the host port).  
5. Deploy.

**Older SCALE (Launch Docker Image only):**

1. On a machine with Docker, build and push an image, **or** build on the NAS shell if you use it.  
2. **Apps** → **Launch Docker Image**.  
3. Image: `profile-decoder:1.1` (or your registry path).  
4. Port forward: container `80` → host `8088` (TCP).  
5. Restart policy: Unless stopped.  
6. Save / Start.

### 3. Build the image (if needed)

From the app directory on a Docker host (or NAS shell with Docker):

```bash
cd /mnt/tank/apps/profile-decoder
docker compose build
docker compose up -d
```

### 4. Open the app

```text
http://<truenas-ip>:8088/
```

Optional: put a reverse proxy (Traefik / Nginx Proxy Manager / TrueNAS app) in front with HTTPS and a hostname such as `profiles.home.lan`.

---

## Option B — TrueNAS host path (no image rebuild on every HTML edit)

If you prefer to edit `index.html` on a dataset without rebuilding:

1. Build once with the Dockerfile.  
2. Mount a host file over the image file:

```yaml
services:
  profile-decoder:
    image: profile-decoder:1.1
    ports:
      - "8088:80"
    volumes:
      - /mnt/tank/apps/profile-decoder/index.html:/usr/share/nginx/html/index.html:ro
    restart: unless-stopped
```

Keep `read_only: true` and tmpfs as in the main `compose.yaml` when possible.

---

## Networking notes

| Setting | Suggestion |
|--------|------------|
| Host port | `8088` (change if used) |
| Container port | `80` |
| Host network mode | Not required |
| GPU / storage | Not required |
| WebUI button | `http://[host]:8088` |

Firewall: allow TCP **8088** on the interface you use to reach Apps (if host firewall is enabled).

---

## Security

- App is **read-only** filesystem in Compose (tmpfs for nginx runtime dirs).  
- **No privileged** mode, **no** Docker socket mount.  
- Profile XML never needs to be stored on the NAS for decoding — users paste/drop files in the browser.  
- Still put HTTPS in front if you expose the UI beyond your LAN.

---

## Update

1. Replace `index.html` (and rebuild if not bind-mounting).  
2. `docker compose build --no-cache && docker compose up -d`  
   or use the TrueNAS Apps **Update** / redeploy flow for the custom app.

---

## Verify

```bash
curl -s http://127.0.0.1:8088/healthz
# → ok
```

Browser: open the UI, drop a RacePoint profile, confirm Decoder output.

---

## Uninstall

Stop and delete the custom app in **Apps**, then remove the dataset folder if you no longer need it.

---

## Author

George Carrillo · MIT License · [github.com/GeorgieTech](https://github.com/GeorgieTech)
