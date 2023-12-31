#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install nginx -y
sudo apt install php-fpm -y
sudo systemctl start nginx
sudo printf "server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # SSL configuration
        #
        # listen 443 ssl default_server;
        # listen [::]:443 ssl default_server;
        #
        # Note: You should disable gzip for SSL traffic.
        # See: https://bugs.debian.org/773332
        #
        # Read up on ssl_ciphers to ensure a secure configuration.
        # See: https://bugs.debian.org/765782
        #
        # Self signed certs generated by the ssl-cert package
        # Don't use them in a production server!
        #
        # include snippets/snakeoil.conf;

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

        # pass PHP scripts to FastCGI server
        #
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
        #
        #       # With php-fpm (or other unix sockets):
                fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        #       # With php-cgi (or other tcp sockets):
        #       fastcgi_pass 127.0.0.1:9000;
        }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        location ~ /\.ht {
                deny all;
        }
}


# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#       listen 80;
#       listen [::]:80;
#
#       server_name example.com;
#
#       root /var/www/example.com;
#       index index.html;
#
#       location / {
#               try_files $uri $uri/ =404;
#       }
#}

" > /etc/nginx/sites-available/default
sudo touch /var/www/html/index.php
sudo chmod -R 777 /var/www/html
rm /var/www/html/index.nginx-debian.html
sudo printf '<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="./assets/favicon.ico" type="image/x-icon">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@300;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="./assets/main.css">

    <title>Server Stats</title>
</head>

<body>

    <div id="wrapper">
        <h1 id="pageTitle">AWS Server Information</h1>
        <div class="twoColRow">
            <div class="serverStats">
                <img src="./assets/server.png" alt="" class="icon">
                <h2 class="statsValue">
                    <?php $serverName = gethostname();
                    echo "$serverName"; ?>
                </h2>
            </div>
            <div class="serverStats">
                <img src="./assets/clock.png" alt="" class="icon">
                <h2 class="statsValue">
                    <?php $serverTime = date_default_timezone_get();
                    echo "$serverTime"; ?>
                </h2>
            </div>
        </div>
        <p id="copyright">&copy; <?php echo date("Y"); ?> &bull; All Rights Reserved.</p>
    </div>

</body>

</html>' > /var/www/html/index.php
sudo systemctl restart nginx
