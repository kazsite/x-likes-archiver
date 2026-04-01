#!/bin/bash
set -e

if [ -z "$EXECUTION_ID" ] || [ -z "$X_USER_NAME" ] || [ -z "$X_AUTH_TOKEN" ] || [ -z "$X_CT0" ]; then
  echo "Error: Missing required environment variables (EXECUTION_ID, X_USER_NAME, X_AUTH_TOKEN, X_CT0)"
  exit 1
fi

python3 /usr/local/bin/netscape_cookies.py

YEAR=$(date -d '1 day ago' +%Y)
MONTH=$(date -d '1 day ago' +%-m)
DAY=$(date -d '1 day ago' +%-d)

gallery-dl -v --config /etc/gallery-dl.conf \
           --cookies /tmp/x_cookies.txt \
           --filter "date >= datetime($YEAR, $MONTH, $DAY)" \
           "https://x.com/${X_USER_NAME}/likes"

cd /tmp/downloads
ZIP_NAME="${X_USER_NAME}_likes_$(date +%Y%m%d%H%M%S).zip"

if [ -d "${X_USER_NAME}" ] || [ "$(ls -A .)" ]; then
  zip -r "/tmp/${ZIP_NAME}" .
else
  echo "Info: No new images found. Skipping zip/upload."
  exit 0
fi

if [ -n "$S3_BUCKET_NAME" ]; then
  aws s3 cp "/tmp/${ZIP_NAME}" "s3://${S3_BUCKET_NAME}/${ZIP_NAME}" \
      --metadata "execution_id=${EXECUTION_ID}" \
      --content-type "application/zip"
else
    echo "Warning: S3_BUCKET_NAME not set. Skipping upload."
fi

echo "Completed successfully."
