FROM python:3.13-slim

# Install dependencies
RUN pip install flask

# Create app directory
WORKDIR /app

# Copy application code
COPY app.py .

# Run Flask app
CMD ["flask", "run", "--host=0.0.0.0", "--port=80"]
