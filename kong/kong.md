# Kong installation
We will use the ami from aws marketplace. https://aws.amazon.com/marketplace/pp/B06WP4TNKL
You should subscribe, and then continue the configuration:
  Choose EU(Paris) as a region
Continue to launch
  Choose t2.medium as instance type
  Leave VPC and subnet as it is
  Create security group by clicking on Create New Based On Seller Settings
  Create a key pair (which will give you access to the instance by ssh)
  
Check the installation by accessing to the admin api
curl yourInstanceIP:8001

# Kong configuration

## Services and routes
### lambda
We need to configure the different services, routes and plugins to make the link between API calls and aws-lambda functions execution.
In the kong configuration logic, services are the upstream service that you want to target and routes are the way the consumers are calling kong to reach the services.
Then, different plugins, such as security, traffic control or serverless call can be set up either at the services or at the routes level.

When calling aws lambda functions, there is no upstreams service that are called. However we still need to set up services.
One choice is to implement logical services and configure one route per lambda function.

In our case, we well setup a products service with the differents route for GET /workshop/products,  GET /workshop/products/{product_id} and a deliveries service with only one route POST /workshop/commands

### mapquest
We need also to proxy the access to mapquest.
For this configuration, this is a standard kong configuration which declare mapquest as a upstream service and a route to this service.

## Plugins
### lambda plugin
Lambda plugins needs the aws key and sercret from an aws account that has the lambda execution role.
It would also need the aws region where the lambda function is hosted and the function name itself.
Note that we can add a qualifier parameter which is a aws notion that would be either the function version or the function aliases.
For exemple, if, for an environnement you decide to alias your function with the tag UAT, then you can make kong call the UAT function. Then you update your function, move the alias from one version to another, and the plugin will always call the UAT aliased function. If you do not precise the qualifier, the $LATEST version of the function will be called.


