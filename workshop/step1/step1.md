
# Step 1 : setup environnements

## Create basic stack
The basic stack is :
- A Dynamodb table
- Insert data into the table
- Create a VPC and a subnet to get Internet access
- Pull the Kong AMI and starts it

### Prerequisites
In order to deploy the stack you need:
- awscli (for windows only)
- terraform
- aws access keys

>In the context of API Days 2018 you will receive the aws access by email
>You may receive an email with a wrong name. Ignore the incorrect information. It is a known issue.
>You can safely use the credentials from the email.

- Accept the EULA https://aws.amazon.com/marketplace/pp/B06WP4TNKL of Kong
appliance while connected to AWS Console. ( Needed otherwise terraform won’t be able
to pull the AMI). Click Continue to Subscribe
- And then Accept Terms

### Deploy
#### macOs & Linux
Terraform
1. Download and install Terraform appropriate package for your OS (Linux or MacOS)
2. Copy files from the downloaded zip to ~/terraform (Create terraform folder).
3. Open a terminal window and set the PATH to use terraform binary :
```
export PATH=$PATH:$HOME/terraform
````

Environment variables
- Open a terminal window and replace the values with the ones from the email.
````
export AWS_ACCESS_KEY_ID=" YOURaccesskey "
export AWS_SECRET_ACCESS_KEY=" YOURsecretkey "
export AWS_DEFAULT_REGION="eu-west-2"
`````

Deploy the stack
- Once all the prerequisites have been met run from a terminal window:
````
cd ~/terraform
curl -s -LO https://github.com/tr00mb/api-kong-lambda-christmas/archive/master.zip
unzip master.zip
cd api-kong-lambda-christmas-master/tf
````

- Then execute
````
terraform init
terraform apply -auto-approve
````
#### MS Windows
awscli
1. You first need to install awscli (64-bit or 32-bit)
2. Run the downloaded MSI installer or the setup file.
3. Follow the on-screen instructions

Terraform
1. Download and install Terraform Windows appropriate package. (32-bit or 64-bit)
2. Copy files from the downloaded zip to C:\terraform (Create terraform folder).
3. Open the command prompt as an administrator and set the PATH to use terraform binaries :
````
set PATH=%PATH%;C:\terraform
Environment variables
````
Open a command prompt window and replace the value with the ones in the email.
(start -> run -> cmd)
````
set AWS_ACCESS_KEY_ID=" anaccesskey "
set AWS_SECRET_ACCESS_KEY=" asecretkey "
set AWS_DEFAULT_REGION="eu-west-2"
````

Deploy the stack
- Download using your favourite web browser the link below and copy the file to
C:\terraform
https://github.com/tr00mb/api-kong-lambda-christmas/archive/master.zip
- Extract
From a console prompt:
`````
C:\> cd C:\terraform\api-kong-lambda-christmas-master\tf
`````
- Then execute
`````
C:\terraform> terraform init
C:\terraform> terraform apply -auto-approve
`````
### Post installation verification
After the command ran the stack is ready the be used.
The public IP address of the Kong instance is displayed as well as the S3 bucket id. You
will need both afterwards.
You can check the instance public IP value directly from the AWS Console:
- To do so you need to click on Services > EC2
- Then from the EC2 Dashboard click on Instances to list all the instances in the account
- On the main panel the instances will show up and then you can easily find out the public
IP of the instance


