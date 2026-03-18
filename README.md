# Linux Kernel Development Environment (M5 Pro)

A Dockerized Linux kernel development environment optimized for Apple Silicon (M5 Pro).  
This setup provides an isolated, reproducible workspace for building, testing, and contributing to the Linux kernel.

---

## Quick Start

### 1. Build Docker Image
```bash
docker build --platform linux/arm64 -t kernel-dev .
```

### 2. Run Development Container
Mount your local Linux source tree and start a privileged container:

```bash
docker run -it --rm \
  --privileged \
  --platform linux/arm64 \
  -v $(pwd)/linux:/linux-kernel \
  kernel-dev
```

---

## First Contribution Workflow (Staging Clean-up)

### 1. Find Issues
Scan for coding style warnings in staging drivers:

```bash
./scripts/checkpatch.pl -f drivers/staging/rtl8192e/rtl_core.c | grep "WARNING"
```

### 2. Fix and Commit
After fixing issues, sign your commit:

```bash
git add <file>
git commit -s -m "staging: <driver>: <description>"
```

### 3. Generate Patch
```bash
git format-patch -1
./scripts/checkpatch.pl 0001-*.patch
```

### 4. Send Patch via Email
```bash
git send-email \
  --smtp-server=smtp.gmail.com \
  --smtp-server-port=587 \
  --smtp-encryption=tls \
  --smtp-user=your-email@gmail.com \
  --to="maintainer@example.com" \
  --cc="linux-kernel@vger.kernel.org" \
  0001-*.patch
```

---

## Security Notes

- Never store Gmail app passwords in your Dockerfile or repository.
- Use a Google-generated 16-digit App Password when prompted.
- Consider backing up your `my-patches/` directory to track contributions.

---

## Features

- Apple Silicon (ARM64) support
- Docker-based reproducible environment
- Kernel build & patch workflow
- Ready for upstream contribution

---

## Goal

Make at least one meaningful kernel contribution:
- Fix a warning
- Submit a patch
- Learn the workflow

Start small. Ship something.
