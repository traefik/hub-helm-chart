#!/usr/bin/env bash
set -e

HASH=$(git rev-parse HEAD)

if [ -f "./hub/Chart.yaml" ]; then
    VERSION=$(cat ./hub/Chart.yaml | grep "version:" | awk -F " " '{ print "v"$2 }')
else
    VERSION=$(cat ./Chart.yaml | grep "version:" | awk -F " " '{ print "v"$2 }')
fi

if git rev-parse --quiet --verify ${VERSION}; then
    echo 'tag exist'
    exit 0
else
    echo 'tag not exist'
fi

echo "${VERSION} ${HASH}"

# https://docs.github.com/en/rest/reference/git#create-a-reference
curl \
    -X POST \
    -H "authorization: Bearer ${GITHUB_TOKEN}" \
    -H 'content-type: application/json' \
    -H 'Accept: application/vnd.github.v3+json' \
    https://api.github.com/repos/traefik/hub-helm-chart/git/refs \
    -d "{\"ref\":\"refs/tags/${VERSION}\",\"sha\":\"${HASH}\"}"
