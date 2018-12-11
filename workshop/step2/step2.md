# Step 2

## aws lambda function

## create service, route and lambda plugin in kong

Do no hesitate to read [kong configuration](../../kong/kond.md) to understand the configuration
</br> First, we create a generic service and a route to access it via /workshop/products 

```
kong_admin=***IP/URL***:8001
aws_key=***KEY***
aws_secret=***SECRET***
aws_region=eu-west-2

#create generic products service
curl -X POST --url http://$kong_admin/services --data 'name=products' --data 'url=http://aws-lambda'


#create different routes to be able to have different aws-lambda call on each route
curl -X POST --url http://$kong_admin/services/products/routes --data 'methods[]=GET' --data 'paths[]=/workshop/products'
```

Then we have to add a plugin to the route (/workshop/products). To do it you have to use the route_id from the created route. Either you still have it on your screen, or you can curl $kong_admin/services/products/routes to retrieve the id

```
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
kong_api=IPKONG:8000
curl $kong_api/workshop/products
