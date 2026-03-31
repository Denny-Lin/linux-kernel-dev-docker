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

## Working with linux-next (Recommended)

For upstream contributions, always base your work on **linux-next**, not the mainline tree.

### Fix Git HTTP2 issue (important in Docker)

```bash
git config --global http.version HTTP/1.1
```

### Option A (Recommended): Clone linux-next directly

```bash
git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
cd linux-next
git switch -c my-fix
```

### Option B: Add linux-next to existing repo

```bash
git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
git fetch --depth=1 linux-next
git switch -c my-fix linux-next/master
```

### Ensure clean working tree

```bash
git reset --hard
git clean -fd
git status
```

Expected:

```
nothing to commit, working tree clean
```

---

## Contribution Workflow (Staging Clean-up)

### 1. Find Issues

```bash
./scripts/checkpatch.pl --no-tree -f drivers/staging/greybus/loopback.c | grep "WARNING"
```

---

### 2. Fix and Commit

Make **minimal changes only** (one logical fix per patch):

```bash
vi drivers/staging/greybus/loopback.c

git add drivers/staging/greybus/loopback.c
git -c user.name="Your Name" \
    -c user.email="your@email.com" \
    commit -s
```

---

### 3. Generate Patch

```bash
git format-patch -1
./scripts/checkpatch.pl 0001-*.patch
```

---

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
- Always work on a clean tree before committing
- One patch = one logical change

---

## Features

- Apple Silicon (ARM64) support
- Docker-based development environment
- linux-next workflow support
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
