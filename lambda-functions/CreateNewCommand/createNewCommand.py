import json
from botocore.vendored import requests
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

KEY = os.environ["MQ_APIKEY"]
API_URL = os.environ["API_URL"]
WAREHOUSE_ADDRESS = "29+rue+Astorg,Paris,France,75008"
PRICE_KM=1.5

def lambda_handler(event, context):

    address = event['request_body_args']['address']
    products = event['request_body_args']['products']
    sum_price =0.0
    for product in products:
        logger.info(product['id'])
        logger.info(product['quantity'])
        headers = {"content-type": "application/json"}
        getDetail = requests.get(API_URL+'/workshop/products/'+str(product['id']), headers=headers)
        logger.info(getDetail.json()['prix'])
        sum_price = (float(product['quantity']) * (getDetail.json()['prix']))+sum_price

    distance = distanceCalc(address)
    delivery_cost = priceCalculation(distance)
    Total_price =sum_price + delivery_cost
    return {"distance":distance, "delivery_cost":delivery_cost, "total_price":Total_price}

# def get as parameter the location
# and calculates distance to that point by querying MQ
def distanceCalc(address):
    payload = { 'key': KEY, 'from': WAREHOUSE_ADDRESS, 'to': address, 'outFormat': 'json' }
    r = requests.get(API_URL+'/distances',params=payload)
    json_data = json.loads(r.text)
    distance  = json_data["route"]["distance"]
    return distance

# def get distance and calculates price
def priceCalculation(distance):
    price = (distance * PRICE_KM)
    shipping_price = round(price,2)
    return shipping_price
