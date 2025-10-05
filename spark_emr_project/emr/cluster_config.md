# EMR Cluster Config Notes

- EMR Release: **6.x** (e.g., 6.14) with Spark, Livy, JupyterHub
- Instance types: start small (e.g., m5.xlarge core), scale later
- Root EBS ~ 15GB is fine (data lives in S3)
- Networking: custom VPC, private subnets + NAT, S3 VPC endpoint (gateway)
- Security groups: allow SSH (22) only from admin IPs; 9443 for Jupyter if needed
- IAM:
  - EMR service role to create cluster resources
  - **EC2 instance profile** must include S3 permissions on your bucket
