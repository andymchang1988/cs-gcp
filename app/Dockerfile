FROM nginx:alpine

# Copy template HTML
COPY index.html /usr/share/nginx/html/index.template.html

# Install envsubst
RUN apk add --no-cache gettext

# Replace ENV variable dynamically at container start
CMD envsubst < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html && \
    nginx -g "daemon off;"
