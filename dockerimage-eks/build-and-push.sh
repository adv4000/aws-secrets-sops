#!/bin/bash

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/adv-it
docker build -t eks-secrets .
docker tag eks-secrets:latest public.ecr.aws/adv-it/eks-secrets:latest
docker push public.ecr.aws/adv-it/eks-secrets:latest
