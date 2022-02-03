FROM public.ecr.aws/ubuntu/ubuntu:20.04

LABEL org.opencontainers.image.authors="HMPPS EMS Platform Team (hmpps-ems-platform-team@digital.justice.gov.uk)" \
      org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.title="actions-toolkit" \
      org.opencontainers.image.description="Actions Toolkit" \
      org.opencontainers.image.source="https://github.com/ministryofjustice/hmpps-ems-container-actions-toolkit" \
      org.opencontainers.image.licenses="MIT License"

COPY src/root/build.sh /root/build.sh

RUN /root/build.sh