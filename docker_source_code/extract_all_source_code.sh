#!/bin/bash
#
# WebArena Docker Source Code Extraction Script
#
# This script extracts source code from all WebArena Docker containers
# and removes non-source files (dependencies, uploads, caches, etc.)
#
# Usage: ./extract_all_source_code.sh [OUTPUT_DIR]
#   OUTPUT_DIR: Directory to store extracted source (default: ./docker_source_code)
#
# Author: Claude Code
# Date: 2026-02-23
#

set -e

OUTPUT_DIR="${1:-./docker_source_code}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=================================="
echo "WebArena Source Code Extraction"
echo "=================================="
echo "Output directory: $OUTPUT_DIR"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# ==============================================================================
# 1. FORUM - Flarum Discussion Forum
# ==============================================================================
echo "[1/5] Extracting Forum (Flarum) source code..."

FORUM_CONTAINER="forum"
if docker ps --format '{{.Names}}' | grep -q "^${FORUM_CONTAINER}$"; then
    echo "  → Copying from container: $FORUM_CONTAINER"

    # Extract all files from container root
    docker cp "$FORUM_CONTAINER:/var/www/html/." "$OUTPUT_DIR/forum/"

    echo "  → Cleaning non-source files..."
    # Remove dependencies
    rm -rf "$OUTPUT_DIR/forum/node_modules/" 2>/dev/null || true

    # Remove user uploads (8.3GB!)
    rm -rf "$OUTPUT_DIR/forum/public/submission_images/" 2>/dev/null || true

    # Remove compiled assets
    rm -rf "$OUTPUT_DIR/forum/public/build/" 2>/dev/null || true

    echo "  ✓ Forum extraction complete"
else
    echo "  ⚠ Container '$FORUM_CONTAINER' not running, skipping"
fi

echo ""

# ==============================================================================
# 2. GITLAB - GitLab CE
# ==============================================================================
echo "[2/5] Extracting GitLab source code..."

GITLAB_CONTAINER="gitlab"
if docker ps --format '{{.Names}}' | grep -q "^${GITLAB_CONTAINER}$"; then
    echo "  → Copying GitLab services from container: $GITLAB_CONTAINER"

    mkdir -p "$OUTPUT_DIR/gitlab"

    # Extract main GitLab services
    docker cp "$GITLAB_CONTAINER:/opt/gitlab/embedded/service/gitlab-rails" "$OUTPUT_DIR/gitlab/"
    docker cp "$GITLAB_CONTAINER:/opt/gitlab/embedded/service/gitlab-shell" "$OUTPUT_DIR/gitlab/"
    docker cp "$GITLAB_CONTAINER:/opt/gitlab/embedded/service/gitaly-ruby" "$OUTPUT_DIR/gitlab/"
    docker cp "$GITLAB_CONTAINER:/opt/gitlab/embedded/service/mattermost" "$OUTPUT_DIR/gitlab/"
    docker cp "$GITLAB_CONTAINER:/opt/gitlab/embedded/service/omnibus-ctl" "$OUTPUT_DIR/gitlab/"

    echo "  → Cleaning non-source files..."
    # Remove compiled frontend assets (webpack bundles, minified JS/CSS)
    rm -rf "$OUTPUT_DIR/gitlab/gitlab-rails/public/assets" 2>/dev/null || true

    # Remove locale/translation files (not source code)
    rm -rf "$OUTPUT_DIR/gitlab/gitlab-rails/locale" 2>/dev/null || true

    # Remove documentation
    rm -rf "$OUTPUT_DIR/gitlab/gitlab-rails/doc" 2>/dev/null || true

    # Remove pre-compiled Go binaries
    rm -rf "$OUTPUT_DIR/gitlab/gitlab-shell/bin" 2>/dev/null || true

    # Remove pre-packaged plugin archives
    rm -rf "$OUTPUT_DIR/gitlab/mattermost/prepackaged_plugins" 2>/dev/null || true

    # Remove pre-built mattermost frontend
    rm -rf "$OUTPUT_DIR/gitlab/mattermost/client" 2>/dev/null || true

    echo "  ✓ GitLab extraction complete"
else
    echo "  ⚠ Container '$GITLAB_CONTAINER' not running, skipping"
fi

echo ""

# ==============================================================================
# 3. SHOPPING - Magento 2.4.6 E-commerce
# ==============================================================================
echo "[3/5] Extracting Shopping (Magento) source code..."

SHOPPING_CONTAINER="shopping"
if docker ps --format '{{.Names}}' | grep -q "^${SHOPPING_CONTAINER}$"; then
    echo "  → Copying from container: $SHOPPING_CONTAINER"
    echo "  → This may take a while (large container)..."

    # Extract Magento installation
    docker cp "$SHOPPING_CONTAINER:/var/www/magento2" "$OUTPUT_DIR/shopping/"

    echo "  → Cleaning non-source files..."
    cd "$OUTPUT_DIR/shopping/magento2"

    # Remove Composer dependencies (671MB)
    rm -rf vendor/ 2>/dev/null || true

    # Remove generated files (24MB)
    rm -rf generated/ 2>/dev/null || true

    # Remove runtime cache and logs (3.2GB)
    rm -rf var/ 2>/dev/null || true

    # Remove compiled static assets (7.5MB)
    rm -rf pub/static/ 2>/dev/null || true

    # Remove user-uploaded media files (50GB!)
    rm -rf pub/media/ 2>/dev/null || true

    cd "$SCRIPT_DIR"

    echo "  ✓ Shopping extraction complete"
else
    echo "  ⚠ Container '$SHOPPING_CONTAINER' not running, skipping"
fi

echo ""

