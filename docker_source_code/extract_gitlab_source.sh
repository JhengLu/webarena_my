#!/bin/bash
#
# GitLab Docker Source Code Extraction Script
#
# This script extracts source code from a running GitLab Docker container,
# removing compiled binaries, assets, and other non-source files to keep
# only the actual source code.
#
# Usage: ./extract_gitlab_source.sh [CONTAINER_NAME] [OUTPUT_DIR]
#   CONTAINER_NAME: Name or ID of the GitLab container (default: gitlab)
#   OUTPUT_DIR: Directory to store extracted source (default: ./gitlab)
#

set -e

CONTAINER_NAME="${1:-gitlab}"
OUTPUT_DIR="${2:-./gitlab}"

echo "=== GitLab Source Code Extraction Script ==="
echo "Container: $CONTAINER_NAME"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Check if container exists and is running
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Error: Container '$CONTAINER_NAME' is not running."
    echo "Available containers:"
    docker ps --format '  {{.Names}} ({{.Image}})'
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "[1/7] Extracting gitlab-rails..."
docker cp "$CONTAINER_NAME":/opt/gitlab/embedded/service/gitlab-rails "$OUTPUT_DIR/"

echo "[2/7] Extracting gitlab-shell..."
docker cp "$CONTAINER_NAME":/opt/gitlab/embedded/service/gitlab-shell "$OUTPUT_DIR/"

echo "[3/7] Extracting gitaly-ruby..."
docker cp "$CONTAINER_NAME":/opt/gitlab/embedded/service/gitaly-ruby "$OUTPUT_DIR/"

echo "[4/7] Extracting mattermost..."
docker cp "$CONTAINER_NAME":/opt/gitlab/embedded/service/mattermost "$OUTPUT_DIR/"

echo "[5/7] Extracting omnibus-ctl..."
docker cp "$CONTAINER_NAME":/opt/gitlab/embedded/service/omnibus-ctl "$OUTPUT_DIR/"

echo "[6/7] Removing non-source-code files (binaries, compiled assets, plugins)..."

# Remove compiled frontend assets (webpack bundles, minified JS/CSS)
rm -rf "$OUTPUT_DIR/gitlab-rails/public/assets" 2>/dev/null || true

# Remove locale/translation files (not source code)
rm -rf "$OUTPUT_DIR/gitlab-rails/locale" 2>/dev/null || true

# Remove documentation
rm -rf "$OUTPUT_DIR/gitlab-rails/doc" 2>/dev/null || true

# Remove pre-compiled Go binaries from gitlab-shell
rm -rf "$OUTPUT_DIR/gitlab-shell/bin" 2>/dev/null || true

# Remove pre-packaged plugin archives from mattermost
rm -rf "$OUTPUT_DIR/mattermost/prepackaged_plugins" 2>/dev/null || true

# Remove pre-built mattermost frontend
rm -rf "$OUTPUT_DIR/mattermost/client" 2>/dev/null || true

echo "[7/7] Calculating final size..."
echo ""
echo "=== Extraction Complete ==="
echo ""
echo "Source code components:"
du -sh "$OUTPUT_DIR"/*/ 2>/dev/null | sort -rh
echo ""
echo "Total size:"
du -sh "$OUTPUT_DIR"
echo ""
echo "Source code extracted to: $OUTPUT_DIR"
echo ""
echo "Main components:"
echo "  - gitlab-rails/  : Main GitLab Rails application (web UI, API, business logic)"
echo "  - gitlab-shell/  : Git SSH session handling (Go source in cmd/, internal/)"
echo "  - gitaly-ruby/   : Ruby components for Git storage service"
echo "  - mattermost/    : Team messaging platform (templates, i18n, fonts)"
echo "  - omnibus-ctl/   : GitLab Omnibus control utilities"
