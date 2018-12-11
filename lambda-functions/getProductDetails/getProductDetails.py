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
DYNAMODB_REGION = "eu-west-2"
DYNAMODB_TABLE_NAME ="kong"
IMG_BUCKET=os.environ['IMG_BUCKET']

os.environ["AWS_DEFAULT_REGION"] = "eu-west-2"
dynamodb = boto3.resource('dynamodb',DYNAMODB_REGION)

def lambda_handler(event, context):
    #get product_id from path of api url
    product_id = int(float(event['request_uri'].rsplit('/', 1)[-1]))
    logger.info(product_id)
    #query table with this parameters getting
    return query_table(DYNAMODB_TABLE_NAME,'id',product_id)


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

    item=response['Items'][0]
    logger.info(item)
    api_item={}
    api_item['id']=item['id']
    api_item['name']=item['nom']
    api_item['description']=item['libelle']
    api_item['image_uri']=IMG_BUCKET+item['image_url']
    api_item['nb_stock']='134'
    api_item['unit_price']=item['prix']
    logger.info(api_item)

    return api_item
