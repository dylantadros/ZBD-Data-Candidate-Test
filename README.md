**IMPORTANT Disclaimer:**

If you are unfamiliar with the material, it is recommended that you do not spend more than 12 hours on Steps 1-6. There is no strict deadline, but please communicate your timeline and progress. Treat this as a learning opportunity; completion does not guarantee compensation or employment. You will receive a Mattermost link via email; this will be your primary way to interact with a few of us as a pseudo team.

# Task
### Step 1:
- [x] Set up a GitHub or GitLab repo for your project. Use your repo for all code, config, scripts, and documents for the project. Send us the link to your repo via Mattermost. There is no need to fork this project.
    - [You are here!](https://github.com/dylantadros/ZBD-Data-Candidate-Test.git)

### Step 2:
- [x] Create an RDS Postgres DB instance.
    - ~~I can click ops this for now, but I also added a starting point for a terraform workflow. Wanted to talk through how production like this exercise should be.~~
    - `terraform-aws/` contains a terraform workflow that has spun up an RDS Postgres instance.

### Step 3a:
- [x] In our fictitious simulation a very bad piece of software made it to prod. There was little to no data modeling beforehand and the data is a mess! Look at the CSVs in the /data directory. Try to understand what is going on and create a visual ERD for what the data should be. Once you feel comfortable with needed changes, create tables and populate with data representing the CSVs in RDS postgres.
    - [ZBD Homework ERD](ZBD%20Homework%20ERD.png).

### Step 3b (Optional):
- [ ] Choose a method to automate mock data generation and continuously populate the tables. If you have already spent more than 6 hours on the previous steps please skip this step.
    - For this step, I would write a python script. I'm thinking I'd have AI generate seed data for publishers, games, and customers to a .csv file and have the script generate random transactions from the see data.

### Step 4:
- [x] Provision a Redshift Serverless instance.
    - ~~Terraform will also spin up the Redshift cluster and configure a zero-ETL integration as RDS PG → Redshift is a [supported combination](https://docs.aws.amazon.com/redshift/latest/mgmt/zero-etl-using.html).~~
    - `terraform-aws/` contains a terraform workflow that has spun up a Redshift Serverless instance.

### Step 5:
- [x] Use your preferred ETL method to populate Redshift with data from Postgres.
    - ~~this will be achieved via zero-ETL integration.~~
    - `terraform-aws/` also contains a terraform workflow that has spun up a zero-ETL integration `transactions-zero-etl'`.

### Step 6: (optional if you have time)
- [x] Ensure that Redshift will pick up changes that happen on the postgres tables.
    - Zero-ETL integrations achieve this natively. The Redshift database `raw_transactions` is a read replica of the `transactions_db` RDS database. Filters can be applied to the integration to limit the data that is loaded into Redshift however in this case we are simply applying the filter `transactions_db.*.*` causing `raw_transactions` to be updated whenever any change is made in RDS.
- [ ] Create a BI visual that reads from Redshift and displays something interesting.

_____________________________________________

# **Important Notes:**
You can use your own AWS account or ours; it is your choice. If you want to use ours, please request that a user account be created for you, and make sure to tag all resources with _`creator: Your Name`_.

## CI/CD (preferred if you have time)
- Use CI/CD pipeline that can spin up and tear down the infrastructure easily.

## Finishing
- Anything beyond 12 hours is on your own time and not expected. Be mindful of your time!, make reasonable tradeoffs, and communicate early/often. If you're spending extended time or hit blockers, please document issues as you go. Finishing everything is NOT strictly required. When in doubt communicate via Mattermost.
