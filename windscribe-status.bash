#!/bin/bash
WINDSCRIBE=/usr/bin/windscribe
OUTPUT=/tmp/windscribe.status
COMMAND="${WINDSCRIBE} status"


printStatus () {
  echo ""
  echo "# ----------------- #"
  echo "  Windscribe Status  "
  echo "# ----------------- #"
  echo ""
  cat "$OUTPUT"
}


if [[ -f "$OUTPUT" ]]; then
  echo $OUTPUT exists
  # Output exists, print it
  printStatus

  # See if it's expired, and background update
  LASTRUN=$(stat -c %Y "$OUTPUT") || LASTRUN=0
  EXPIRATION=$(expr $LASTRUN + 2500)
  if [[ $(date +%s) -ge $EXPIRATION ]]; then
    rm ${OUTPUT} ; ${COMMAND} > "$OUTPUT" &
  fi
else 
  # No cache at all, so update now
  ${COMMAND} > "${OUTPUT}"
  printStatus
fi

echo ""
echo "To connect to Windscribe:"
echo "   windscribe connect [location]"
echo ""
echo "Optional locations available: US, US-W, CA, CA-W, GB"
echo ""
echo "More locations can be found in ~/windscribe-locations"


