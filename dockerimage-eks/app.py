from flask import Flask, Response
import os
import json

app = Flask(__name__)

@app.route("/")
def index():
    file1_path = "/mnt/secrets-from-secretsmanager.txt"
    file2_path = "/mnt/secrets-from-ssmparameter.txt"

    if not os.path.exists(file1_path):
        return Response("Secrets Manager file not found.", status=404)
    if not os.path.exists(file2_path):
        return Response("SSM Parameter Store file not found.", status=404)
    try:
        with open(file1_path, "r") as f1:
            smg_secret = f1.read()

        with open(file2_path, "r") as f2:
            ssm_secret = f2.read()

        return f"""
        <html>
        <head><title>Demo v1.0 EKS</title></head>
        <body>
            <h1>DEMO: Secrets Utilization on AWS EKS!</h1><br>
            <img src="https://adv-it.net/aws_logo.png">
            <h2>Retrieved Secrets</h2>
            <table border="1" cellpadding="4">
                <tr><th>Mounted Secret File</th><th>Value</th></tr>
                <tr><td>/mnt/secrets-from-secretsmanager.txt</td><td><pre>{smg_secret}</pre></td></tr>
                <tr><td>/mnt/secrets-from-ssmparameter.txt</td><td><pre>{ssm_secret}</pre></td></tr>
            </table>
            <p>Copyleft &copy; by Denis Astahov - 2025.</p>
        </body>
        </html>
        """
    except Exception as e:
        return Response(f"Error processing secrets: {e}", status=500)

if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=80)
