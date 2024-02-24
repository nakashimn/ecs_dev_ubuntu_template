################################################################################
# builder
################################################################################
FROM ubuntu:22.04 as builder

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    tzdata

################################################################################
# development
################################################################################
FROM ubuntu:22.04 as dev

ARG GIT_USERNAME
ARG GIT_EMAIL_ADDRESS

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    ca-certificates \
    git

RUN git config --global --add safe.directory /workspace
RUN git config --global user.name ${GIT_USERNAME}
RUN git config --global user.email ${GIT_EMAIL_ADDRESS}

################################################################################
# production
################################################################################
FROM ubuntu:22.04 as prod

ENV TZ Asia/Tokyo

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib

COPY ./app /workspace/app
CMD ["echo", "app is running correctly."]
