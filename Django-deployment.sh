#!/bin/bash

<< 'Description'

Author: Sujal Sahu
Version: 1.0
Description: This script is used to deploy Django project on AWS EC2 instance by using Docker.

Description

#taking Input from user
user_input() {
    read -p "Enter the project name: " project_name
    read -p "Enter the project Url: " project_path
}

#cloinig the project from git
code_clone() {
    if [ -d "$project_name" ]; then
        echo "Project already exists"
        cd "$project_name"
    else
        git clone $project_path || {
            echo "Unable to clone the project"
            exit 1
        }
        cd $project_name
    fi
}

#installing the requirement
install_requirements() {
    sudo apt update && sudo apt install docker.io docker-compose nginx -y || {
        echo "unable to install requirements"
        exit 1
    }
}

#enable & start the service
required_restarts() {

        echo "Performing required restarts..."

        sudo chown "$USER" /var/run/docker.sock || {

        echo "Failed to change ownership of docker.sock."
        return 1

}
        #uncomment this if required
        sudo systemctl restart nginx && sudo systemctl enable nginx
        sudo systemctl restart docker && sudo systemctl enable docker

}

deploy() {
    echo "Checking for conflicts on port 80..."

    # Check if port 80 is already in use
    if lsof -i :80 >/dev/null; then
        echo "Port 80 is in use. Remapping Nginx to port 8080."

        # Update docker-compose.yml to use port 8080 instead of 80
        if [ -f docker-compose.yml ]; then
            sed -i 's/80:80/8080:80/' docker-compose.yml || {
                echo "Failed to update port mapping in docker-compose.yml."
                return 1
            }
        else
            echo "docker-compose.yml not found!"
            return 1
        fi
    else
        echo "Port 80 is free. Using default configuration."
    fi

    echo "Building and deploying the Django app..."

    # Stop any existing containers
    docker-compose down

    # Build and deploy containers
    docker-compose up --build -d || {
        echo "Failed to build and deploy the app."
        return 1
    }
}


# Main deployment script
echo "********** DEPLOYMENT STARTED *********"

#taking userinput
if ! user_input; then
        echo "unable to get input"
        exit;
fi

# Clone the code
if ! code_clone; then
    exit 1
fi

# Install dependencies
if ! install_requirements; then
    exit 1
fi

# Perform required restarts
if ! required_restarts; then
    exit 1
fi

# Deploy the app
if ! deploy; then
    echo "Deployment failed. Mailing the admin..."
    # Add your sendmail or notification logic here
    exit 1
fi

echo "********** DEPLOYMENT DONE *********"