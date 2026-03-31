# Linux Kernel Development Environment (M5 Pro)

A clean, reproducible, Docker-based Linux kernel development environment optimized for Apple Silicon (M5 Pro).
Designed for learning and contributing to the upstream Linux kernel.

---

## Quick Start

### 1. Build Docker Image

```bash
docker build --platform linux/arm64 -t kernel-dev .
```

### 2. Run Development Container

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

---

## Base Trees

### linux-next (general use)

```bash
git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
cd linux-next
git switch -c my-fix
```

### staging (recommended for drivers/staging)

```bash
git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
cd staging
git switch -c my-fix
```

---

## Clean Working Tree

```bash
git reset --hard
git clean -fd
git status
```

---

## Finding Issues

```bash
./scripts/checkpatch.pl --no-tree -f drivers/staging/... | grep WARNING
```

Note: Do not blindly fix warnings. Always verify logic.

---

## Making Changes

```bash
vi drivers/staging/.../file.c

git add file.c
git commit -s
```

---

## Build Verification (Important)

```bash
make menuconfig   # enable your driver if needed
make -j$(nproc)
```

Or:

```bash
make M=drivers/staging/...
```

Build is the authoritative check.

---

## Generate Patch (v1)

```bash
git format-patch -1
./scripts/checkpatch.pl 0001-*.patch
```

---

## Send Patch (v1)

```bash
git send-email \
  --to="maintainer@email.com" \
  --cc="linux-staging@lists.linux.dev" \
  --cc="linux-kernel@vger.kernel.org" \
  0001-*.patch
```

---

## Updating Patch (v2)

When you receive feedback:

### 1. Amend commit

```bash
git commit --amend
```

Add change log below the separator:

```
---
Changes in v2:
- Describe what changed from v1
```

---

### 2. Generate v2 patch

```bash
git format-patch --subject-prefix='PATCH v2' -1
```

Verify:

```bash
head -n 10 0001-*.patch
```

Expected:

```
Subject: [PATCH v2] ...
```

---

### 3. Send v2 (same thread)

```bash
git send-email \
  --to="maintainer@email.com" \
  --cc="linux-staging@lists.linux.dev" \
  --cc="linux-kernel@vger.kernel.org" \
  --in-reply-to="<message-id>" \
  0001-*.patch
```

---

## Best Practices

- Always build before sending patches
- Use plain text emails only
- One patch should contain one logical change
- Verify warnings manually, do not rely only on checkpatch
- Keep commit messages clear and minimal

---

## Goal

- Fix a warning
- Submit a patch (v1)
- Improve and resend (v2)
- Get accepted upstream