# ==============================================================================
# 4. SHOPPING_ADMIN - Magento 2.4.6 Admin
# ==============================================================================
echo "[4/5] Extracting Shopping Admin (Magento) source code..."

SHOPPING_ADMIN_CONTAINER="shopping_admin"
if docker ps --format '{{.Names}}' | grep -q "^${SHOPPING_ADMIN_CONTAINER}$"; then
    echo "  → Copying from container: $SHOPPING_ADMIN_CONTAINER"
    echo "  → This may take a while (large container)..."

    # Extract Magento installation
    docker cp "$SHOPPING_ADMIN_CONTAINER:/var/www/magento2" "$OUTPUT_DIR/shopping_admin/"

    echo "  → Cleaning non-source files..."
    cd "$OUTPUT_DIR/shopping_admin/magento2"

    # Remove Composer dependencies (757MB)
    rm -rf vendor/ 2>/dev/null || true

    # Remove generated files (29MB)
    rm -rf generated/ 2>/dev/null || true

    # Remove runtime cache and logs (638MB)
    rm -rf var/ 2>/dev/null || true

    # Remove compiled static assets (7.9MB)
    rm -rf pub/static/ 2>/dev/null || true

    # Remove user-uploaded media files (86MB)
    rm -rf pub/media/ 2>/dev/null || true

    cd "$SCRIPT_DIR"

    echo "  ✓ Shopping Admin extraction complete"
else
    echo "  ⚠ Container '$SHOPPING_ADMIN_CONTAINER' not running, skipping"
fi

echo ""

# ==============================================================================
# 5. WIKIPEDIA - Kiwix Server (Binary Only)
# ==============================================================================
echo "[5/5] Documenting Wikipedia (Kiwix Server)..."

WIKIPEDIA_CONTAINER="wikipedia"
if docker ps --format '{{.Names}}' | grep -q "^${WIKIPEDIA_CONTAINER}$"; then
    mkdir -p "$OUTPUT_DIR/wikipedia"

    # Get version info
    KIWIX_VERSION=$(docker exec "$WIKIPEDIA_CONTAINER" kiwix-serve --version 2>/dev/null | head -1 || echo "unknown")

    # Create README since it's a binary-only server
    cat > "$OUTPUT_DIR/wikipedia/README.md" << 'EOF'
# Wikipedia Container - Kiwix Server

## Container Information
- **Container Name**: wikipedia
- **Image**: ghcr.io/kiwix/kiwix-serve:3.3.0
- **Type**: Kiwix Wikipedia Server (ZIM file server)

## Architecture

The Wikipedia container uses **Kiwix Server**, which is a lightweight web server designed to serve compressed Wikipedia archives in ZIM format. Unlike traditional web applications with source code, this container primarily consists of:

1. **Kiwix-serve binary** (compiled C++ application)
2. **Wikipedia ZIM file** (compressed Wikipedia content)

## Software Versions

### Kiwix Tools
- **kiwix-tools**: 3.3.0
- **Binary location**: /usr/local/bin/kiwix-serve

### Dependencies
- **libkiwix**: 11.0.0
- **libzim**: 7.2.2
  - libzstd: 1.5.2
  - liblzma: 5.2.4
  - libxapian: 1.4.18
  - libicu: 58.2.0
- **libxapian**: 1.4.18
- **libcurl**: 7.67.0
- **libmicrohttpd**: 0.9.72
- **libz**: 1.2.12
- **libicu**: 58.2.0
- **libpugixml**: 0.12.0

## Important Notes

### No Traditional Source Code

This container does **not** contain traditional web application source code (PHP, Python, JavaScript, etc.). Instead, it serves pre-compiled Wikipedia content through the Kiwix server binary.

### Source Code Extraction Not Applicable

The Kiwix server is a compiled binary application. To access its source code, you would need to:
1. Visit the Kiwix GitHub repository: https://github.com/kiwix/kiwix-tools
2. Clone the repository for the specific version (3.3.0)

### Alternative: Getting Kiwix Source Code

If you need the actual source code for Kiwix:

```bash
# Clone the kiwix-tools repository
git clone https://github.com/kiwix/kiwix-tools.git
cd kiwix-tools
git checkout 3.3.0

# Clone libkiwix (the core library)
git clone https://github.com/kiwix/libkiwix.git
cd libkiwix
git checkout 11.0.0
```
EOF

    echo "  ✓ Wikipedia documentation created"
else
    echo "  ⚠ Container '$WIKIPEDIA_CONTAINER' not running, skipping"
fi

echo ""

# ==============================================================================
# SUMMARY
# ==============================================================================
echo "=================================="
echo "Extraction Complete!"
echo "=================================="
echo ""
echo "Source code extracted to: $OUTPUT_DIR"
echo ""
echo "Container sizes:"
du -sh "$OUTPUT_DIR"/*/ 2>/dev/null | sort -rh
echo ""
echo "Total size:"
du -sh "$OUTPUT_DIR" 2>/dev/null
echo ""
echo "What was extracted:"
echo "  ✅ Application source code (PHP, JavaScript, Ruby, Go)"
echo "  ✅ Configuration files"
echo "  ✅ Database migrations"
echo "  ✅ Templates and views"
echo ""
echo "What was removed:"
echo "  ❌ vendor/ and node_modules/ (dependencies - can be regenerated)"
echo "  ❌ User-uploaded files (media, images)"
echo "  ❌ Compiled/minified assets"
echo "  ❌ Runtime caches and generated files"
echo ""
echo "To regenerate dependencies:"
echo "  cd $OUTPUT_DIR/shopping/magento2 && composer install"
echo "  cd $OUTPUT_DIR/shopping_admin/magento2 && composer install"
echo "  cd $OUTPUT_DIR/forum && composer install && npm install"
echo ""
