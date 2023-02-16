#! -*- coding:utf-8 -*-
import os

from flask_cors import cross_origin,CORS


from flask import Flask

app = Flask(__name__)



@app.route("/")
@cross_origin()
def top_homepage():
    return "test nginx port 4567"


if __name__ == '__main__':
    app.run(debug=True,port=4567)


