# 🌟 Django Deployment Script 🌟

This repository contains a **Bash script** designed to streamline the deployment of Django projects on **AWS EC2 instances** using **Docker** and **Docker Compose**. The script automates essential tasks such as cloning the project, installing dependencies, configuring services, and deploying the application.

## ✨ Features

- **🚀 Automated Setup**:
  - Clones your Django project from a Git repository.
  - Installs necessary dependencies: `docker.io`, `docker-compose`, and `nginx`.
- **🔧 Conflict Resolution**:
  - Automatically detects if port 80 is in use and remaps Nginx to port 8080 if necessary.
- **🐳 Docker Integration**:
  - Builds and deploys Docker containers for your Django app.
- **⚙️ System Configuration**:
  - Restarts and enables essential services like Docker and Nginx.
- **❗ Error Handling**:
  - Provides informative error messages and supports notification mechanisms for failure cases.

---

## 📋 Prerequisites

Ensure the following are available on your AWS EC2 instance:
1. 🖥️ A Linux-based operating system (e.g., Ubuntu).
2. 🔑 Access to the terminal with root privileges.
3. 📂 A valid Git repository URL for the Django project.
4. ⚙️ Docker and Docker Compose should not already be configured on conflicting ports.

---

## 🛠️ How to Use

1. **🔗 Clone this Repository**:
   ```bash
   git clone <this-repo-url>
   cd <repo-directory>
   ```

2. **🔒 Make the Script Executable**:
   ```bash
   chmod +x Django-deployment.sh
   ```

3. **▶️ Run the Script**:
   ```bash
   ./Django-deployment.sh
   ```

4. **📜 Follow the Prompts**:
   - Enter the Django project name.
   - Provide the Git repository URL.

5. **👀 Monitor Deployment**:
   - The script will automatically handle the deployment process.
   - On successful deployment, the application will be available via the configured port (default: 80, fallback: 8080).

---

## 📚 Examples of Use

### Example 1: Deploying a Django Project

1. Run the script:
   ```bash
   ./Django-deployment.sh
   ```

2. Enter your Django project details:
   ```
   Enter the project name: my-django-app
   Enter the project URL: https://github.com/username/my-django-app.git
   ```

3. Observe the deployment logs and confirm the app is running:
   ```bash
   docker-compose ps
   curl http://localhost
   ```

---

## 🛠️ Customization Examples

### 1. **🔐 Add Environment Variables**
Modify the `docker-compose.yml` to include environment variables for sensitive data like database credentials.

```yaml
version: "3.8"
services:
  web:
    build: .
    ports:
      - "80:8000"
    environment:
      DJANGO_SECRET_KEY: "your-secret-key"
      DJANGO_DEBUG: "False"
      DATABASE_URL: "postgres://user:password@db:5432/app_db"
```

To pass environment variables:
```bash
export DJANGO_SECRET_KEY=your-secret-key
export DJANGO_DEBUG=False
export DATABASE_URL=postgres://user:password@db:5432/app_db
```

### 2. **🖧 Use a Custom Nginx Configuration**

Edit `nginx.conf` to modify server configurations:
```nginx
server {
    listen 8080;
    server_name my-app.com;

    location / {
        proxy_pass http://web:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

To apply it:
1. Add the file to the `nginx` service in `docker-compose.yml`:
   ```yaml
   services:
     nginx:
       image: nginx
       volumes:
         - ./nginx.conf:/etc/nginx/nginx.conf
   ```

2. Restart the services:
   ```bash
   docker-compose down
   docker-compose up --build -d
   ```

### 3. **📧 Implement Email Notifications for Deployment Failures**

Update the script to include email notifications:
```bash
deploy() {
    if ! docker-compose up --build -d; then
        echo "Deployment failed. Sending email to admin..."
        echo "Deployment failed on $(hostname)" | mail -s "Deployment Error" admin@example.com
        return 1
    fi
}
```

Install `mailutils` for email support:
```bash
sudo apt install mailutils
```

---

## 🛠️ Troubleshooting

- **⚠️ Port Conflicts**:
  - If port 80 is busy, the script automatically maps Nginx to port 8080.
- **🐳 Deployment Errors**:
  - Check Docker logs for debugging:
    ```bash
    docker-compose logs
    ```
  - Verify Nginx status:
    ```bash
    sudo systemctl status nginx
    ```
- **❌ Missing Dependencies**:
  - Ensure Docker and Docker Compose are correctly installed.

---

## 👨‍💻 Author

**Sujal Sahu**  
Version: 1.0  

For suggestions or issues, please raise a GitHub issue or contact the author.  

---

