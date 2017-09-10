from flask import Flask, jsonify, request, g, send_file, render_template

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/healthcheck", methods=["GET"])
def healthcheck():
    return('may the seven watch over us')

@app.route("/registration.html")
def register():
    return render_template("registration.html")

@app.route("/registration.html", methods=["POST"])
def placeholder():
    return render_template("registration.html")

@app.route("/login.html", methods=["POST"])
def lPlaceholder():
    return render_template("login.html")

@app.route("/login.html")
def login():
    return render_template("login.html")

if __name__ == '__main__':
    app.run(host="0.0.0.0")
