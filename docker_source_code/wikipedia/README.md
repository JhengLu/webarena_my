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

## Data Files

The container stores Wikipedia content in ZIM format:

**Location**: `/data/`

**Main file**: `wikipedia_en_all_maxi_2022-05.zim` (95GB compressed Wikipedia)

## Important Notes

### No Traditional Source Code

This container does **not** contain traditional web application source code (PHP, Python, JavaScript, etc.). Instead, it serves pre-compiled Wikipedia content through the Kiwix server binary.

### Source Code Extraction Not Applicable

The Kiwix server is a compiled binary application. To access its source code, you would need to:
1. Visit the Kiwix GitHub repository: https://github.com/kiwix/kiwix-tools
2. Clone the repository for the specific version (3.3.0)

### What This Container Provides

- **Pre-compiled binary**: kiwix-serve executable
- **Wikipedia data**: Compressed ZIM archive containing Wikipedia articles
- **Runtime environment**: Alpine Linux with necessary libraries

## Usage in WebArena

In the WebArena project, this container provides:
- Offline Wikipedia access for benchmark tasks
- Fast, compressed Wikipedia content serving
- No database or dynamic content generation required

## Alternative: Getting Kiwix Source Code

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

## Summary

Unlike the other containers (forum, gitlab, shopping), the Wikipedia container:
- ✗ Does not have extractable application source code
- ✓ Uses a compiled binary server (kiwix-serve)
- ✓ Serves compressed Wikipedia content from ZIM files
- ✓ Source code available separately from GitHub
