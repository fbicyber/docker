#!/bin/sh
#
# Quick check of the set ENVARS for use with OpenCTI and Docker. These come from .env or from /etc/environment
#
# They are genrally loaded into the environment with:
#
#   export $(cat .env | grep -v "#" | xargs)
#
echo """
Docker IP: ${DOCKER_IP}
Admin Username: ${OPENCTI_ADMIN_EMAIL}
Admin Password: ${OPENCTI_ADMIN_PASSWORD}
Admin Token: ${OPENCTI_ADMIN_TOKEN} 
OpenCTI Base URL: ${OPENCTI_BASE_URL}
Elastic Memory Size: ${ELASTIC_MEMORY_SIZE}
MinIO user : ${MINIO_ROOT_USER}
MinIO password : ${MINIO_ROOT_PASSWORD}
RabbitMQ Default Username: ${RABBITMQ_DEFAULT_USER}
RabbitMQ Default Password: ${RABBITMQ_DEFAULT_PASS}
Connector History ID: ${CONNECTOR_HISTORY_ID}
Connector Export File TXT ID: ${CONNECTOR_EXPORT_FILE_TXT_ID}
Connector Export File STIX ID: ${CONNECTOR_EXPORT_FILE_STIX_ID}
Connector Export File CSV ID: ${CONNECTOR_EXPORT_FILE_CSV_ID}
Connector Import Document ID: ${CONNECTOR_IMPORT_DOCUMENT_ID}
Connector Import File STIX ID: ${CONNECTOR_IMPORT_FILE_STIX_ID}
Connector Report ID: ${CONNECTOR_IMPORT_REPORT_ID}
Optional - you need to sign up for Alien Vault Connector:
Alient Vault Import Connector ID: ${CONNECTOR_IMPORT_ALIEN_VAULT}  
Optional SMTP can be localhost
SMTP Hostname: ${SMTP_HOSTNAME}
"""