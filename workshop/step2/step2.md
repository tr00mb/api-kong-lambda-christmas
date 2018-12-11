# Step 2 : Setup GET /products API

## aws lambda function


### Create IAM roles for Lambda functions
We need to create an IAM role for our future Lambda functions. This role will allow functions to
interact with DynamoDB and the S3 bucket.
- In the AWS console’s Services tab, click IAM under Security, Identity & Compliance, and
then click Roles from the left navigation menu.
- Click Create Role
- In the Trust step, choose AWS Service and Lambda, and then click Next: Permissions
- In the Permissions step, search for and check the boxes next to:
  - AWSLambdaExecute
  - AmazonS3ReadOnlyAccess
  - AmazonDynamoDBReadOnlyAccess


### Create the getAllProducts function.
Create a new function, Author from scratch
- Name
getAllProducts
- Runtime
Python 3.7
- Role -> Choose an existing role
lambda-dynamo-execution-role
- Select the function in the configuration panel
- Below you’ll find the code panel, copy the content of
api-kong-lambda-christmas/lambda-functions/getAllProducts.py file


## create a user to execute the lambda function from kong plugin
In the AWS console’s Services tab, click IAM under Security, Identity & Compliance, and
then click Roles from the left navigation menu.
- Click Create User
- Next, set the user name and select as access type only Programmatic access as shown
below
Then, we need to attach the permissions for this user
- Select Attach existing policies directly
- And select AWSLambdaFullAccess
- Click Next and then Create user
You should see a Success message
- Download the .csv file and save it somewhere safe. You will need to configure kong aws-lambda plugin.

## create service, route and lambda plugin in kong

Do no hesitate to read kong/kond.md to understand the configuration
</br> First, we create a generic service and a route to access it via /workshop/products 

```
kong_admin=***IP/URL***:8001

#create generic products service
curl -X POST --url http://$kong_admin/services --data 'name=products' --data 'url=http://aws-lambda'

#create different routes to be able to have different aws-lambda call on each route
curl -X POST --url http://$kong_admin/services/products/routes --data 'methods[]=GET' --data 'paths[]=/workshop/products'
```

Then we have to add a plugin to the route (/workshop/products). To do it you have to use the route_id from the created route. Either you still have it on your screen, or you can curl $kong_admin/services/products/routes to retrieve the id

aws_key, aws_secret are the ones from the user that was created in "create a user to execute the lambda function from kong plugin"

```
aws_key=***KEY***
aws_secret=***SECRET***
aws_region=eu-west-2

###/products
curl -X POST $kong_admin/routes/{route_id}/plugins \
--data "name=aws-lambda" \
--data-urlencode "config.aws_key=$aws_key" \
--data-urlencode "config.aws_secret=$aws_secret" \
--data "config.aws_region=$aws_region" \
--data "config.unhandled_status=400" \
--data "config.function_name=getAllProducts"
```


## test the API
```
kong_api=***IP/URL***:8000
curl $kong_api/workshop/products
```
