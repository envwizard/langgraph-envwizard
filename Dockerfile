FROM ghcr.io/envwizard/python310-base:latest@sha256:df62016190ed8b9655a9da4cc253e729f2117cffe9fef5cba8c1dfd0ff74149a

# Environment variables

# Switch to root to install system dependencies
USER root

WORKDIR /workspace

# Install system dependencies for Python development
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Clone repository
RUN git clone https://github.com/langchain-ai/langgraph /workspace/repo

WORKDIR /workspace/repo

# Create script to copy repository content to workspace
RUN echo '#!/bin/bash' > /usr/local/bin/copy-repo.sh && \
    echo 'echo "Copying repository content to workspace..."' >> /usr/local/bin/copy-repo.sh && \
    echo 'if [ -d "/workspace/repo" ] && [ -d "/workspaces" ]; then' >> /usr/local/bin/copy-repo.sh && \
    echo '  # Find the workspace directory' >> /usr/local/bin/copy-repo.sh && \
    echo '  WORKSPACE_DIR=$(find /workspaces -maxdepth 1 -type d ! -path /workspaces | head -1)' >> /usr/local/bin/copy-repo.sh && \
    echo '  if [ -n "$WORKSPACE_DIR" ] && [ -d "$WORKSPACE_DIR" ]; then' >> /usr/local/bin/copy-repo.sh && \
    echo '    echo "Found workspace directory: $WORKSPACE_DIR"' >> /usr/local/bin/copy-repo.sh && \
    echo '    # Copy repository files to workspace directory' >> /usr/local/bin/copy-repo.sh && \
    echo '    cp -r /workspace/repo/. "$WORKSPACE_DIR/" 2>/dev/null || true' >> /usr/local/bin/copy-repo.sh && \
    echo '    echo "Repository files copied to workspace"' >> /usr/local/bin/copy-repo.sh && \
    echo '  else' >> /usr/local/bin/copy-repo.sh && \
    echo '    echo "No workspace directory found"' >> /usr/local/bin/copy-repo.sh && \
    echo '  fi' >> /usr/local/bin/copy-repo.sh && \
    echo 'else' >> /usr/local/bin/copy-repo.sh && \
    echo '  echo "Source or target directory not found"' >> /usr/local/bin/copy-repo.sh && \
    echo 'fi' >> /usr/local/bin/copy-repo.sh && \
    chmod +x /usr/local/bin/copy-repo.sh

# Setup script
RUN echo '#!/bin/bash' > /tmp/setup.sh && \
    echo 'set -e' >> /tmp/setup.sh && \
    echo "ls -l" >> /tmp/setup.sh && \
    echo "ls -l libs" >> /tmp/setup.sh && \
    echo "ls -l libs/sdk-py" >> /tmp/setup.sh && \
    echo "cat libs/sdk-py/pyproject.toml" >> /tmp/setup.sh && \
    echo "cat libs/sdk-py/uv.lock" >> /tmp/setup.sh && \
    echo "ls -l libs/langgraph" >> /tmp/setup.sh && \
    echo "cat libs/langgraph/pyproject.toml" >> /tmp/setup.sh && \
    echo "ls -l libs/prebuilt" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint-sqlite" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint-postgres" >> /tmp/setup.sh && \
    echo "ls -l libs/cli" >> /tmp/setup.sh && \
    echo "ls -l libs/prebuilt/langgraph" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/langgraph_cli" >> /tmp/setup.sh && \
    echo "ls -l libs/prebuilt/langgraph/prebuilt" >> /tmp/setup.sh && \
    echo "ls -l" >> /tmp/setup.sh && \
    echo "ls -l examples" >> /tmp/setup.sh && \
    echo "ls -l libs/langgraph/langgraph" >> /tmp/setup.sh && \
    echo "ls -l libs/langgraph/tests" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint-sqlite/langgraph" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint/langgraph" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint-postgres/langgraph" >> /tmp/setup.sh && \
    echo "ls -l libs/sdk-js" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/python-monorepo-example" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/python-monorepo-example/libs" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/python-monorepo-example/libs/common" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/python-monorepo-example/libs/shared" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/python-monorepo-example/libs/shared/src" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/python-monorepo-example/libs/shared/src/shared" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/python-monorepo-example/apps" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/python-monorepo-example/apps/agent" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/python-monorepo-example/apps/agent/src" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/python-monorepo-example/apps/agent/src/agent" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/js-examples" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/js-monorepo-example" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/schemas" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/tests" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/tests/unit_tests" >> /tmp/setup.sh && \
    echo "ls -l libs/cli/tests/integration_tests" >> /tmp/setup.sh && \
    echo "ls -l libs/prebuilt/tests" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint/tests" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint-sqlite/tests" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint-postgres/tests" >> /tmp/setup.sh && \
    echo "ls -l libs/sdk-py/tests" >> /tmp/setup.sh && \
    echo "ls -l libs/sdk-py/tests/fixtures" >> /tmp/setup.sh && \
    echo "ls -l libs/prebuilt/langgraph/prebuilt" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint/langgraph/checkpoint" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint-sqlite/langgraph/checkpoint" >> /tmp/setup.sh && \
    echo "ls -l libs/checkpoint-postgres/langgraph/checkpoint" >> /tmp/setup.sh && \
    echo "ls -l libs/langgraph/tests/__snapshots__" >> /tmp/setup.sh && \
    echo "ls -l libs/prebuilt/tests/__snapshots__" >> /tmp/setup.sh && \
    echo "ls -l libs" >> /tmp/setup.sh && \
    echo "ls -l libs/langgraph/pyproject.toml" >> /tmp/setup.sh && \
    echo "ls -l libs/langgraph/uv.lock" >> /tmp/setup.sh && \
    echo "lsb_release -a || cat /etc/os-release" >> /tmp/setup.sh && \
    echo "python3 --version" >> /tmp/setup.sh && \
    echo "pip install uv" >> /tmp/setup.sh && \
    chmod +x /tmp/setup.sh && \
    /tmp/setup.sh

# Switch back to vscode user for development
USER vscode