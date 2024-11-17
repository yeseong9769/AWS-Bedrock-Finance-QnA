# backend
aws configure
chown -R ec2-user /app/docuQuery
uvicorn main:app --host 0.0.0.0 --port 8000 &> uvicorn.log