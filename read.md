# backend
aws configure
sudo chown -R ec2-user /app/docuQuery
cd /app/docuQuery/backend
uvicorn main:app --host 0.0.0.0 --port 8000 &> uvicorn.log &