curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable sh -s - \
  --disable traefik \
  --disable metrics-server \
  --disable local-storage \
  --kube-apiserver-arg="oidc-issuer-url=https://axatol.au.auth0.com/" \
  --kube-apiserver-arg="oidc-client-id=${OIDC_CLIENT_ID}" \
  --kube-apiserver-arg="oidc-username-claim=email" \
  --kube-apiserver-arg="oidc-username-prefix=oidc:" \
  --kube-apiserver-arg="oidc-groups-prefix=oidc:"
