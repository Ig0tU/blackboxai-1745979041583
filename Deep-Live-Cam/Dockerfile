# Use official Python 3.10 slim image as base
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create models directory and download required models
RUN mkdir -p models && \
    curl -L -o models/GFPGANv1.4.pth https://huggingface.co/hacksider/deep-live-cam/resolve/main/GFPGANv1.4.pth && \
    curl -L -o models/inswapper_128_fp16.onnx https://huggingface.co/hacksider/deep-live-cam/resolve/main/inswapper_128_fp16.onnx && \
    chown -R appuser:appuser /app/models

# Copy the application code
COPY . .
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Set Python path
ENV PYTHONPATH=/app

# Default command to run the app
CMD ["python", "run.py"]
