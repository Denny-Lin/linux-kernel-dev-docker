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

## Choosing the Right Workflow (IMPORTANT)

1. Clone a kernel tree (linux-next is OK for finding issues)
2. Run tools to find warnings/errors
3. Identify the affected file paths
4. Run:
   ./scripts/get_maintainer.pl -f <file_path>
5. Choose the correct base tree (NOT linux-next for submission):
   - drivers/staging → staging/staging-testing
   - normal code → mainline (torvalds/linux)
6. Create a branch from that tree
7. Make your change and generate a patch
8. Test the patch on the target tree
9. Optionally test on linux-next for integration
10. Send patch to maintainers + mailing lists

Key idea:
linux-next = finding issues / integration testing  
subsystem trees (or mainline) = where patches are sent

---

### Repository Setup

If this is your first time:

```bash
git clone -o linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
```

If the repository already exists:

```
git branch -vv
git fetch linux-next
git switch --detach linux-next/master
```

### Clean Working Tree

```
git reset --hard\
git clean -fd\
git status
```

------------------------------------------------------------------------

## Finding Issues

./scripts/checkpatch.pl --no-tree -f drivers/staging/... \| grep WARNING

Note: Do not blindly fix warnings. Always verify logic.

------------------------------------------------------------------------

## Checking Before You Start a New Fix

Before working on a bug, check whether someone is already fixing it or discussing it.

### 1. lore.kernel.org (Mailing List Archive)

https://lore.kernel.org/

This is the official archive of Linux kernel mailing lists.

Use it to:
- Check whether the bug has already been reported
- See whether a fix is already under review
- Read maintainer comments and discussion threads

------------------------------------------------------------------------

## Finding Maintainers

./scripts/get_maintainer.pl -f `<file_path>`

Example:

./scripts/get_maintainer.pl -f drivers/staging/xxx/xxx.c

This will output:

-   Maintainer emails
-   Relevant mailing lists
-   Reviewers

## Choosing the Correct Base Tree

After identifying the maintainer and subsystem, choose the correct base tree.

### Example: staging (drivers/staging)

Use this when your change is in `drivers/staging/`.

If the `staging` remote is not already added:

```bash
git remote add staging https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
```

Then:

```bash
git fetch staging
git switch -c my-new-fix --track staging/staging-testing
```

### Clean Working Tree

git reset --hard\
git clean -fd\
git status

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

## Starting a New Patch

### Case 1: New independent patch

Always start from a clean base:

```bash
git fetch linux-next
git switch --detach linux-next/master
```

Once you identify a bug or warning (e.g. from linux-next or build logs),
you must switch to the correct base tree before creating a patch.

------------------------------------------------------------------------

### Case 2: Fixing previous patch (v2, v3...)

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
--in-reply-to="`<message-id>`"\
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

## Writing a Good Commit Message (Very Important)

A kernel patch is not just code. The commit message must clearly explain
what changed and why.

<one-line summary>

<why the change is needed>

<what changed (if not obvious)>

------------------------------------------------------------------------

## Writing Changes in v2, v3...

---
Changes in v2:
- Fix incorrect condition check
- Update commit message for clarity
---

------------------------------------------------------------------------

## Best Practices

- Always build before sending patches
- Use plain text emails only
- One patch should contain one logical change
- Keep commit message consistent with actual code changes

------------------------------------------------------------------------

## Goal

-   Fix a warning
-   Submit a patch (v1)
-   Improve and resend (v2, v3...)
-   Get accepted upstream
