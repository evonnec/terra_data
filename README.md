# terra data

<h2>Introduction</h2>
Create a IaC to a cloud provider that will allow for management of data processing and storage.

<h2>Architecture</h2>

1. terraform a cloud instance, e.g. AWS EC2. Then, with Terraform:
    2. `git clone` repo
    3. set up Postgres
    4. pull raw data in S3
    5. clean data from S3 and store in Postgres


<h2>Dataset</h2>

We will be exploring Lending Club’s loan origination data from 2007-2015. Download the data in CSV format (loan.csv) and associated dictionary (LCDataDictionary.xlsx) from https://www.kaggle.com/wendykan/lending-club-loan-data and place in an S3 bucket.

<h2>Engineering Challenges</h2>

The engineering challenges were 

- understanding and implementing HCL language to bring up Terraform. 

- to get everything up and running systematically after Terraform is up.


<h2>Engineering Tradeoffs</h2>

- Tools that would be optimal for a production environment are not explored for this use case due to scope.

- Could not abstract away all the things due to time constraints

<h2>How to Use</h2>
1. make sure to have terraform installed - to test, at command line type `which terraform` and it should return where it's located on the filesystem. if there's nothing that appears, go to the website terraform.io for instructions to download.

2. make sure to already have an AWS default set up somewhere in an availability zone. us-east-1 was used for this, this availability zone choice may have impact on whether AWS can find the instance to create or not.

3. also make sure that route tables, internet gateway, security groups are set up properly for all subnets for the default VPC in the availability zone chosen. these configurables could also be written in and brought up via terraform however it may change settings and that may not be desired.

4. `git clone` this repo

5. cd (change directory) into the terraform folder. write up a terraform.tfvars file to satisfy variables.tf - not all of these are used, can pick what is needed for it to run. 

6. write an env_vars.sh file that states 
export BUCKET_NAME="<your bucket name here>"
export POSTGRES_USER="<your postgres user name>"
export POSTGRES_PWD="<your postgres password>"
export DB_NAME="<your database name>"
export POSTGRES_PORT="<this will probably be 5432 for Postgres>"

7. run `terraform init`, then `terraform plan` (give it a region) then `terraform apply -auto-approve` (also give it a region)

8. when done, run `terraform destroy -auto-approve` (also give it the region you created it in)


<h2>Requirements</h2>

<h3>Part 1 - </h3>
<h4>IaC (e.g. Terraform) should include at least these components:</h4>

- Cloud object storage
    - e.g. AWS S3
- Cloud data pipeline / ETL environment 
    - e.g. AWS EC2
    - thoughts: there was consideration of implementing Apache Airflow, but thought it to be too complex for this use case.
- Cloud database engine   
    - PostgreSQL 
    - thoughts: there was consideration of making Postgres a separate instance with a public ip - then inject that to ETL instance as env variable. Then open up the Postgres port on security group - but also thought to be too complex for this use case.


<h3>Part 2 - </h3>
<h4>Data Pipeline Engineering</h4>

- Create a data model / schema in a database or storage engine
- Develop code that will persist the dataset into this storage system in a fully automated way
- Include any data validation routines that may be necessary

- thoughts: the table was read in raw as-is and not transformed. this may not be preferable to work with. however, transforming raw data, and thus losing the original can prove to be regrettable later down the road. yes, simply reimporting raw data from S3 can be done - that is certainly a viable alternative. mainly, regardless of the choice made - keeping the data somewhere accessible in its raw form is useful. 

- to transform the data for something more use-able day to day, views of raw tables would fill this purpose, perhaps using CASE to handle edge cases, or to convert datatypes for columns if wanted (i.e. month-year columns converted to date time data types) - and views can be created and destroyed readily with schemas saved in S3 or the filesystem.

<h3>System Improvements</h3>
 
 In the future, system improvements could include implementing Apache Airflow on the ETL instance, as well as implementing a separate instance for Postgres and networking the ETL instance and the Postgres database instances. Writing up a mapping of all possible datatypes from csv to sql would prove useful as a lookup tool to determine what to convert the datatypes to for consumption by the database table. Pandas is great to manipulate data under a certain size, however with larger sized datasets, scrapping pandas should be explored as well as implementing data partitioning. Also dividing up tasks as functions that are called, for a better idea of what to address when some task should fail.

<h4>Additional Guidance</h4>

    -   Prioritize simplicity in the data model and processing code. 
    -   Explain thought process and document any alternate data models considered.
    -   Wrap up with a discussion of system improvements that could be addressed in the future.
    -   Submit all code and documentation via GitHub. 
    -   Include all code files, outputs, and other artifacts in the repository. 
    -   Do not include any passwords or secrets. 
    -   Include a documentation file. 

