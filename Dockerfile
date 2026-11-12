FROM ubuntu:24.04

ARG TARGETARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl zstd \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
      amd64) archive="lean-4.35.0-linux.tar.zst"; checksum="7289597a44543246c9227b8cae501767e095ce17f6d448b95fc4a8dc97268f6d" ;; \
      arm64) archive="lean-4.35.0-linux_aarch64.tar.zst"; checksum="c8f0f8a3920e839718b1343e6781fd80a3e9b1024fbcd7078eb30f54e806b028" ;; \
      *) echo "Unsupported architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac \
    && curl --fail --location --retry 3 --output /tmp/lean.tar.zst \
      "https://github.com/leanprover/lean4/releases/download/v4.35.0/$archive" \
    && echo "$checksum  /tmp/lean.tar.zst" | sha256sum --check \
    && mkdir -p /opt/lean \
    && tar --zstd -xf /tmp/lean.tar.zst -C /opt/lean --strip-components=1 \
    && rm /tmp/lean.tar.zst

ENV PATH="/opt/lean/bin:${PATH}"
WORKDIR /workspace
COPY _lean/ ./_lean/

USER 65532:65532
ENTRYPOINT ["bash", "_lean/check_compatibility.sh"]
