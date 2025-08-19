from flask import Flask
import os
import json

app = Flask(__name__)

@app.route("/")
def index():
    ssm_secret  = os.environ.get("SECRET_FROM_PARAMETER_STORE")
    smg_secret  = os.environ.get("SECRET_FROM_SECRETS_MANAGER")
    smg_db_user = os.environ.get("DB_USER")
    smg_db_pass = os.environ.get("DB_PASS")
    env_var1    = os.environ.get("ENV_VAR1")
    env_var2    = os.environ.get("ENV_VAR2")
    countrylist = json.dumps(os.environ.get("COUNTRYLIST"))    
    return f"""
    <html>
    <head><title>Demo v1.0 ECS</title>
    </head>
    <body>
    <h1>DEMO: Secrets Utilization on AWS ECS!</h1><br>
    <img src="https://adv-it.net/aws_logo.png">
    <h2>Retrieved Secrets and Environment Variables</h1>
    <table BORDER=solid CELLPADDING=4>    
        <tr><th>Variable</th><th>Value</th></tr>
        <tr><td>SECRET_FROM_PARAMETER_STORE</td><td>{ssm_secret}</td></tr>
        <tr><td>SECRET_FROM_SECRETS_MANAGER</td><td>{smg_secret}</td></tr>
        <tr><td>DB_USER</td>                    <td>{smg_db_user}</td></tr>
        <tr><td>DB_PASS</td>                    <td>{smg_db_pass}</td></tr>
        <tr><td>COUNTRYLIST</td>                <td>{countrylist}</td></tr>
        <tr><td>ENV_VAR1</td>                   <td>{env_var1}</td></tr>
        <tr><td>ENV_VAR2</td>                   <td>{env_var2}</td></tr>
    </table>
    <p>Copyleft &copy; by Denis Astahov - 2025.
    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=80)
