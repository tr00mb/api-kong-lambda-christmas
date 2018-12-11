# Step 4 : Setup POST /commands API

## aws lambda function

Create the createNewCommand function.
</br>As this fonction is calling other API, pay attention to the environnement variables
</br>Indeed createNewCommand call mapQuest through kong (/distances) and ProductDetails (/workshop/products/{product_id})

- Name: createNewCommand
- Runtime: python 3.7
- Role -> Choose an existing role
    - lambda-dynamo-execution-role
- Copy the content of : api-kong-lambda-christmas/lambda-functions/createNewCommand.py
- We need to set some environment variables
    - MQ_APIKEY
    - API_URL

## create service, route and lambda plugin in kong

Do no hesitate to read [kong configuration](../../kong/kond.md) to understand the configuration

### MapQuest
Generate a MapQuest API token :
- Go to https://developer.mapquest.com/
- Click “Get your Free API key”
- Fill the Form
- Once you’ve received the email, log in with your account
- Go to https://developer.mapquest.com/user/me/profile
- Select “Manage Key” in the left menu
- And generate a new key by clicking the “Create a new Key” button

We create a the service and route to proxy mapquest

```
#create the service to MapQuest
curl -X POST --url http://$kong_admin/services --data 'name=mapQuest' --data 'url=http://www.mapquestapi.com/directions/v2/route'

#create the route to target the service
curl -X POST --url http://$kong_admin/services/mapQuest/routes --data 'methods[]=GET' --data 'paths[]=/distances'

```

Then we create the deliveries service and /workshop/commands route to access it. We also add the lambda and the CORS plugin.

```
#create the generic deliveries service
curl -X POST --url http://$kong_admin/services --data 'name=deliveries' --data 'url=http://aws-lambda'

#create a route for POST deliveries (we accept also the OPTIONS methods to handle CORS from local web site in the browser)
curl -X POST --url http://$kong_admin/services/deliveries/routes --data 'methods[]=POST' --data 'methods[]=OPTIONS' --data 'paths[]=/workshop/commands'

#/commands (note the forward_request_body=true so that the lambda function can get the data
curl -X POST $kong_admin/routes/{route_id}/plugins \
--data "name=aws-lambda" \
--data-urlencode "config.aws_key=$aws_key" \
--data-urlencode "config.aws_secret=$aws_secret" \
--data "config.aws_region=$aws_region" \
--data "config.forward_request_body=true" \
--data "config.unhandled_status=400" \
--data "config.function_name=createNewCommand"

curl -X POST http://kong:8001/services/deliveries/plugins \
    --data "name=cors"  \
    --data "config.origins=*"
```


