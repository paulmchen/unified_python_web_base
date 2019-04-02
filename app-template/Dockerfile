# We Use an official Python runtime as a parent image
FROM unified_pyweb_base:latest 


ENV http_proxy http://10.213.96.52:3128/
ENV https_proxy http://10.213.96.52:3128/

COPY ./ ./app
WORKDIR ./app

CMD ["ls -l"]
RUN pipreqs --debug ./
RUN pip3 install -r ./requirements.txt
ENTRYPOINT ["./entrypoint.sh"]
