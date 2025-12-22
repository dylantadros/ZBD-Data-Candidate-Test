**IMPORTANT Dislaimer:** 

If you are unfamiliar with the material, it is recommended that you do not spend more than 12 hours on Steps 1-6. There is no strict deadline, but please communicate your timeline and progress. Treat this as a learning opportunity; completion does not guarantee compensation or employment. You will receive a Mattermost link via email; this will be your primary way to interact with a few of us as a pseudo team.

# Task
### Step 1:
- Set up a GitHub or GitLab repo for your project. Use your repo for all code, config, scripts, and documents for the project. Send us the link to your repo via Mattermost. There is no need to fork this project.

### Step 2: 
- Create an RDS Postgres DB instance.

### Step 3a: 
- In our fictious simulation a very bad piece of software made it to prod. There was little to no data modeling before hand and the data is a mess! Look at the CSVs in the /data directory. Try to understand what is going on and create a visual ERD for what the data should be. Once you feel comfortable with needed changes, create tables and populate with data representing the CSVs in RDS postgres.

### Step 3b (Optional):
- Choose a method to automate mock data generation and continuously populate the tables. If you have already spent more than 6 hours on the previous steps please skip this step.

### Step 4: 
- Provision a Redshift Serverless instance.

### Step 5:
- Use your preferred ETL method to populate Redshift with data from Postgres.

### Step 6: (optional if you have time)
- Ensure that redshift will pick up changes that happen on the postgres tables.
- Create a BI visual that reads from Redshift and displays something interesting.

_____________________________________________

# **Important Notes:** 
You can use your own AWS account or ours; it is your choice. If you want to use ours, please request that a user account be created for you, and make sure to tag all resources with creator: <Your Alias Name>.

## CI/CD (preferred if you have time)
- Use CI/CD pipeline that can spin up and tear down the infrastructure easily.

## Finishing
- Anything beyond 12 hours is on your own time and not expected. Be mindful of your time!, make reasonable tradeoffs, and communicate early/often. If you're spending extended time or hit blockers, please document issues as you go. Finishing everything is NOT strictly required. When in doubt communicate via Mattermost.
