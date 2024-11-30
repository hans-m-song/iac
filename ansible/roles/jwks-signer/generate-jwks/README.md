# Generate JWKS

Sources:

- https://github.com/aws/amazon-eks-pod-identity-webhook/blob/master/hack/self-hosted/main.go

```shell
go run main.go -key sa-signer-pub.pem
```
