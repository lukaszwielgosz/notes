# nginx and node.js
https://stackoverflow.com/questions/5009324/node-js-nginx-what-now

https://breuer.dev/tutorial/Nginx-Server-Blocks.html

wiki.conf
```
upstream wiki{
	server 127.0.0.1:3000;
	keepalive 8;
}

server {
	listen 3001;
	listen [::]:3001;
	server_name _;
	access_log /var/log/nginx/wiki.log;

	location /{
		proxy_set_header X-Real-IP $remote_addr;
      		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      		proxy_set_header Host $http_host;
		proxy_set_header X-NginX-Proxy true;

		proxy_pass http://wiki;
		proxy_redirect off;

		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
	}
}
```

## firewall 
```
sudo firewall-cmd --add-port=3001/tcp
sudo firewall-cmd --add-port=3001/tcp --permanent
```

## SSL
https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04

