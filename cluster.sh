#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# overrides.env always wins — load it first
if [[ -f "$SCRIPT_DIR/overrides.env" ]]; then
    echo "Loading overrides.env"
    # shellcheck source=/dev/null
    source "$SCRIPT_DIR/overrides.env"
else
    echo "No overrides.env found. Copy overrides.env.example to overrides.env to set your values."
fi

# common.env — only sets variables that are not already set
if [[ -f "$SCRIPT_DIR/common.env" ]]; then
    echo "Loading common.env"
    # shellcheck source=/dev/null
    source "$SCRIPT_DIR/common.env"
fi

COMMAND="${1:-help}"
PROVIDER="${2:-}"
shift 2 2>/dev/null || shift "$#"   # remaining args passed through (e.g. CIDRs for allow-ip)
EXTRA_ARGS=("$@")

run_provider() {
    local script="$1"
    shift
    if [[ ! -f "$script" ]]; then
        echo "Error: provider script not found: $script" >&2
        exit 1
    fi
    bash "$script" "$@"
}

case "$COMMAND" in

  create|plan|destroy|info)
    case "$PROVIDER" in
      aws)       run_provider "$SCRIPT_DIR/provider/aws/eks.sh"          "$COMMAND" ;;
      gcp)       run_provider "$SCRIPT_DIR/provider/gcp/gke.sh"          "$COMMAND" ;;
      azure)     run_provider "$SCRIPT_DIR/provider/azure/aks.sh"        "$COMMAND" ;;
      kind)      run_provider "$SCRIPT_DIR/provider/kind/kind.sh"        "$COMMAND" ;;
      openshift) run_provider "$SCRIPT_DIR/provider/rosa/openshift.sh"   "$COMMAND" ;;
      "")
        echo "Error: provider required. Usage: $0 $COMMAND <aws|gcp|azure|kind|openshift>" >&2
        exit 1 ;;
      *)
        echo "Error: unknown provider '$PROVIDER'. Valid: aws, gcp, azure, kind, openshift" >&2
        exit 1 ;;
    esac ;;

  allow-ip)
    case "$PROVIDER" in
      aws)       run_provider "$SCRIPT_DIR/provider/aws/eks.sh"          "allow-ip" "${EXTRA_ARGS[@]}" ;;
      gcp)       run_provider "$SCRIPT_DIR/provider/gcp/gke.sh"          "allow-ip" "${EXTRA_ARGS[@]}" ;;
      azure)     run_provider "$SCRIPT_DIR/provider/azure/aks.sh"        "allow-ip" "${EXTRA_ARGS[@]}" ;;
      kind)      echo "kind clusters are local — IP allowlisting is not applicable." ;;
      openshift) run_provider "$SCRIPT_DIR/provider/rosa/openshift.sh"   "allow-ip" "${EXTRA_ARGS[@]}" ;;
      "")
        echo "Error: provider required. Usage: $0 allow-ip <provider> <CIDR> [CIDR...]" >&2
        exit 1 ;;
      *)
        echo "Error: unknown provider '$PROVIDER'." >&2
        exit 1 ;;
    esac ;;

  allow-port)
    echo "allow-port is not yet implemented." >&2
    echo "To open a port: update your security group rules and re-run: $0 create $PROVIDER" >&2
    exit 1 ;;

  help|--help|-h)
    cat <<EOF
Usage: $0 <command> <provider> [options]

Commands:
  create     <provider>               Create cluster (init → plan → apply → write generated env)
  plan       <provider>               Show Terraform plan without applying
  destroy    <provider>               Destroy cluster and remove generated env file
  info       <provider>               Print generated cluster env (run after create)
  allow-ip   <provider> <CIDR...>     Add CIDRs to the API server allowlist and re-apply
  help                                Show this message

Providers:
  aws         EKS via Terraform  (provider/aws/)
  gcp         GKE via Terraform  (provider/gcp/)
  azure       AKS via Terraform  (provider/azure/)
  openshift   ROSA via scripts   (provider/rosa/)
  kind        Local kind cluster (provider/kind/)

Examples:
  $0 create aws
  $0 plan aws
  $0 destroy aws
  $0 allow-ip aws 203.0.113.0/24
  $0 info aws
EOF
    ;;

  *)
    echo "Unknown command: '$COMMAND'. Run '$0 help' for usage." >&2
    exit 1 ;;

esac
