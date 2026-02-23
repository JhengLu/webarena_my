# WebArena Docker Source Code Extraction

This directory contains the extracted **source code only** from the WebArena Docker containers.

## Extraction Summary

All Docker container source codes have been successfully extracted and cleaned:

| Container | Size | Type | Status |
|-----------|------|------|--------|
| **gitlab** | 153MB | GitLab CE (source only) | ✅ Complete |
| **shopping** | 115MB | Magento 2.4.6 E-commerce (source only) | ✅ Complete |
| **shopping_admin** | 115MB | Magento 2.4.6 Admin (source only) | ✅ Complete |
| **forum** | 9.1MB | Flarum Forum Application (source only) | ✅ Complete |
| **wikipedia** | 8KB | Kiwix Server (README only) | ⚠️ Binary-only |

**Total Source Code Size**: ~391MB (99.4% reduction from original 64.3GB)

### What Was Removed

To keep only actual source code, the following were removed:
- ❌ `vendor/` directories (Composer/npm dependencies - can be regenerated)
- ❌ `node_modules/` (JavaScript dependencies)
- ❌ `generated/` and `var/` (runtime-generated files and caches)
- ❌ `pub/media/` and `submission_images/` (user-uploaded files: 50GB+ in shopping, 8.3GB in forum)
- ❌ `pub/static/` and `build/` (compiled frontend assets)

## Directory Structure

```
docker_source_code/
├── shopping/
│   └── magento2/           # Magento source code only (115MB)
├── shopping_admin/
│   └── magento2/           # Magento admin source code only (115MB)
├── forum/                  # Flarum forum source code (9.1MB)
├── gitlab/                 # GitLab source code (153MB)
│   ├── gitlab-rails/       # Main GitLab Rails application
│   ├── gitlab-shell/       # Git SSH session handling
│   ├── gitaly-ruby/        # Ruby components for Git storage
│   ├── mattermost/         # Team messaging platform
│   ├── omnibus-ctl/        # GitLab Omnibus utilities
│   └── README.md
├── wikipedia/
│   └── README.md           # Kiwix server documentation (no source code to extract)
└── README.md               # This file
```

## Container Details

### 1. Shopping (115MB - Source Code Only)
- **Type**: Magento 2.4.6 E-commerce Platform
- **Language**: PHP
- **Source Location**: `/var/www/magento2`
- **Contents** (source code only):
  - `app/` - Magento application code
  - `lib/` - Core libraries
  - `setup/` - Installation and upgrade scripts
  - `dev/` - Development tools
  - Configuration files (composer.json, etc.)
- **Removed**: vendor/ (671MB), pub/media/ (50GB), var/ (3.2GB), generated/ (24MB)

### 2. Shopping Admin (115MB - Source Code Only)
- **Type**: Magento 2.4.6 Admin Interface
- **Language**: PHP
- **Source Location**: `/var/www/magento2`
- **Contents** (source code only):
  - Same Magento source structure as shopping
  - Admin-specific configurations
- **Note**: Shares same codebase as shopping but with different runtime configuration
- **Removed**: vendor/ (757MB), pub/media/ (86MB), var/ (638MB), generated/ (29MB)

### 3. Forum (9.1MB - Source Code Only)
- **Type**: Flarum Discussion Forum
- **Language**: PHP + JavaScript
- **Contents** (source code only):
  - Flarum core application source
  - `assets/` - Source assets
  - `config/` - Configuration files
  - `migrations/` - Database migrations
  - `public/` - Essential public files (index.php, etc.)
- **Key Files**:
  - `composer.json` - PHP dependencies list
  - `package.json` - Node.js dependencies list
- **Removed**: node_modules/ (192MB), public/submission_images/ (8.3GB), public/build/ (6.4MB)

### 4. GitLab (153MB - Source Code Only)
- **Type**: GitLab CE (Community Edition)
- **Language**: Ruby on Rails + Go
- **Location**: Multiple service directories
- **Contents**: Source code only (binaries and compiled assets removed)
  - `gitlab-rails/` - Main Rails application (~140MB)
  - `gitlab-shell/` - Git SSH handling (Go source)
  - `gitaly-ruby/` - Git storage service components
  - `mattermost/` - Chat platform integration
  - `omnibus-ctl/` - Control utilities
- **Removed for Space**:
  - Compiled frontend assets
  - Locale/translation files
  - Pre-compiled binaries
  - Documentation

### 5. Wikipedia (README only)
- **Type**: Kiwix Server (Compiled Binary)
- **Version**: kiwix-tools 3.3.0
- **Language**: C++ (compiled binary)
- **Contents**:
  - README with server information
  - Wikipedia served as ZIM file (not extracted)
- **Note**: No source code to extract - uses pre-compiled binary
- **Source Code**: Available at https://github.com/kiwix/kiwix-tools (tag 3.3.0)

## Extraction Scripts

This directory includes scripts to extract source code from the Docker containers:

- **[extract_all_source_code.sh](extract_all_source_code.sh)** - Complete extraction script for all containers
  - Extracts source code from all 5 containers
  - Automatically removes non-source files (dependencies, uploads, caches)
  - Creates clean source-only extractions
  - Usage: `./extract_all_source_code.sh [output_directory]`

- **[extract_gitlab_source.sh](extract_gitlab_source.sh)** - GitLab-specific extraction script
  - Standalone script for extracting only GitLab source code
  - Usage: `./extract_gitlab_source.sh [container_name] [output_directory]`

## Usage Notes

### Working with Extracted Code

Each container's extracted source code can be analyzed, searched, or used for:
- Code review and analysis
- Dependency mapping
- Security audits
- Understanding WebArena benchmark implementations
- Debugging issues

### Regenerating Dependencies

Since vendor directories and dependencies were removed, you can regenerate them if needed:

```bash
# For Shopping/Shopping Admin
cd shopping/magento2/
composer install

cd ../../shopping_admin/magento2/
composer install

# For Forum
cd ../../forum/
composer install
npm install
```

### What You Have Now

This extraction contains **only the actual application source code**:
- ✅ PHP application files
- ✅ JavaScript/TypeScript source files
- ✅ Configuration files
- ✅ Database migration files
- ✅ Templates and views
- ✅ Build scripts and tooling configs

**Not included** (can be regenerated):
- ❌ Third-party dependencies (vendor/, node_modules/)
- ❌ Compiled/minified assets
- ❌ User-uploaded content
- ❌ Runtime caches and generated files
- ❌ Log files

## Extraction Date

All extractions completed on: 2026-02-23

## Container Images Used

- **shopping**: `shopping_final_0712`
- **shopping_admin**: `shopping_admin_final_0719`
- **forum**: `forum_snapshot_20260217_171231`
- **gitlab**: `gitlab-populated-final-port8023`
- **wikipedia**: `ghcr.io/kiwix/kiwix-serve:3.3.0`

## Next Steps

After extraction, you can:
1. Analyze the code structure of each application
2. Search for specific patterns or implementations
3. Review dependencies and security vulnerabilities
4. Compare implementations between shopping and shopping_admin
5. Study how WebArena benchmarks interact with these applications

## Important Notes

- The extracted code represents the **running state** of containers, not clean installations
- Some files may include runtime-generated content, caches, or logs
- For production use, refer to official repositories for each application
- Vendor directories contain third-party dependencies with their own licenses
