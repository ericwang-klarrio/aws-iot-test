# Define in which region do you want to create the EKS cluster
region="ap-southeast-2"

# Define the name of the cluster
cluster_name="apac-eks"

# Define the type of the workers in the EKS cluster
worker_instance_type="t2.medium"

# Define the number of the workers in the EKS cluster
worker_instance_number="3"

# Define the account id you are using to create the EKS cluster
aws_account_id="126208120899"

# Define the admin accounts for the EKS cluster
eks_admin_accounts=["eric.wang","ammar.ahmed","vincent.quigley"]
