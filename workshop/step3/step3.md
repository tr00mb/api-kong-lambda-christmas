# Step 3 : Setup GET /product/{product_id} API

## aws lambda function

Create the getProductDetails function. (refer to the doc (ref))

## create service, route and lambda plugin in kong

Do no hesitate to read [kong configuration](../../kong/kond.md) to understand the configuration
</br> We create a new route to the generic products service to access it via /workshop/products/{product_id}

```
kong_admin=***IP/URL***:8001
aws_key=***KEY***
aws_secret=***SECRET***
aws_region=eu-west-2

curl -X POST --url http://$kong_admin/services/products/routes --data 'methods[]=GET' --data 'paths[]=/workshop/products/\S+'

```

Then we have to add a plugin to the route (/workshop/products/{product_id}). To do it you have to use the route_id from the created route. Either you still have it on your screen, or you can curl $kong_admin/services/products/routes to retrieve the id
</br>Note that we set the forward_request_uri parameters to true in order to make the product_id available for the aws lambda function
```
###/products/\S+
curl -X POST $kong_admin/routes/{route_id}/plugins \
--data "name=aws-lambda" \
--data-urlencode "config.aws_key=$aws_key" \
--data-urlencode "config.aws_secret=$aws_secret" \
--data "config.aws_region=$aws_region" \
--data "config.forward_request_uri=true" \
--data "config.unhandled_status=400" \
--data "config.function_name=getProductDetails"

```

## test the API
```
kong_api=***IP/URL***:8000
curl $kong_api/workshop/products/1
```

## start the frontend

We can start the front end locally using the index.html in the webfront directory
To handle CORS issue we can setup the CORS plugin at kong level. We will put it at the service level.

```
curl -X POST http://kong:8001/services/products/plugins \
    --data "name=cors"  \
    --data "config.origins=*"
```


