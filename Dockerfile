# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Rails app lives here
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    ruby


# Download and install websocketd
RUN wget https://github.com/joewalnes/websocketd/releases/download/v0.4.1/websocketd-0.4.1-linux_amd64.zip && \
    unzip websocketd-0.4.1-linux_amd64.zip && \
    mv websocketd /usr/local/bin/ && \
    rm websocketd-0.4.1-linux_amd64.zip

# Copy your Ruby script into the Docker image
COPY inventory.rb /app

# Ensure the Ruby script is executable
RUN chmod +x /app/inventory.rb

# Expose the port websocketd will use
EXPOSE 8080

# Define the command to run websocketd
CMD ["websocketd", "--port=8080", "ruby", "/app/inventory.rb"]

