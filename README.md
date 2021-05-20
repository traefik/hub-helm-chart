# Neo 

## Introduction

This chart install the Neo-agent as a Kubernetes deployment.

## Installation

### Prerequisities:

With the command `helm version`, make sure that you have:
- Helm v3 [installed](https://helm.sh/docs/using_helm/#installing-helm)

Add Neo's chart repository to Helm:

```bash
helm repo add neo https://helm.traefik.io/neo
```

You can update the chart repository by running:

```bash
helm repo update
```

### Deploying Neo

```bash
helm install neo neo/neo
```

### Deploying Neo with a full-yaml

```bash
kubectl apply -f https://traefik.github.io/neo-helm-chart/yaml/0.1.1.yaml
```

### Specifications 

If you want to install the neo-agent in a specific namespace, you need to:
- Create the specific namespace:

```bash
kubectl create namespace neo
```
- Then launch the installation with the imperative argument --namespace:

```bash
helm install neo neo/ --namespace neo
```

### Launch unit tests

You need the helm-plugin: https://github.com/rancher/helm-unittest

Then:

```bash
helm unittest neo/
```

### Uninstall

We consider in this example the version install being <neo>:

```bash
helm uninstall neo
```
If neo-agent was install in a specific namespace

```bash
helm uninstall neo --namespace neo-namespace
```
