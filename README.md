# jenkins-terraform
Test — Auto Scaling

SSH into an instance and run:

sudo yum install -y stress
stress --cpu 2 --timeout 300


Within a few minutes, new instances should launch automatically (scale-out).
After CPU drops, instances terminate (scale-in).
