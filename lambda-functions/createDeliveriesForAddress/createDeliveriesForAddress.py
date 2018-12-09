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
invoked_function_arn1 = ""
invoked_function_arn2 =""

#Event to send to invoke lambda
event_to_send1 =""
event_to_send2 =""


def lambda_handler(event, context):
    #invocation de la lambda qui renvoit le prix et la distance 
    called_function1 = context.invoked_function_arn1
    response = client.invoke(
        FunctionName=called_function1,
        InvocationType='RequestResponse',
        Payload=bytes(json.dumps(event_to_send1))
    )
    data1 = json.loads(response['Payload'].read().decode())
    distance = data1['distance']
    shippingPrice = data1['shipping_price']

    
    #invocation de la lambda qui renvoit le prix total
    called_function2 = context.invoked_function_arn2
    response = client.invoke(
        FunctionName=called_function2,
        InvocationType='RequestResponse',
        Payload=bytes(json.dumps(event_to_send2))
    )
    data2 = json.loads(response['Payload'].read().decode())
    Total_price = data2['Total_price']

    return distance,shippingPrice,Total_price


