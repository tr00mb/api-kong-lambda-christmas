import os
import json
import requests

PRICE_KM=1.5
KEY = os.environ["MQ_APIKEY"]

WAREHOUSE_ADDRESS = "29+rue+Astorg,Paris,France,75008"
url = "https://www.mapquestapi.com/directions/v2/route"


def lambda_handler(event, context):
   #shipping_address = event['Records'][0]['address']
   #getPriceandDistance(shipping_address)
   pass

# def get as parameter the location
# and calculates distance to that point by querying MQ
def distanceCalc(address):
    payload = { 'key': KEY, 'from': WAREHOUSE_ADDRESS, 'to': address, 'outFormat': 'json' }
    r = requests.get(url,params=payload)
    json_data = json.loads(r.text)
    distance  = json_data["route"]["distance"]
    return distance

# def get distance and calculates price
def priceCalculation(distance):
    price = (distance * PRICE_KM)
    shipping_price = round(price,2)
    return shipping_price

def getPriceandDistance(shipping_address):
    distanceCalc(shipping_address)
    distanceValue = distanceCalc(shipping_address)
    price = priceCalculation(distanceValue)
    print("distance %s Price %s",(distanceValue,price))
