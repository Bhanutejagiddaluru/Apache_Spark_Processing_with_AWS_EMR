#!/usr/bin/env bash
set -euo pipefail
python3 spark_etl.py --input sample_data/nyc_taxi_small.csv --output output_local
echo "Done. Check ./output_local"
