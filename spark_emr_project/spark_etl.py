#!/usr/bin/env python
import argparse
from pyspark.sql import SparkSession
from pyspark.sql.functions import current_timestamp

def parse_args():
    p = argparse.ArgumentParser(description="Spark ETL: CSV -> Parquet with timestamp")
    p.add_argument("--input", required=True, help="Input CSV path (local path or s3://…)")
    p.add_argument("--output", required=True, help="Output directory (local path or s3://…)")
    p.add_argument("--repartition", type=int, default=None, help="Optional number of output partitions")
    return p.parse_args()

def main():
    args = parse_args()

    spark = (
        SparkSession.builder
        .appName("Spark_ETL_EMR_Demo")
        .getOrCreate()
    )
    spark.sparkContext.setLogLevel("WARN")

    df = spark.read.csv(args.input, header=True, inferSchema=True)
    df = df.withColumn("processing_time", current_timestamp())

    if args.repartition and args.repartition > 0:
        df = df.repartition(args.repartition)

    # Overwrite to keep demos deterministic
    df.write.mode("overwrite").parquet(args.output)

    print(f"Wrote parquet dataset to: {args.output}")
    spark.stop()

if __name__ == "__main__":
    main()
