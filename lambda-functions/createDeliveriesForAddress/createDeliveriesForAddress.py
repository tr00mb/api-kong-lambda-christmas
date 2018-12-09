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

#from boto import module lambda
client = boto3.client('lambda')

#Get ARN of lambda to call
invoked_function_arn = ""

#Event to send to invoke lambda
event_to_send =""

def lambda_handler(event, context):
    #get distance and shipping_price in the json sending
    distance = event['distance']
    shippingPrice = event['shipping_price']

    #invocation de la lambda qui renvoit le prix et la distance 
    called_function = context.invoked_function_arn
    response = client.invoke(
        FunctionName=called_function,
        InvocationType='RequestResponse',
        Payload=bytes(json.dumps(event_to_send))
    )
    data = json.loads(response['Payload'].read().decode())
    Total_price = data['Total_price']

    return distance,shippingPrice,Total_price


