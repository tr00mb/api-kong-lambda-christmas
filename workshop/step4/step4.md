# Step 4 : Setup POST /commands API

## aws lambda function

Create the createNewCommand function. (refer to the doc (ref))
</br>As this fonction is calling other API, pay attention to the environnement variables
</br>Indeed createNewCommand call mapQuest through kong (/distances) and ProductDetails (/workshop/products/{product_id})

## create service, route and lambda plugin in kong


Do no hesitate to read [kong configuration](../../kong/kond.md) to understand the configuration
</br> We create a the service and route to proxy mapquest

```
kong_admin=***IP/URL***:8001
aws_key=***KEY***
aws_secret=***SECRET***
aws_region=eu-west-2

#create the service to MapQuest
curl -X POST --url http://$kong_admin/services --data 'name=mapQuest' --data 'url=http://www.mapquestapi.com/directions/v2/route'

#create the route to target the service
curl -X POST --url http://$kong_admin/services/mapQuest/routes --data 'methods[]=GET' --data 'paths[]=/distances'

```

Then we create the deliveries service and /workshop/commands route to access it. We also add the lambda and the CORS plugin.

```
#create generic products service
curl -X POST --url http://$kong_admin/services --data 'name=deliveries' --data 'url=http://aws-lambda'

#create a route for POST deliveries (we accept also the OPTIONS methods to handle CORS from local web site in the browser)
curl -X POST --url http://$kong_admin/services/deliveries/routes --data 'methods[]=POST' --data 'methods[]=OPTIONS' --data 'paths[]=/workshop/commands'

###/commands (note the forward_request_body=true so that the lambda function can get the data
curl -X POST $kong_admin/routes/{route_id}/plugins \
--data "name=aws-lambda" \
--data-urlencode "config.aws_key=$aws_key" \
--data-urlencode "config.aws_secret=$aws_secret" \
--data "config.aws_region=$aws_region" \
--data "config.forward_request_body=true" \
--data "config.unhandled_status=400" \
--data "config.function_name=createNewCommand"

url -X POST http://kong:8001/services/deliveries/plugins \
    --data "name=cors"  \
    --data "config.origins=*"
```


