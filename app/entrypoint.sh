#!/usr/bin/env bash
set -e

MESSAGE="${ENV_MESSAGE:-Hello from default!}"

cat > /usr/share/nginx/html/index.html <<HTML
<!DOCTYPE html>
<html>
  <head>
    <title>GKE CI/CD Demo</title>
  </head>
  <body style="font-family: sans-serif; text-align:center; margin-top:10vh;">
    <h1>$MESSAGE</h1>
  </body>
</html>
HTML

nginx -g 'daemon off;'
