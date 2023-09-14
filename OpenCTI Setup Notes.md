# OpenCTI Setup Notes

## Prerequisites

- Install [Docker](https://docs.docker.com/get-docker/)
- Clone the [OpenCTI Docker repo](https://github.com/OpenCTI-Platform/docker)

## Needed files

The cloned repo will have a docker-compose.yml. Replace that with the updated docker-compose.yml.

*Contact Ian for this .yml file.

Create the following .env file:

```zsh
OPENCTI_ADMIN_EMAIL=admin@opencti.io
OPENCTI_ADMIN_PASSWORD=CHANGEMEPLEASE
OPENCTI_ADMIN_TOKEN=6C2C9EAE-6FF5-4421-B118-74A3CA5AAC20
OPENCTI_BASE_URL=http://localhost:8080
SMTP_HOSTNAME=localhost
ELASTIC_MEMORY_SIZE=4G
MINIO_ROOT_USER=C145E441-A78D-4243-9014-658115356BE6
MINIO_ROOT_PASSWORD=C25583E1-C9E3-49A8-AB11-4CBAD1B13CCB
RABBITMQ_DEFAULT_USER=guest
RABBITMQ_DEFAULT_PASS=guest
CONNECTOR_HISTORY_ID=09610549-C9F6-4955-8399-7EEF90F2CAF6
CONNECTOR_EXPORT_FILE_TXT_ID=63389CB3-A41E-4699-A4E2-ACC96C960EFB
CONNECTOR_IMPORT_DOCUMENT_ID=25B18C0A-58F7-4DEF-8044-0C7BFF63B7CE
CONNECTOR_EXPORT_FILE_STIX_ID=A5DAC66C-0AC9-4220-9502-A7E4D719C391
CONNECTOR_EXPORT_FILE_CSV_ID=052488DD-CCB3-41FB-B0E2-B5F08EB2258F
CONNECTOR_IMPORT_FILE_STIX_ID=DFDD28B4-806B-4374-9FEC-7AC5A96221AE
CONNECTOR_IMPORT_REPORT_ID=14F7D0BE-FEF3-4A1B-926E-DB0B8A4DECD2
CONNECTOR_IMPORT_ALIEN_VAULT=2F41B65A-9BE6-42AD-B979-781B4E6532A3
```

Copy the .env to /etc/environment (You will need to use `sudo`).

From the root of the repo, run:

```zsh
set -a; source .env
docker-compose up -d
```

When that finishes executing, connect to <http://localhost:8080>.

*Note: Connect to http, not https. Chrome may automatically correct it to https, so you might need to connect using incognito mode.

Log in using the email and password at the top of the .env file.

## Shutdown and Cleanup

To stop the services, run:

```zsh
docker-compose stop
```

To stop and remove containers/networks:

```zsh
docker-compose down
```

To remove unused data:

```zsh
docker system prune
```
