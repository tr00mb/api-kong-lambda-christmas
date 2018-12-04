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


def add_item(table_name, col_dict):
    """
    Add one item (row) to table. col_dict is a dictionary {col_name: value}.
    """
    table = dynamodb.Table(table_name)
    response = table.put_item(Item=col_dict)
    return response


#Item for test Add products
example_item ={
    "id" :str(uuid.uuid4()),
    "libelle" : "MANGER",
    "nom" :"lufred",
    "image_name" : "beautifull",
    "prix":17
}

#add_item(DYNAMODB_TABLE_NAME,example_item)