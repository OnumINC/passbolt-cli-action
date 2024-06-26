FROM ghcr.io/onuminc/passbolt-cli:latest

# Set the entrypoint to a script which can handle env vars
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY cleanup.sh /cleanup.sh
RUN chmod +x /cleanup.sh

ENTRYPOINT ["/entrypoint.sh"]
