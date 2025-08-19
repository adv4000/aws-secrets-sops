# ------------------------------------------------------------------------------
# Lambda Function for AWS Secrets Retrieval Demo
#
# Version  Date              Name            Info
# 1.0      22-August-2025    Denis Astahov   Initial Version
#
# ------------------------------------------------------------------------------
import boto3
import os
import json

ssm = boto3.client('ssm')
smg = boto3.client('secretsmanager')

arn_ssm_secret  = os.environ.get("SECRET_FROM_PARAMETER_STORE")
arn_smg_secret  = os.environ.get("SECRET_FROM_SECRETS_MANAGER")
env_var1        = os.environ.get("ENV_VAR1")
env_var2        = os.environ.get("ENV_VAR2")

ssm_secret  = ssm.get_parameter(Name=arn_ssm_secret,WithDecryption=True)['Parameter']['Value']
smg_secret  = smg.get_secret_value(SecretId=arn_smg_secret)['SecretString']

ssm_secret = json.loads(ssm_secret)
smg_secret = json.loads(smg_secret)

smg_db_user = smg_secret['masterDB.user']
smg_db_pass = smg_secret['masterDB.pass']
countrylist = ssm_secret['central_asia_ug_countries']

def lambda_handler(event, context):
    try:
        message = f"""
        <html>
        <head><title>Demo v1.0 Lambda</title>
        </head>
        <body>
        <h1>DEMO: Secrets Utilization on AWS Lambda using boto3!</b></h1><br>
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

    except Exception as error:
        print("Error occuried! Error Message: " + str(error))

    return {
       "statusCode": 200,
       "headers"    : { "Content-Type": "text/html" },
       "body"       : message
    }
