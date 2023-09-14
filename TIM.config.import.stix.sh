#!/bin/bash

IMPORT_STIX_FILE_CONFIG_FILE=$1

printf "Writing [$IMPORT_STIX_FILE_CONFIG_FILE] file.\n"
/bin/cat > $IMPORT_STIX_FILE_CONFIG_FILE <<EOF
opencti:
  url: "$OPENCTI_URL"
  token: "$OPENCTI_ADMIN_TOKEN"

connector:
  id: "$CONNECTOR_IMPORT_FILE_STIX_ID"
  type: "INTERNAL_IMPORT_FILE"
  name: "ImportFileStix"
  validate_before_import: true # Validate any bundle before import
  scope: "application/json,text/xml"
  auto: false # Enable/disable auto-import of file
  confidence_level: 15 # From 0 (Unknown) to 100 (Fully trusted)
  log_level: "info"

import_file_stix:
  create_indicator: false
EOF

exit 0