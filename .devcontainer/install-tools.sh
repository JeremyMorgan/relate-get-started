#!/usr/bin/env bash
# Installs the pinned lab tools. Runs once, when the container image is built.
#
# Every download is checked against a SHA-256 recorded in this file, so a build
# either produces the exact binaries below or fails. To move to a new release,
# change the version and both checksums, then rebuild. See INSTRUCTOR_GUIDE.md.
set -euo pipefail

# Relate CLI. Checksums come from the signed SHA256SUMS file of the release:
# https://github.com/relatedb/relate/releases/download/<version>/SHA256SUMS
RELATE_VERSION="v1.0.1"
RELATE_SHA256_AMD64="2ca69bd6440d25b78c1677d11c0e3f2f5722601a4984475b331abc0a4f9fed2a"
RELATE_SHA256_ARM64="6d8d37530070f238ac5578c1a6c69c737d7bd919b89e43ce2b631b612e8f9303"

# DuckDB CLI. Only the optional Parquet step in Lesson 3 uses it.
# Checksums are of the release archives, computed with sha256sum.
DUCKDB_VERSION="v2.0.0"
DUCKDB_SHA256_AMD64="c6507206baf7793c6013dbd82368469a45f20dc0e17a6f92f204602f652ed2bc"
DUCKDB_SHA256_ARM64="859e1875d2a9515fbb4bf8871061437a14af82320da68c753f094c4b776348fe"

# LAB_PREFIX exists so the script can be tested outside the image.
PREFIX="${LAB_PREFIX:-/usr/local}"

case "$(uname -m)" in
  x86_64 | amd64)
    arch="amd64"
    relate_sha="${RELATE_SHA256_AMD64}"
    duckdb_sha="${DUCKDB_SHA256_AMD64}"
    ;;
  aarch64 | arm64)
    arch="arm64"
    relate_sha="${RELATE_SHA256_ARM64}"
    duckdb_sha="${DUCKDB_SHA256_ARM64}"
    ;;
  *)
    echo "install-tools: unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

work="$(mktemp -d)"
trap 'rm -rf "${work}"' EXIT

fetch() {
  # fetch URL FILE
  curl --fail --silent --show-error --location \
    --proto '=https' --tlsv1.2 \
    --retry 5 --retry-delay 2 --retry-all-errors \
    --output "$2" "$1"
}

verify() {
  # verify FILE SHA256
  if ! echo "$2  $1" | sha256sum --check --strict --status -; then
    echo "install-tools: checksum mismatch for $(basename "$1")" >&2
    echo "  expected: $2" >&2
    echo "  actual:   $(sha256sum "$1" | cut -d' ' -f1)" >&2
    exit 1
  fi
}

echo "install-tools: relate ${RELATE_VERSION} (${arch})"
fetch "https://github.com/relatedb/relate/releases/download/${RELATE_VERSION}/relate-linux-${arch}" "${work}/relate"
verify "${work}/relate" "${relate_sha}"
install -D -m 0755 "${work}/relate" "${PREFIX}/bin/relate"

echo "install-tools: duckdb ${DUCKDB_VERSION} (${arch})"
fetch "https://github.com/duckdb/duckdb/releases/download/${DUCKDB_VERSION}/duckdb-cli-linux-${arch}.tar.gz" "${work}/duckdb.tar.gz"
verify "${work}/duckdb.tar.gz" "${duckdb_sha}"
tar -xzf "${work}/duckdb.tar.gz" -C "${work}" duckdb
install -D -m 0755 "${work}/duckdb" "${PREFIX}/bin/duckdb"

# lab-check reads this file to tell a student which versions the lab was tested with.
install -d -m 0755 "${PREFIX}/share/relate-lab"
printf 'RELATE_VERSION=%s\nDUCKDB_VERSION=%s\n' "${RELATE_VERSION}" "${DUCKDB_VERSION}" \
  > "${PREFIX}/share/relate-lab/versions"

# Fail the build now if either binary cannot run on this image.
# RELATE_TELEMETRY=0 keeps the build from sending usage metrics.
RELATE_TELEMETRY=0 "${PREFIX}/bin/relate" --version
"${PREFIX}/bin/duckdb" --version
echo "install-tools: done"
