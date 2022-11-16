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

### Specifications

If you want to install the hub-agent in a specific namespace, you need to:

- Then launch the installation with the imperative argument --namespace and --create-namespace:

```bash
helm install hub-agent traefik/hub-agent --namespace hub --create-namespace
```

### Launch unit tests

```bash
make test
```

### Uninstall

```bash
helm uninstall hub-agent
```

If hub-agent was installed in a specific namespace

```bash
helm uninstall hub-agent --namespace hub-namespace
```
