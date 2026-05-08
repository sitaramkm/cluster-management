#!/usr/bin/env bash
# Extracts the JWKS from the running kind cluster and publishes OIDC discovery
# documents to the GitHub Pages repo at KIND_GITHUB_PAGES_DIR.
# Called automatically by kind.sh create when KIND_OIDC_URL is set.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=kind.env
source "$SCRIPT_DIR/kind.env"

# ---------------------------------------------------------------------------
# Prerequisites
# ---------------------------------------------------------------------------

if [[ -z "${KIND_OIDC_URL:-}" ]]; then
    echo "Error: KIND_OIDC_URL is not set. Set it in overrides.env to use external OIDC." >&2
    exit 1
fi

if [[ -z "${KIND_GITHUB_PAGES_DIR:-}" ]]; then
    echo "Error: KIND_GITHUB_PAGES_DIR is not set." >&2
    echo "Set it in overrides.env to the path of your local sitaramkm.github.io clone." >&2
    exit 1
fi

if [[ ! -d "${KIND_GITHUB_PAGES_DIR}/.git" ]]; then
    echo "Error: KIND_GITHUB_PAGES_DIR='${KIND_GITHUB_PAGES_DIR}' is not a git repository." >&2
    exit 1
fi

command -v kubectl >/dev/null 2>&1 || { echo "Error: kubectl not found" >&2; exit 1; }
command -v jq      >/dev/null 2>&1 || { echo "Error: jq not found" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Fetch JWKS from the running cluster
# ---------------------------------------------------------------------------

echo "Fetching JWKS from cluster '${KIND_CLUSTER_NAME}'..."
jwks="$(kubectl get --raw /openid/v1/jwks)"

# ---------------------------------------------------------------------------
# Build OIDC discovery document
# ---------------------------------------------------------------------------

discovery="$(jq -n \
    --arg issuer   "${KIND_OIDC_URL}" \
    --arg jwks_uri "${KIND_OIDC_URL}/openid/v1/jwks" \
    '{
        issuer:                                $issuer,
        jwks_uri:                              $jwks_uri,
        response_types_supported:              ["id_token"],
        subject_types_supported:               ["public"],
        id_token_signing_alg_values_supported: ["RS256"]
    }')"

# ---------------------------------------------------------------------------
# Write files into the GitHub Pages repo
# ---------------------------------------------------------------------------

# Derive the subpath from the issuer URL (everything after the domain)
# e.g. https://sitaramkm.github.io/ski-001-kind -> ski-001-kind
pages_subpath="${KIND_OIDC_URL#https://}"
pages_subpath="${pages_subpath#*/}"   # strip domain

pages_dir="${KIND_GITHUB_PAGES_DIR}/${pages_subpath}"

mkdir -p "${pages_dir}/.well-known"
mkdir -p "${pages_dir}/openid/v1"

printf '%s\n' "$discovery" > "${pages_dir}/.well-known/openid-configuration"
printf '%s\n' "$jwks"      > "${pages_dir}/openid/v1/jwks"

echo "Written:"
echo "  ${pages_dir}/.well-known/openid-configuration"
echo "  ${pages_dir}/openid/v1/jwks"

# ---------------------------------------------------------------------------
# Commit and push
# ---------------------------------------------------------------------------

cd "${KIND_GITHUB_PAGES_DIR}"
git add "${pages_subpath}/"
git commit -m "Add OIDC documents for kind cluster ${KIND_CLUSTER_NAME}"
git push

echo ""
echo "OIDC documents published: ${KIND_OIDC_URL}"
echo ""
echo "Note: GitHub Pages can take 1-2 minutes to propagate."
echo "Verify: curl ${KIND_OIDC_URL}/.well-known/openid-configuration"
