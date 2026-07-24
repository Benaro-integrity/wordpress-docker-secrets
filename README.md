# Dockerize A Wordpress Site
To deploy a WordPress site in a container, you need a minimum of two core containers (the WordPress application and a database), but a production-ready stack typically requires four services to handle traffic and security safely.

## Core Services (Mandatory)
These two containers are the bare minimum required to get your site running.
* WordPress Application Container: Runs the core WordPress PHP code. 
The official image on Docker Hub comes in two main flavors:
  - Apache version: Includes the web server built-in (easiest for quick setups).
  - PHP-FPM version: Just runs PHP and requires a separate web server container (better for high performance).
* Database Container: Stores your posts, users, and site configurations. You should use official images for either MySQL or MariaDB.

## Production Services
For deploying to a live website to the public internet, you should add these services to your stack:
* Reverse Proxy / Web Server Container: Acts as the entry point for your traffic.
  It handles SSL certificates, caches static assets, and forwards requests to your WordPress container.
  Common choices are Nginx, Traefik, or Apache.
* SSL Certificate Manager: Automatically provisions and renews free SSL certificates (HTTPS).
  Certbot (for Let's Encrypt) is standard if you are using Nginx, while Traefik can handle this natively without a separate container.

### Utility Services (Optional)
These tools make development and management easier but are not required for the site to stay online.
* Database Management Container: A web-based interface like phpMyAdmin or Adminer to let you easily inspect and modify tables without using the command line.
* Redis or Memcached Container: An in-memory data store used for object caching to drastically speed up page load times on busy production sites.

## Additional Consideration

Beyond the containers themselves, your container engine (like Docker Compose) must configure two supporting infrastructure components to prevent data loss and allow security:
* Persistent Volumes: Containers are temporary by design. You must configure persistent volumes to save your data outside the containers. You need one volume mapped to **/var/www/htm**l on the WordPress container (for plugins, themes, and media uploads) and another mapped to the database container's data directory.
* Isolated Network: A private bridge network that connects your containers. This allows WordPress to securely talk to the database while keeping the database hidden from the public internet. Only the web server/proxy should expose public ports (80 and 443).

## To Run or Deploy Containers
To deploy WordPress, MySQL, and phpMyAdmin together with data persistence, you use a Docker Compose file (**compose.yml**) to orchestrate these three official images and link them together.

## How This Setup Works
* Data Persistence: The volumes section at the bottom creates two managed Docker volumes (db_data and wp_data). Even if you stop, delete, or update your containers, your database entries and uploaded media will remain safe.
  - Access Ports:Visit http://localhost:8080 to view your WordPress site.
  - Visit http://localhost:8081 to log into phpMyAdmin (use root and your root password to log in).
* Security: The MySQL database does not expose any ports to your host machine. It can only be reached by WordPress and phpMyAdmin inside the secure wp_network.

## How to Run It And Implement Docker Secrets 
1.First, create a folder to house your sensitive parameters locally on your host machine. 
Run these commands in your project root terminal to save the secrets as plain-text files:
```
mkdir -p ./secrets
echo -n "your_root_db_password" > ./secrets/db_root_password.txt
echo -n "your_wp_db_password" > ./secrets/db_password.txt
```
2. Study  this [compose file](https://github.com/Benaro-integrity/wordpress-docker-secrets/blob/main/cloudboosta-wp/compose.yml), edit to suit your environment.
3. In your terminal, navigate to the compose file and run:
   ```
   docker compose up -d
   ```
4. Stop containers by running:
   ```
   docker compose down
   ```
