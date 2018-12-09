import os
import sys
import json
import boto3
import botocore
import logging
import uuid
from datetime import datetime
from boto3.dynamodb.conditions import Key, Attr
from boto3 import client

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#DynamodDB table name and region 
DYNAMODB_REGION = "eu-west-3"
DYNAMODB_TABLE_NAME ="api_days_calcul_distance"

os.environ["AWS_DEFAULT_REGION"] = "eu-west-3"
dynamodb = boto3.resource('dynamodb',DYNAMODB_REGION)

def lambda_handler(event, context):
    #get product_id from path of api url
    #product_id= event['pathParameters']['product_id']
    product_id = event['params']['querystring']['product_id']
    #query table with this parameters getting
    query_table(DYNAMODB_TABLE_NAME,'id',product_id)
 
def query_table(table_name, filter_key=None, filter_value=None):
    """
    Perform a query operation on the table. 
    Can specify filter_key (col name) and its value to be filtered.
    """
    table = dynamodb.Table(table_name)

    if filter_key and filter_value:
        filtering_exp = Key(filter_key).eq(filter_value)
        response = table.query(KeyConditionExpression=filtering_exp)
    else:
        response = table.query()
    print(response)
    return response

