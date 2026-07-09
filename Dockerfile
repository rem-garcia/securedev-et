FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python create_db.py

EXPOSE 5000

CMD ["python", "-c", "from vulnerable_flask_app import app; app.run(host='0.0.0.0', port=5000, debug=True)"]
