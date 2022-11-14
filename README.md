# Traefik Hub Helm Chart

## Introduction

This chart installs the Hub agent in a Kubernetes cluster.
The agent consists of two deployments: a controller and multiple authentication servers.

## Installation

### Prerequisites

With the command `helm version`, make sure that you have:
- Helm v3 [installed](https://helm.sh/docs/using_helm/#installing-helm)

Add Hub's chart repository to Helm:

```bash
helm repo add traefik https://traefik.github.io/charts
```

You can update the chart repository by running:

```bash
helm repo update
```

### Deploying Hub

```bash
helm install hub-agent traefik/hub-agent
```

### Deploying Hub with a full-yaml

```bash
kubectl apply -f https://traefik.github.io/hub-helm-chart/yaml/1.0.0.yaml
```

### Specifications

If you want to install the hub-agent in a specific namespace, you need to:

- Create the specific namespace:

```bash
kubectl create namespace hub
```

- Then launch the installation with the imperative argument --namespace:

```bash
helm install hub-agent traefik/hub-agent --namespace hub
```

### Launch unit tests

```bash
make test
```

### Uninstall

We consider in this example the version install being <hub>:

```bash
helm uninstall hub-agent
```

If hub-agent was installed in a specific namespace

```bash
helm uninstall hub-agent --namespace hub-namespace
```
