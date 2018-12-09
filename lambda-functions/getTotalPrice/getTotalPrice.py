import os
import sys
import json
import boto3
import botocore
import logging
import uuid
from boto3.dynamodb.conditions import Key, Attr

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#DynamodDB table name and region 
DYNAMODB_REGION = "eu-west-3"
DYNAMODB_TABLE_NAME ="api_days_calcul_distance"

os.environ["AWS_DEFAULT_REGION"] = "eu-west-3"
dynamodb = boto3.resource('dynamodb',DYNAMODB_REGION)

#from boto import module lambda
client = boto3.client('lambda')

#Get ARN of lambda to call
invoked_function_arn = ""

#Event to send to invoke lambda getShippingPrice
event_to_send =""

def lambda_handler(event, context):
    
    #prix du panier transmis en parametre et recupéré dans l'event
    prix_panier = event['price_of_shopping_cart']

    #invocation de la lambda qui renvoit le prix 
    called_function = context.invoked_function_arn
    response = client.invoke(
        FunctionName=called_function,
        InvocationType='RequestResponse',
        Payload=bytes(json.dumps(event_to_send))
    )
    data = response['Payload'].read()
    data = json.loads(response['Payload'].read().decode())
    shippingPrice = data ['shipping_price']

    #somme des deux prix
    Total_price = shippingPrice + prix_panier
    return Total_price

