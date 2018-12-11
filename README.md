# api-kong-lambda-christmas

The goal of this project is to learn how to set up a kong + aws-lambda platform.
Kong act as a poweful and flexible API gateway. You can use kong communauty edition for this workshop. Then if you want to apply it to real API use cases, you should look at the entreprise edition to have all the benefits of the software.

## Step one: Setup  environment

Setup Dynamo DB for the application
<br/>Setup S3 for image storage and web site storage
<br/>Setup kong EC2 instance

## Step two: get products fonction

AWS lamdba fonction to get the products list (id and name)
Setup kong to expose a route and call the aws lambda function
[step two](./workshop/step2/step2.md)

## Step three: get product details function 

AWS lambda function to get a product detail
Setup kong to expose a route and call the aws lambda function
Setup front-end and activate CORS plugin at kong level

## Step four: put an order request

AWS lambda function to request for an order
Setup kong to expose a route and call the aws lambda function

