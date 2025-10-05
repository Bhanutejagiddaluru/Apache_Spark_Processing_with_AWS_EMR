# 🚀 Apache Spark Processing with AWS EMR — Starter Project

A working, minimal project to process CSV data at scale using **Apache Spark** on **AWS EMR**, with S3 for storage and Glue for metadata.

---

## 📦 Project Structure
```
spark_emr_project/
├─ README.md
├─ requirements.txt
├─ spark_etl.py
├─ sample_data/
│  └─ nyc_taxi_small.csv
├─ scripts/
│  ├─ run_local.sh
│  ├─ run_emr_step.sh
│  └─ verify_s3.sh
└─ emr/
   ├─ step-args.txt
   └─ cluster_config.md
```
---

## ⚙️ Quick Start (Local)

1) **Create venv & install deps**
```bash
python -m venv .venv && source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

2) **Run locally (Spark must be installed locally)**  
```bash
python spark_etl.py --input sample_data/nyc_taxi_small.csv --output output_local
```

3) **Result**
- Writes a partitioned **Parquet** dataset to `./output_local`

> 💡 If you don’t have local Spark, skip to EMR instructions below.

---

## ☁️ Run on AWS EMR (Recommended)

### Prereqs
- AWS account & IAM user with permissions
- S3 bucket, e.g. `s3://<your-bucket>`
- AWS CLI configured (`aws configure`)
- EMR cluster (6.x) with **Spark, Livy, Jupyter**

### 1) Upload artifacts
```bash
BUCKET=s3://<your-bucket>/spark-emr-demo
aws s3 cp spark_etl.py $BUCKET/code/spark_etl.py
aws s3 cp sample_data/nyc_taxi_small.csv $BUCKET/input/nyc_taxi_small.csv
```

### 2) Submit interactively from the EMR master (SSH) or from a jump host
```bash
spark-submit $BUCKET/code/spark_etl.py   --input $BUCKET/input/nyc_taxi_small.csv   --output $BUCKET/output/nyc_taxi_processed
```

### 3) Or add as an **EMR Step** (from your laptop/Cloud9)
```bash
# Discover your cluster-id
aws emr list-clusters --active

CLUSTER_ID=j-XXXXXXXXXXXXX
aws emr add-steps   --cluster-id $CLUSTER_ID   --steps Type=CUSTOM_JAR,Name="SparkETL",Jar=command-runner.jar,Args=["spark-submit","s3://<your-bucket>/spark-emr-demo/code/spark_etl.py","--input","s3://<your-bucket>/spark-emr-demo/input/nyc_taxi_small.csv","--output","s3://<your-bucket>/spark-emr-demo/output/nyc_taxi_step"]
```

### 4) Verify output
```bash
aws s3 ls $BUCKET/output/nyc_taxi_processed/
```

---

## 🔍 What the job does
- Reads CSV (header inferred)
- Adds `processing_time` (UTC timestamp)
- Writes **Parquet** to the output path (overwrite-safe)

---

## 🧠 Common Gotchas
- **AccessDenied on S3** → Ensure the **EC2 instance profile** attached to EMR has S3 read/write on your bucket.
- **Spaces in filenames** → Avoid spaces in S3 keys; use hyphens/underscores.
- **Region mismatch** → Bucket & EMR cluster should be in compatible regions.

---

## 🧰 Next Steps
- Wire AWS Glue Data Catalog tables to the S3 locations
- Add partitioning (e.g., by date) & bucketing
- Schedule via Step Functions / Airflow
- Add CI/CD to validate & deploy the PySpark job

