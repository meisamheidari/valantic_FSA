# DevOps Challenge – Build & Release Packaging

This repository demonstrates a small automation that packages source files into a versioned tarball, stores it under `release/`, and performs a simple delivery step by copying the artifact to `delivery/`.

It also demonstrates a minimal Git workflow (feature branch → merge to `main` → release tag).

---

## Repository Contents

- `build_package.sh` – build and packaging automation
- `VERSION` – plain text version number (e.g. `1.0.0`)
- `src/` – sample source files (`.sh`, `.py`, `.js`)
- `release/` – generated release artifacts (`.tar.gz`)
- `delivery/` – simulated delivery target directory
- `build.log` – build output log (created/updated by the script)

---

## Prerequisites

**OS assumptions**
- Linux or macOS (tested on bash-compatible shells)

**Tools**
- `bash`
- `tar`
- `find`, `date`, `cp`, `rm` (standard Unix tools)
- `git` (for the workflow/tagging steps)

Verify tools are available:
```bash
bash --version
tar --version
git --version
```

---

## How to Run the Script

From the repository root directory:

```bash
chmod +x build_package.sh
./build_package.sh
```

---

## Git Workflow

This repository demonstrates a simple and clear Git workflow that reflects common development and release practices.

1. The repository is initialized with sample source files on the `main` branch  
2. Development work is performed on a dedicated feature branch  
3. The feature branch is merged back into `main` after completion  
4. A release is created by tagging the corresponding commit in Git  

This approach ensures traceability between source code, changes, and released artifacts.

### Feature Branch Example

```bash
git checkout -b feature/example-change
git add -A
git commit -m "Example feature change"
git checkout main
git merge feature/example-change
git push origin main
```

## Possible Improvements for Production Use

If this solution were extended for use in a production environment, the following improvements would be considered:

- **CI/CD pipeline integration**  
  Automate build, packaging, and release steps using systems such as GitHub Actions, GitLab CI or Jenkins.

- **Artifact repository**  
  Store generated artifacts in a dedicated artifact repository (e.g. Nexus, Artifactory, or S3) instead of committing binaries to Git.

- **Checksum generation and artifact signing**  
  Generate checksums (e.g. SHA256) and optionally sign artifacts to ensure integrity and authenticity.

- **Semantic version validation**  
  Enforce semantic versioning rules for the `VERSION` file to prevent invalid releases.