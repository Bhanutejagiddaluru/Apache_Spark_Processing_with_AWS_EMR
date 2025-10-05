#!/usr/bin/env bash
# Usage: ./scripts/verify_s3.sh s3://my-bucket/spark-emr-demo/output/nyc_taxi_step
set -euo pipefail
OUT=${1:?s3 path to output}
aws s3 ls "$OUT"
