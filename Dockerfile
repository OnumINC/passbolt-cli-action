FROM alpine:3.20 AS base

RUN apk update

FROM base AS builder

RUN apk add go
RUN go install github.com/passbolt/go-passbolt-cli@latest

FROM base AS final

COPY --from=builder /root/go/bin/go-passbolt-cli /usr/local/bin
