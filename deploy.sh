#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

: "${HARBOR_PASSWORD?Must set HARBOR_PASSWORD env var}"
: "${HARBOR_HOSTNAME?Must set HARBOR_HOSTNAME env var}"

echo "$HARBOR_PASSWORD" | docker login "$HARBOR_HOSTNAME" -u admin --password-stdin
kapp deploy \
  -a guestbook \
  -y \
  -f <(ytt -f config/ \
         --data-value push_images=true \
         --data-value push_images_repo="$HARBOR_HOSTNAME"/guestbook | \
       kbld --platform=linux/arm64 -f-) \
  -c
