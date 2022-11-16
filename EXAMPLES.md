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
