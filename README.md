**IMPORTANT Dislaimer:** 

If you are unfamiliar with the material, it is recommended that you do not spend more than 12 hours on Steps 1-6. There is no strict deadline, but please communicate your timeline and progress. Treat this as a learning opportunity; completion does not guarantee compensation or employment. You will receive a Mattermost link via email; this will be your primary way to interact with a few of us as a pseudo team.

# Task
### Step 1:
- Set up a GitHub or GitLab repo for your project. Use your repo for all code, config, scripts, and documents for the project. Send us the link to your repo via Mattermost. There is no need to fork this project.

### Step 2: 
- Create an RDS Postgres DB instance.

### Step 3a: 
- Populate a table called `customerdata`. We will provide a CSV upon request in Mattermost.

### Step 3b (Optional):
- Choose a method to automate mock data generation and continuously populate the `customerdata` table.

### Step 4: 
- Provision a Redshift Serverless instance.

### Step 5:
- Use your preferred ETL method to populate Redshift with data from Postgres.

### Step 6: (optional if you have time)
- Create a visualization or chart that reads from Redshift.

_____________________________________________

# **Important Notes:** 
You can use your own AWS account or ours; it is your choice. If you want to use ours, please request that a user account be created for you, and make sure to tag all resources with creator: <Your Alias Name>.

## CI/CD (preferred if you have time)
- Provide a CI/CD pipeline that can spin up and tear down the infrastructure easily.

## Finishing
- You are not expected to finish all steps 1-6. This exercise may require tradeoffs in how you architect and execute the tasks. Terraform is preferred, but a perfect Terraform configuration may not be possible within the time limit.