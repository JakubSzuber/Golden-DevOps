apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: test-apps
spec:
  generators:
  - git:
      repoURL: https://github.com/JakubSzuber/Golden-DevOps.git
      revision: HEAD
      directories:
      - path: helm-charts/*
  template:
    metadata:
      name: '{{path.basename}}'
    spec:
      project: default
      source:
        repoURL: https://github.com/JakubSzuber/Golden-DevOps.git
        targetRevision: HEAD
        path: '{{path}}'
        helm:
          valueFiles:
          - "values.yaml"
          - "values-${env_prefix}yaml"
      destination:
        server: https://kubernetes.default.svc
        namespace: '{{path.basename}}'
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
        syncOptions:
          - CreateNamespace=true
