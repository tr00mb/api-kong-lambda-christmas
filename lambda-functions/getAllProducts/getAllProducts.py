import os
import sys
import json
import boto3
import logging
import uuid
from boto3.dynamodb.conditions import Key, Attr


logger = logging.getLogger()
logger.setLevel(logging.INFO)

#DynamodDB table name and region
DYNAMODB_REGION = "eu-west-3"
DYNAMODB_TABLE_NAME ="kong"

os.environ["AWS_DEFAULT_REGION"] = "eu-west-3"
dynamodb = boto3.resource('dynamodb',DYNAMODB_REGION)

#Bucket s3
BUCKET_NAME = 'my-bucket' # image bucket name
KEY = 'my_image_in_s3.jpg' # r object key
s3 = boto3.resource('s3')

def lambda_handler(event, context):

    return scan_table(DYNAMODB_TABLE_NAME)


def scan_table(table_name, filter_key=None, filter_value=None):
    table = dynamodb.Table(table_name)
    response = table.scan()
    api_response=[]
    for item in response['Items']:
        logger.info(item)
        api_item={}
        api_item['id']=item['id']
        api_item['name']=item['nom']
        api_response.append(api_item)
    logger.info(api_response)
    return api_response
