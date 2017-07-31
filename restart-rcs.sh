#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

TARGET_BOX=rcs.rust-lang.org

ssh $TARGET_BOX '
    set -o errexit &&
    set -o pipefail &&
    set -o nounset &&
    set -o xtrace &&
    cd /opt/rcs &&
    (test -d data || (echo "no data dir" && exit 1)) &&
    docker pull alexcrichton/rust-central-station &&
    (docker rm -f rcs || true) &&
    docker run \
        --name rcs \
        --volume `pwd`/data:/data \
        --volume `pwd`/data/letsencrypt:/etc/letsencrypt \
        --volume `pwd`/logs:/var/log \
        --publish 80:80 \
        --publish 443:443 \
        --rm \
        --detach \
        alexcrichton/rust-central-station
'