import os
import sys
import json
import boto3
import botocore
import logging
import uuid
from boto3.dynamodb.conditions import Key, Attr
from boto.s3.key import Key

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#DynamodDB table name and region 
DYNAMODB_REGION = "eu-west-3"
DYNAMODB_TABLE_NAME ="api_days_calcul_distance"

os.environ["AWS_DEFAULT_REGION"] = "eu-west-3"
dynamodb = boto3.resource('dynamodb',DYNAMODB_REGION)


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

#query_table(DYNAMODB_TABLE_NAME,'id','photo')
