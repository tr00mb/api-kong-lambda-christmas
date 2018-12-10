import json
from botocore.vendored import requests
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

    address = event['request_body_args']['address']
    products = event['request_body_args']['products']
    for product in products:
        logger.info(product['id'])
        logger.info(product['quantity'])
        headers = {"content-type": "application/json"}
        getDetail = requests.get('http://35.180.196.52:8000/workshop/products/'+str(product['id']), headers=headers)
        logger.info(getDetail.json()[0]['prix'])
    return {}
