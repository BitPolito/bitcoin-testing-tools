# Ref:
from flask import Flask, request, abort
import requests
import os

api = Flask(__name__)


@api.route("/", methods=['GET'])
def index():
    return "Bitcoin Faucet!"


@api.route('/faucet', methods=['GET'])
def get_faucet():
    url = "http://localhost:38332/"
    auth = ("bitcoin", "bitcoin")
    headers = {"content-type": "text/plain;"}

    try:
        address = request.args.get('address')
        response = requests.post(
            url,
            auth=auth,
            headers=headers,
            json={"jsonrpc": "1.0",
                  "id": "faucet",
                  "method": "sendtoaddress",
                  "params": [address, 1.5]})
        return "Success"
    except:
        return 401
