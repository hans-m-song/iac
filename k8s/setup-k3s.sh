curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable \
  sh -s - \
  --disable traefik \
  --disable metrics-server