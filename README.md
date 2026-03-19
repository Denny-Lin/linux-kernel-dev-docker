# Linux Kernel Development Environment (M5 Pro)

A professional, Dockerized Linux kernel development environment optimized for Apple Silicon (M5 Pro). This setup provides an isolated and reproducible workspace for building, testing, and contributing to the upstream Linux kernel without affecting your macOS host.

---

## Quick Start

### 1. Build Docker Image
Build the ARM64-native development environment:

```bash
docker build --platform linux/arm64 -t kernel-dev .
```

---

### 2. Run Development Container
Run the container by injecting your Git identity via environment variables. This approach keeps your credentials within the session and out of the container's persistent storage:

```bash
docker run -it --rm \
  --privileged \
  --platform linux/arm64 \
  -v "$(pwd)/linux:/linux-kernel" \
  -w /linux-kernel \
  -e GIT_AUTHOR_NAME="Your Name" \
  -e GIT_AUTHOR_EMAIL="your@email.com" \
  -e GIT_COMMITTER_NAME="Your Name" \
  -e GIT_COMMITTER_EMAIL="your@email.com" \
  kernel-dev
```

> Git identity is not stored in the container to keep the environment stateless and secure.

---

## Contribution Workflow (Staging Clean-up)

### 1. Find Issues
Use the built-in kernel script to find style violations in staging drivers:

```bash
./scripts/checkpatch.pl --no-tree -f drivers/staging/greybus/loopback.c | grep "WARNING"
```

### 2. Fix and Commit
Fix the issue using vi, then commit with your Signed-off-by signature:

```bash
# Edit the file
vi drivers/staging/greybus/loopback.c

# Stage and Commit
git add drivers/staging/greybus/loopback.c
git -c user.name="Your Name" \
    -c user.email="your@email.com" \
    commit -s
```

### 3. Generate Patch
Generate the patch file and send it directly to the maintainers (e.g., Greg Kroah-Hartman):

```bash
git format-patch -1
./scripts/checkpatch.pl 0001-*.patch
```

### 4. Send Patch via Email

```bash
git send-email \
  --to="Greg Kroah-Hartman <gregkh@linuxfoundation.org>" \
  --cc="linux-staging@lists.linux.dev" \
  --cc="linux-kernel@vger.kernel.org" \
  --smtp-server=smtp.gmail.com \
  --smtp-server-port=587 \
  --smtp-encryption=tls \
  --smtp-user="your@email.com" \
  0001-*.patch
```

> You will be prompted for your Gmail App Password at runtime.

---

## Security and Best Practices

- Do not store credentials in Dockerfile, environment variables, or Git
- Always input sensitive data interactively
- Keep the environment stateless and reproducible

---

## Features

- Apple Silicon (ARM64) support
- Docker-based development environment
- Kernel build & patch workflow
- Secure, no credential persistence

---

## Project Structure

```
.
├── Dockerfile
├── README.md
├── .gitignore
└── run.sh
```

---

## Goal

- Fix a warning
- Submit a patch
- Learn kernel workflow

Start small. Ship something.
