#Use own image
FROM ghcr.io/libre-devops/azure-terraform-jenkinsfile-base:latest

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
