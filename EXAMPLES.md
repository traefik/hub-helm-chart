# Deploy Hub Agent on a different namespace

```bash
export HUB_TOKEN=XXXXX
helm upgrade --install hub-agent traefik/hub-agent \
  --namespace hub --create-namespace
  --set token="${HUB_TOKEN}"
```

# Deploy Hub Agent with IngressClass and debug Log Level

```bash
export INGRESS_CLASS_NAME=my-ingress-class
export HUB_TOKEN=XXXXX
helm upgrade --install hub-agent traefik/hub-agent \
  --set controllerDeployment.args="{--log-level=debug,--ingress-class-name=${INGRESS_CLASS_NAME}}"
  --set token="${HUB_TOKEN}"
```

# Generate YAML to manage with a GitOps tool

You will need to create a `Secret` _hub-token_ with a valid _token_
```bash
helm template traefik-hub --namespace hub-agent \
  --set tokenSecretRef.name=hub-token --set tokenSecretRef.key=token \
  --set withoutHelmLabels=true --include-crds traefik/hub-agent
```
