# Relate Lab dev container.
# One container, no services. Everything the lessons need is a command line tool.
FROM mcr.microsoft.com/devcontainers/base:2.0.5-ubuntu-24.04

# The non-root user the base image ships with. Students work as this user.
ARG USERNAME=vscode
RUN id "${USERNAME}" >/dev/null 2>&1 \
    || { echo "User '${USERNAME}' is missing from the base image. Update USERNAME in the Dockerfile and remoteUser in devcontainer.json." >&2; exit 1; }

# curl and ssh-keygen are what the Relate install script in Lesson 1 needs.
# The base image normally has both. Installing them here makes that a guarantee.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Pinned, checksum-verified relate and duckdb in /usr/local/bin.
COPY install-tools.sh /tmp/install-tools.sh
RUN bash /tmp/install-tools.sh && rm -f /tmp/install-tools.sh

# Helper commands: lab-check, lab-reset, lab-seed.
COPY bin/ /usr/local/bin/
RUN chmod 0755 /usr/local/bin/lab-check /usr/local/bin/lab-reset /usr/local/bin/lab-seed

# The message a student sees in their first terminal.
COPY first-run-notice.txt /usr/local/etc/vscode-dev-containers/first-run-notice.txt

# Lesson 1 installs relate to ~/.local/bin. Put that folder first on PATH so a
# student who runs the installer gets the copy they just installed, and a
# student who skips it gets the pinned copy in /usr/local/bin.
RUN install -d -o "${USERNAME}" -g "${USERNAME}" "/home/${USERNAME}/.local" "/home/${USERNAME}/.local/bin" \
    && printf '%s\n' \
        '# Relate Lab: keep ~/.local/bin first on PATH in login shells too.' \
        'case ":${PATH}:" in' \
        '  *":${HOME}/.local/bin:"*) ;;' \
        '  *) PATH="${HOME}/.local/bin:${PATH}" ;;' \
        'esac' \
        'export PATH' \
        > /etc/profile.d/99-relate-lab.sh
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"
