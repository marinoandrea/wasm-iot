FROM python:3.10-slim

WORKDIR /var/changeData
COPY requirements.txt .

# Update default packages
RUN apt-get update

RUN pip install -r requirements.txt

ENTRYPOINT ["/bin/sh", "transform_data.sh"]

