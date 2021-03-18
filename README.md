# How to install the neo-agent with helm:

## Prerequisities:
- k3d
- kubectl
- gcloud
- helm v3

## Procedure:

### Create your cluster:

```bash
k3d cluster create --k3s-server-arg "--no-deploy=traefik" \
--agents="2" \
--image="rancher/k3s:v1.20.2-k3s1" \
--port 80:80@loadbalancer \
--port 443:443@loadbalancer
```
### Import the neo image

```bash
gcloud auth login
gcloud auth configure-docker
docker pull gcr.io/traefiklabs/neo-agent:latest
k3d image import gcr.io/traefiklabs/neo-agent:latest
```

### Installation

If you want to install the neo-agent in a specific namespace, you need to:
- Create the specific namespace:

```bash
kubectl create namespace neo
```
- Then launch the installation with the imperative argument --namespace:

```bash
helm install neo neo/ --namespace neo
```
Otherwise if you want the neo-agent in the default namespace, just do:

```bash
helm install neo neo/
```

When the helm-chart deploy the neo-agent:
- First: The admission-webhook will create the crds with a job which run the k8s-webhook-cert-manager (https://github.com/newrelic/k8s-webhook-cert-manager). We know have the tls key/cert needed to make the admission-controller working.
- Second: We can now safely create our deployment with the deployment.yaml and service.yaml follow by the rbac composants.

### Launch unit tests
You need the helm-plugin: https://github.com/rancher/unittest

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
helm uninstall neo --namespace specific-namespace
```
