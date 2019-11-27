#/bin/bash
export PORT=3000
export METEOR_SETTINGS="$(cat $METEOR_SETTINGS_FILE)"
node /opt/big_dipper/bundle/main.js
