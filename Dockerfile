# We Use an official Python runtime as a parent image
FROM python:3.7
 
# The environment variable ensures that the python output is set straight
# to the terminal without buffering it first
ENV PYTHONUNBUFFERED 1

COPY ./ ./base
WORKDIR ./base

RUN pip3 install pipreqs
RUN pip3 install -r requirements.txt
