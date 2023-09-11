apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/group.name: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/backend-protocol: HTTPS
    # Use this annotation (which must match a service name) to route traffic to HTTP2 backends.
    alb.ingress.kubernetes.io/conditions.argogrpc: |
      [{"field":"http-header","httpHeaderConfig":{"httpHeaderName": "Content-Type", "values":["application/grpc"]}}]
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:152691795422:certificate/41d60ae4-de90-4d19-91e9-f146400d8dc7
    alb.ingress.kubernetes.io/ssl-redirect: '443'
  name: argocd
  namespace: argocd
spec:
  rules:
  - host: "${env_prefix}argo.goldendevops.com"
    http:
      paths:
      - path: /
        backend:
          service:
            name: argogrpc
            port:
              number: 443
            namespace: argocd
        pathType: Prefix
      - path: /
        backend:
          service:
            name: argocd-server
            port:
              number: 443
            namespace: argocd
        pathType: Prefix
  - host: "${env_prefix}goldendevops.com"
    http:
      paths:
      - path: /
        backend:
          service:
            name: golden-devops-helm-release
            port:
              number: 443
            namespace: argocd  # TODO Maybe change later
        pathType: Prefix
      - path: /
        backend:
          service:
            name: golden-devops-helm-release
            port:
              number: 443
            namespace: argocd  # TODO Maybe change later
        pathType: Prefix
  tls:
  - hosts:
    - "${env_prefix}argo.goldendevops.com"
    - "${env_prefix}goldendevops.com"
