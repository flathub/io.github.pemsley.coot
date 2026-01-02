#!/usr/bin/env bash
set -euo pipefail

# Make paths independent of current working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Update submodules (init if needed)
pushd "$REPO_ROOT" >/dev/null
git submodule update --init --recursive --force
# Only attempt to unshallow when a submodule is shallow
git submodule foreach --recursive '
  if git rev-parse --is-shallow-repository >/dev/null 2>&1 && [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
    git fetch --unshallow || true
  fi
'
popd >/dev/null

PIP_DIR="${REPO_ROOT}/deps/flatpak-builder-tools/pip"
if [ ! -d "$PIP_DIR" ]; then
  echo "Error: pip tools directory not found: $PIP_DIR" >&2
  exit 1
fi

pushd "$PIP_DIR" >/dev/null
# Install uv if not available
if ! command -v uv >/dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh || { echo "uv install failed" >&2; }
  export PATH="$HOME/.local/bin:$PATH"
fi

# Prefer using uv to manage virtualenv if a pyproject.toml is present
if command -v uv >/dev/null && [ -f "./pyproject.toml" ]; then
  if ! uv sync; then
    echo "Warning: 'uv sync' failed; attempting to proceed by installing required Python packages via pip" >&2
    python3 -m pip install --user requirements-parser PyYAML || { echo "pip install failed" >&2; popd >/dev/null; exit 1; }
  else
    # Activate venv if present after a successful uv sync
    if [ -f "./venv/bin/activate" ]; then
      # shellcheck disable=SC1091
      source ./venv/bin/activate
    fi
  fi
else
  echo "Note: no pyproject.toml found or 'uv' unavailable; installing required Python packages via pip" >&2
  python3 -m pip install --user requirements-parser PyYAML || { echo "pip install failed" >&2; popd >/dev/null; exit 1; }
fi
popd >/dev/null

# Run generator from repository root so relative paths resolve
pushd "$REPO_ROOT" >/dev/null
"${PIP_DIR}/flatpak-pip-generator" \
    --runtime='org.gnome.Sdk//49' \
    --requirements-file="${REPO_ROOT}/deps/requirements.txt" \
    --output="${REPO_ROOT}/deps/pypi-dependencies" \
    --checker-data
"${PIP_DIR}/flatpak-pip-generator" \
    --runtime='org.gnome.Sdk//49' \
    --output="${REPO_ROOT}/deps/servalcat" \
    --checker-data \
    servalcat
popd >/dev/null

echo "pypi dependencies generation complete"
