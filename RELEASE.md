# Release Process

This document describes how to create and publish a new release of motion-in-ocean.

## Overview

Releases are versioned using [Semantic Versioning](https://semver.org/) and published automatically to GitHub Container Registry (GHCR) via GitHub Actions.

## Release Types

- **Patch** (x.y.Z): Bug fixes, documentation updates, small improvements
- **Minor** (x.Y.0): New features, non-breaking changes
- **Major** (X.0.0): Breaking changes, major refactoring

## Creating a Release

### Option 1: Using the Release Script (Recommended)

1. **Ensure working directory is clean:**
   ```bash
   git status
   # Commit any pending changes
   ```

2. **Run the release script:**
   ```bash
   ./create-release.sh
   ```

3. **Follow the prompts:**
   - Enter the new version number (e.g., `1.0.1`)
   - Review the changes
   - Confirm to commit, tag, and push

4. **Monitor the build:**
   - GitHub Actions will automatically build and publish the Docker image
   - Check: https://github.com/hyzhak/pi-camera-in-docker/actions

5. **Create GitHub Release:**
   - Go to: https://github.com/hyzhak/pi-camera-in-docker/releases/new
   - Select the tag you just created
   - Copy release notes from [CHANGELOG.md](CHANGELOG.md)
   - Publish the release

### Option 2: Manual Process

1. **Update VERSION file:**
   ```bash
   echo "1.0.1" > VERSION
   ```

2. **Update CHANGELOG.md:**
   - Add new version section with date
   - List all changes under appropriate categories:
     - Added
     - Changed
     - Deprecated
     - Removed
     - Fixed
     - Security

3. **Commit changes:**
   ```bash
   git add VERSION CHANGELOG.md
   git commit -m "Release v1.0.1"
   ```

4. **Create and push tag:**
   ```bash
   git tag -a v1.0.1 -m "Release v1.0.1"
   git push origin main
   git push origin v1.0.1
   ```

5. **Wait for GitHub Actions to build**

6. **Create GitHub Release** (see step 5 above)

## After Release

### Verify Docker Image

```bash
# Pull the new version
docker pull ghcr.io/hyzhak/pi-camera-in-docker:1.0.1

# Verify architecture
docker inspect ghcr.io/hyzhak/pi-camera-in-docker:1.0.1 | grep Architecture

# Test on Raspberry Pi
docker run --rm ghcr.io/hyzhak/pi-camera-in-docker:1.0.1 python3 --version
```

### Update Documentation

- Update README.md if needed with new features
- Update docker-compose.yml examples if image tag changed
- Announce the release (GitHub Discussions, social media, etc.)

## Docker Image Tags

When you push a tag `v1.2.3`, the following Docker images are created:

- `ghcr.io/hyzhak/pi-camera-in-docker:1.2.3` - Exact version
- `ghcr.io/hyzhak/pi-camera-in-docker:1.2` - Minor version
- `ghcr.io/hyzhak/pi-camera-in-docker:latest` - Latest release

Users can pin to:
- **Exact version** (`1.2.3`) for maximum stability
- **Minor version** (`1.2`) for automatic patch updates
- **Latest** for always getting the newest release

## Troubleshooting

### GitHub Actions fails

- Check the workflow logs: https://github.com/hyzhak/pi-camera-in-docker/actions
- Verify GITHUB_TOKEN has correct permissions
- Ensure Dockerfile builds successfully locally

### Tag already exists

If you need to re-create a tag:
```bash
git tag -d v1.0.1                    # Delete local tag
git push origin :refs/tags/v1.0.1   # Delete remote tag
# Then create the tag again
```

### Wrong version tagged

Do not delete published releases. Instead:
1. Create a new patch release with the fix
2. Mark the incorrect release as "pre-release" on GitHub

## Release Checklist

- [ ] All tests passing
- [ ] CHANGELOG.md updated with changes
- [ ] VERSION file updated
- [ ] Changes committed to main branch
- [ ] Git tag created and pushed
- [ ] GitHub Actions build completed successfully
- [ ] Docker image available in GHCR
- [ ] Docker image tested on actual Raspberry Pi
- [ ] GitHub Release created with release notes
- [ ] Documentation updated (if needed)

## Emergency Rollback

If a release has critical issues:

1. **Update .env on deployments:**
   ```bash
   MOTION_IN_OCEAN_IMAGE_TAG=1.0.0  # Previous working version
   docker compose pull
   docker compose up -d
   ```

2. **Create hotfix release:**
   - Fix the issue
   - Create new patch release (e.g., 1.0.2)
   - Follow normal release process
