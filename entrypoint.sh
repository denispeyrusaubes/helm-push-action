#!/usr/bin/env bash

set -e
set -x

if [ -z "$CHART_FOLDER" ]; then
  echo "CHART_FOLDER is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_URL" ]; then
  echo "CHARTMUSEUM_URL is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_USER" ]; then
  echo "CHARTMUSEUM_USER is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_PASSWORD" ]; then
  echo "CHARTMUSEUM_PASSWORD is not set. Quitting."
  exit 1
fi

if [ -z "$SOURCE_DIR" ]; then
  SOURCE_DIR="."
fi

if [ -z "$FORCE" ]; then
  FORCE=""
elif [ "$FORCE" == "1" ] || [ "$FORCE" == "True" ] || [ "$FORCE" == "TRUE" ]; then
  FORCE="-f"
fi



cd ${SOURCE_DIR}/${CHART_FOLDER}

helm version -c

helm inspect chart .

if [[ $CHARTMUSEUM_REPO_NAME ]]; then
  helm repo add ${CHARTMUSEUM_REPO_NAME} ${CHARTMUSEUM_URL} --username=${CHARTMUSEUM_USER} --password=${CHARTMUSEUM_PASSWORD}
fi


helm dependency update .

helm package .

pwd

echo "*************************"
ls -R *
echo "*************************"
echo ${CHART_FOLDER}-* ${CHARTMUSEUM_URL}
echo "*************************"


helm cm-push domain-nc-0.1.0.tgz ${CHARTMUSEUM_URL} -u ${CHARTMUSEUM_USER} -p ${CHARTMUSEUM_PASSWORD} ${FORCE}
