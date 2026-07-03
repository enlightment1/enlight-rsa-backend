FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY railway.json .

RUN mkdir -p /data/uploads

EXPOSE 8000

# CMD removed - startCommand in railway.json will be used
