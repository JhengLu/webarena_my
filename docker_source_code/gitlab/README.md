# GitLab Source Code (Extracted from Docker)

This directory contains the source code extracted from a running GitLab Docker container (`gitlab-populated-final-port8023`).

## Directory Structure

```
gitlab/
├── gitlab-rails/     # Main GitLab application (Ruby on Rails) - 142 MB
├── gitlab-shell/     # Git SSH handler (Go) - 1.2 MB
├── gitaly-ruby/      # Git storage Ruby helpers - 1.9 MB
├── mattermost/       # Team chat platform (bundled) - 7.8 MB
└── omnibus-ctl/      # GitLab control utilities - 176 KB
```

## Component Details

### gitlab-rails (Main Application)

The core GitLab web application written in Ruby on Rails. This is where most GitLab functionality lives.

**Key directories:**
- `app/` - MVC application code
  - `app/controllers/` - HTTP request handlers
  - `app/models/` - Database models (ActiveRecord)
  - `app/views/` - HTML templates (ERB)
  - `app/services/` - Business logic services
  - `app/workers/` - Background job processors (Sidekiq)
- `lib/` - Shared libraries and utilities
- `config/` - Application configuration
- `db/` - Database migrations and schema

**What it handles:**
- Web UI (everything you see in the browser)
- REST API (`/api/v4/`)
- GraphQL API (`/api/graphql`)
- Issues, Merge Requests, CI/CD pipelines
- User authentication and permissions
- Repository browsing (via Gitaly)

### gitlab-shell (Git SSH Handler)

Handles Git operations over SSH. Written in Go for performance.

**Key directories:**
- `cmd/` - Command entry points
- `internal/` - Core implementation
- `client/` - Client libraries

**What it handles:**
- `git clone git@gitlab:user/repo.git`
- `git push` / `git pull` over SSH
- SSH key authentication
- Authorization checks

### gitaly-ruby (Git Storage Helpers)

Ruby components for the Gitaly service (Git repository storage).

**What it handles:**
- Complex Git operations that require Ruby
- Legacy operations migrated from gitlab-rails
- Helper scripts for Gitaly (main Gitaly is in Go, not included here)

### mattermost (Team Chat - Optional)

A Slack-like team messaging platform bundled with GitLab.

**Note:** This is a separate product, not core GitLab functionality.

**Key directories:**
- `templates/` - Email and notification templates
- `i18n/` - Internationalization files
- `fonts/` - Font assets

### omnibus-ctl (Control Utilities)

Scripts for managing GitLab Omnibus installation.

**What it handles:**
- `gitlab-ctl reconfigure`
- `gitlab-ctl restart`
- `gitlab-ctl status`

## What Was Removed

The following non-source-code files were removed to reduce size (1.1 GB → 153 MB):

| Removed Directory | Size | Content |
|-------------------|------|---------|
| `gitlab-rails/public/assets/` | 336 MB | Compiled webpack bundles (JS/CSS) |
| `gitlab-rails/locale/` | 86 MB | Translation files |
| `gitlab-rails/doc/` | 50 MB | Documentation |
| `gitlab-shell/bin/` | 99 MB | Pre-compiled Go binaries |
| `mattermost/prepackaged_plugins/` | 208 MB | Plugin archives (.tar.gz) |
| `mattermost/client/` | 122 MB | Pre-built React frontend |
| `grafana/` | 84 MB | Monitoring dashboards (binaries) |

## Extraction Script

To re-extract from a running GitLab container:

```bash
./extract_gitlab_source.sh [CONTAINER_NAME] [OUTPUT_DIR]

# Example:
./extract_gitlab_source.sh gitlab ./gitlab
```

## Original Container Info

- **Container Name:** gitlab
- **Image:** gitlab-populated-final-port8023
- **Port:** 8023
- **Source Path:** `/opt/gitlab/embedded/service/`
