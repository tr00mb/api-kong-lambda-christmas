import os
import sys
import json
import boto3
import logging
import uuid
import boto3
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

    return scan_table(DYNAMODB_TABLE_NAME,None,None)['Items']


def scan_table(table_name, filter_key=None, filter_value=None):
    """
    Perform a scan operation on table.
    Can specify filter_key (col name) and its value to be filtered.
    """
    table = dynamodb.Table(table_name)

    if filter_key and filter_value:
        filtering_exp = Key(filter_key).eq(filter_value)
        response = table.scan(FilterExpression=filtering_exp)
        #query_s3_for_image(response)
    else:
        response = table.scan()
        #query_s3_for_image(response)
    print(response)
    return response

def query_s3_for_image(response):
    for i in response['Items']:
        image_url= i['image_url']
        try:
            Key(BUCKET_NAME)
            s3.Bucket(BUCKET_NAME).download_file(Key, image_url)
            #print("Nom : %s , Libelle : %s , prix : %d ,image_produit" %(i['nom'],i['libelle'],i['prix'],i['image_url']))
        except botocore.exceptions.ClientError as e:
            if e.response['Error']['Code'] == "404":
                print("The object does not exist.")
            else:
                raise
<<<<<<< HEAD
=======


scan_table(DYNAMODB_TABLE_NAME,None,None)
>>>>>>> 6901d1fc95c4312ef2f14faa6fbeb3ce709d7698
