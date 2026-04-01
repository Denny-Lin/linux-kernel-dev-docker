---
Changes in v2:
- Describe what changed from v1
---

# Linux Kernel Development Environment (M5 Pro)

A clean, reproducible, Docker-based Linux kernel development environment
optimized for Apple Silicon (M5 Pro). Designed for learning and
contributing to the upstream Linux kernel.

------------------------------------------------------------------------

## Quick Start

### 1. Build Docker Image

docker build --platform linux/arm64 -t kernel-dev .

### 2. Run Development Container

docker run -it --rm\
--privileged\
--platform linux/arm64\
-v "\$(pwd)/linux:/linux-kernel"\
-w /linux-kernel\
-e GIT_AUTHOR_NAME="Your Name"\
-e GIT_AUTHOR_EMAIL="your@email.com"\
-e GIT_COMMITTER_NAME="Your Name"\
-e GIT_COMMITTER_EMAIL="your@email.com"\
kernel-dev

------------------------------------------------------------------------

## Base Trees

### mainline (default for most work)

Use this for documentation fixes, driver work, and normal upstream
patches.

git clone https://github.com/torvalds/linux.git\
cd linux\
git switch -c my-fix

------------------------------------------------------------------------

### staging (only for drivers/staging)

Use this when your change is in drivers/staging/.

git clone
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git\
cd staging\
git switch -c my-fix

------------------------------------------------------------------------

### linux-next (advanced use)

Use this for integration testing and tracking subsystem merges. It is
not the usual starting point for an upstream patch.

git clone
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git\
cd linux-next\
git switch -c my-fix

------------------------------------------------------------------------

## Clean Working Tree

git reset --hard\
git clean -fd\
git status

------------------------------------------------------------------------

## Finding Issues

./scripts/checkpatch.pl --no-tree -f drivers/staging/... \| grep WARNING

Note: Do not blindly fix warnings. Always verify logic.

------------------------------------------------------------------------

## Finding Maintainers (Very Important)

./scripts/get_maintainer.pl -f `<file_path>`{=html}

Example:

./scripts/get_maintainer.pl -f drivers/staging/xxx/xxx.c

This will output:

-   Maintainer emails
-   Relevant mailing lists
-   Reviewers

------------------------------------------------------------------------

## Sending Patch

git send-email\
--to="maintainer@email.com"\
--cc="mailing-list@domain.com"\
0001-\*.patch

Notes:

-   Always include both maintainers AND mailing lists
-   Do NOT guess recipients manually
-   Do NOT send only to one person
-   Do NOT CC unrelated maintainers

------------------------------------------------------------------------

## Build Verification (Important)

make defconfig\
make prepare modules_prepare\
make M=drivers/staging/...

Or full build:

make -j\$(nproc)

------------------------------------------------------------------------

## Generate Patch (v1)

git format-patch -1\
./scripts/checkpatch.pl 0001-\*.patch

------------------------------------------------------------------------

## Updating Patch (v2)

When you receive feedback:

### 1. Amend commit

git commit --amend

Add change log below the separator:

### 2. Generate v2 patch

git format-patch --subject-prefix='PATCH v2' -1

Verify:

head -n 10 0001-\*.patch

Expected:

Subject: \[PATCH v2\] ...

------------------------------------------------------------------------

### 3. Send v2

Usually send as a reply to the same thread:

git send-email\
--in-reply-to="`<message-id>`{=html}"\
0001-\*.patch

IMPORTANT:

If a maintainer asks for a new thread, resend as a new email WITHOUT
--in-reply-to.

------------------------------------------------------------------------

## Updating Patch (v3 and later)

If more changes are requested:

-   Increment version: v3, v4, v5
-   Update changelog accordingly

If explicitly requested, always send as a new thread.

------------------------------------------------------------------------

## Best Practices

-   Always build before sending patches
-   Use plain text emails only
-   One patch should contain one logical change
-   Keep commit message consistent with actual code changes
-   Verify warnings manually, do not rely only on checkpatch

------------------------------------------------------------------------

## Goal

-   Fix a warning
-   Submit a patch (v1)
-   Improve and resend (v2, v3...)
-   Get accepted upstream
