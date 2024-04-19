# Containers

The following containers need to run successfully on OpenShift.

* PHP-FPM
* Nginx
* MySQL
* Redis
* Varnish

From a container standpoint only the Nginx container needed additional customization to run on OpenShift.

These changes are discussed clearly in the following blog entry:

* https://torstenwalter.de/openshift/nginx/2017/08/04/nginx-on-openshift.html

For the proof of concept I went with the nginx unprvileged container with the adjustments to the nginx.conf discussed in the article above.

```dockerfile
ARG BASE_IMAGE
FROM $BASE_IMAGE as src

FROM --platform=linux/amd64 nginxinc/nginx-unprivileged:alpine3.17

COPY --from=src /var/www/html /var/www/html
```

However it looks like the official nginx:alpine container image can work as well as long as the nginx.conf changes are made.
