openssl req -x509 \
  -newkey rsa:4096 -sha256 -nodes \
  -keyout tls.key -out tls.crt \
  -subj "/CN=ingress.local" -days 365
