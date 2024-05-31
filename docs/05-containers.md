# Containers

The following containers need to run successfully on OpenShift.

* PHP-FPM
* Nginx
* PostgreSQL (leveraging Crunchy DB operator)
* Redis (not enabled)
* Solr
* Varnish

From a container standpoint only the Nginx container needed additional customization to run on OpenShift.

These changes are discussed in the following blog entry:

* https://torstenwalter.de/openshift/nginx/2017/08/04/nginx-on-openshift.html

For the initial proof of concept, we chose the NGINX unprivileged container, making adjustments to the nginx.conf as discussed in the article above.

```dockerfile
ARG BASE_IMAGE
FROM $BASE_IMAGE as src

FROM --platform=linux/amd64 nginxinc/nginx-unprivileged:alpine3.17
COPY --from=src /var/www/html /var/www/html
```

However, the official nginx:alpine container image can work as well, so the appropriate changes were made.
