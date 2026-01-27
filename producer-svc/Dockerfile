FROM python:3.9.25-slim

WORKDIR /app

# Copy app and install Python deps
COPY app ./app
RUN pip install --no-cache-dir -r app/requirements.txt

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
