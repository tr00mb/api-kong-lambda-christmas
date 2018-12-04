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



def lambda_handler(event, context):
   pass

def delete_item(table_name, pk_name, pk_value):
    """
    Delete an item (row) in table from its primary key.
    """
    table = dynamodb.Table(table_name)
    response = table.delete_item(Key={pk_name: pk_value})
    return response