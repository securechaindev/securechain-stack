# Secure Chain Stack

Docker-based infrastructure for SecureChain project databases and tools.

## Overview

This stack provides a complete infrastructure for SecureChain project, orchestrating multiple containerized services:

- **Neo4j**: Graph database storing dependency relationships between software packages, libraries, and their versions. Accessible via HTTP (port 7474) and Bolt protocol (port 7687).
- **MongoDB**: Document database containing vulnerability information, CVE data, and security advisories. Accessible on port 27017.
- **Tools**: Secure Chain microservices for automated software supply chain analysis, vulnerability detection, and dependency extraction.

The stack supports two deployment profiles:
- `stable`: Uses pinned, tested versions for production deployments
- `latest`: Uses current versions for development and testing new features

## Prerequisites

Before starting, ensure you have the following installed:

- **Docker Engine 20.10+**: Container runtime for running all services
- **Docker Compose V2**: Required for orchestrating multi-container applications
- **`make` utility**: Used to run build and deployment commands from the makefile
- **`zstd`**: Compression tool needed to extract database dumps from Zenodo
- **System Resources**:
  - Minimum 4GB RAM (Neo4j and MongoDB require memory for optimal performance)
  - At least 10GB free disk space for images, containers, and database data

## Quick Start

Follow these steps to get the stack running:

### 1. Create the SecureChain Docker network

This creates an isolated network for service communication using `make network-create` command.

### 2. Configure environment variables

Create a `.env` file using `make generate-env` command, and fill it in with your information where necessary.

#### Get API Keys

- How to get a *GitHub* [API key](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens).

- Modify the **Json Web Token (JWT)** secret key and algorithm with your own. You can generate your own secret key with the command **openssl rand -base64 32**.

**Security Note**: Always change default credentials before deploying to production environments.

Generate configuration files:
```bash
make generate-env                    # Uses stable profile (default)
make generate-env PROFILE=latest     # Uses latest profile
```

The `generate-env` script only creates files if they don't exist, preserving any manual changes you've made.

### 3. Download database dumps from Zenodo (optional but recommended)

Downloads and extracts Neo4j and MongoDB seed data from Zenodo with `make download-dump` command. This step is optional because it does not affect the correct deployment of the tools, but if you want to use the extracted graph data for your software supply chain analysis, it is a recommended step. It should also be noted that the dump can be large, so **a good internet connection is required**.

### 4. Start services

Launches Neo4j and MongoDB containers in foreground mode with `make up MODE=databases` command. Then you can deploy the tools with the command `make up MODE=tools`. Or just deploy everything with the command `make up MODE=all`. A decoupled deployment behavior has been left for tools and databases to facilitate maintenance and debugging.

Once running the tools, access http://localhost to view the web user interface.

## Available Commands

The makefile provides the following commands:

```bash
make help
  # Display help with all available commands and usage examples

make network-create
  # Create the 'securechain' Docker network if it doesn't exist
  # This network enables communication between containers

make generate-env [PROFILE=stable|latest]
  # Generate .env and .env.local files from profile templates
  # Only creates files if they don't exist (preserves manual edits)
  # Default profile: stable

make download-dump
  # Download database dumps from Zenodo repository
  # Extracts only the seeds/ folder with Neo4j and MongoDB data
  # Requires zstd compression tool

make up MODE=<mode> [PROFILE=stable|latest]
  # Start services based on MODE:
  #   MODE=all        - Start databases and tools (detached mode)
  #   MODE=databases  - Start only Neo4j and MongoDB (foreground)
  #   MODE=tools      - Start only SecureChain tools (foreground)
  # Automatically creates network and generates env files

make down
  # Stop and remove all running containers (databases and tools)
  # Preserves volumes and data

make restart
  # Equivalent to running 'make down' followed by 'make up'
  # Uses the same MODE as the previous 'up' command
```

## Profiles

The stack supports two deployment profiles to accommodate different environments:

| Profile | Description | Use Case |
|---------|-------------|----------|
| `stable` | Uses pinned, tested versions of all services | Production deployments, reproducible builds, CI/CD pipelines |
| `latest` | Uses the most recent versions available | Development, testing new features, staying up-to-date |

Profile templates are located in `profiles/.env.stable.template` and `profiles/.env.latest.template`.

To switch profiles:
```bash
# Remove existing environment files
rm .env .env.local

# Generate new files with desired profile
make generate-env PROFILE=latest

# Restart services with new configuration
make down
make up MODE=all
```

## License

[GNU General Public License 3.0](https://www.gnu.org/licenses/gpl-3.0.html)

## Links
- [Secure Chain Team](mailto:hi@securechain.dev)
- [Secure Chain Organization](https://github.com/securechaindev)
- [Secure Chain Documentation](https://securechaindev.github.io/)
