#!/usr/bin/env bash
# Usage: ./scripts/run_emr_step.sh <CLUSTER_ID> <S3_BUCKET_PREFIX>
# Example: ./scripts/run_emr_step.sh j-ABC1234567890 s3://my-bucket/spark-emr-demo
set -euo pipefail

CLUSTER_ID=${1:?cluster id required}
BASE=${2:?s3 prefix required} # e.g., s3://my-bucket/spark-emr-demo

aws s3 cp spark_etl.py $BASE/code/spark_etl.py
aws s3 cp sample_data/nyc_taxi_small.csv $BASE/input/nyc_taxi_small.csv

aws emr add-steps \
  --cluster-id "$CLUSTER_ID" \
  --steps Type=CUSTOM_JAR,Name="SparkETL",Jar=command-runner.jar,Args=["spark-submit","$BASE/code/spark_etl.py","--input","$BASE/input/nyc_taxi_small.csv","--output","$BASE/output/nyc_taxi_step"] \
  --output text
