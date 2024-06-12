FROM alpine:3.20 AS base

RUN apk update && apk add bash

FROM base AS builder

RUN apk add go
RUN go install github.com/passbolt/go-passbolt-cli@latest

FROM base AS final

COPY --from=builder /root/go/bin/go-passbolt-cli /usr/local/bin

# Set the entrypoint to a script which can handle env vars
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY cleanup.sh /cleanup.sh
RUN chmod +x /cleanup.sh

ENTRYPOINT ["/entrypoint.sh"]
