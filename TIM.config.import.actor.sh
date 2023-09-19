#!/bin/bash

IMPORT_ACTOR_CONFIG_FILE=$1

printf "Writing [$IMPORT_ACTOR_CONFIG_FILE] file.\n"
/bin/cat > $IMPORT_ACTOR_CONFIG_FILE <<EOF
opencti:
  url: "$OPENCTI_URL"
  token: "$OPENCTI_ADMIN_TOKEN"

connector:
  id: "$CONNECTOR_IMPORT_ACTOR"
  type: "INTERNAL_IMPORT_FILE"
  name: "ActorImporter"
  scope: "text/csv" # MIME type or SCO
  auto: false # Enable/disable auto-import of file
  only_contextual: false # Only extract data related to an entity (a report, a threat actor, etc.)
  confidence_level: 100 # From 0 (Unknown) to 100 (Fully trusted)
  log_level: "debug"

import_actor:
  create_indicator: false
EOF

exit 0