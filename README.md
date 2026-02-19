# Halon containers

This repository contains instructions on how to build container images of our [Halon Engage & Protect](https://halon.io/) components as well as the threat protection components we provide. It also includes sample configurations for deploying these container images on [K8s](https://kubernetes.io) (Kubernetes).

## Components

Below are the components we currently have instructions for.

### Halon MTA

| Component    | Description                       | Instructions                 |
| ------------ | ----------------------------------| ---------------------------- |
| `smtpd`      | The main MTA process              | [Link](smtpd/README.md)      |
| `api`        | HTTP/JSON API                     | [Link](api/README.md)        |
| `clusterd`   | Delivery Orchestrator             | [Link](clusterd/README.md)   |
| `policyd`    | Halon Delivery Guru - Warmup      | [Link](policyd/README.md)   |
| `web`        | Web administration                | [Link](web/README.md)        |
| `classifier` | Delivery Guru: Bounce Classifier  | [Link](classifier/README.md) |
| `rated`      | Rate limiting implementation      | [Link](rated/README.md)      |
| `dlpd`       | Data Loss Prevention (DLP) engine | [Link](dlpd/README.md)       |

### Threat protection

| Component    | Description         | Instructions                |
| ------------ | ------------------- | --------------------------- |
| `expurgate`  | eXpurgate Anti-Spam | [Link](expurgate/README.md) |
| `savdid`     | Sophos Anti-Virus   | [Link](savdid/README.md)    |
| `sasid`      | Sophos Anti-spam    | [Link](sasid/README.md)     |

## Kubernetes / Helm

Below are the instructions for configuring and deploying the Helm charts.

### Configure

The `main/values.yaml` file contains most of the settings that can be configured.
Some additional settings can also be found in the `values.yaml` files inside each subfolder.

### Deploy

To deploy the Helm charts first build the images as described in each subfolder and then run the following commands:

```
helm dependency update main
helm install halon main --render-subchart-notes
```

### Elasticsearch

You can use the following Helm commands to install [Elasticsearch](https://www.elastic.co/elasticsearch) which can be used with some of our components.

> [!IMPORTANT]
> This installs Elasticsearch with a default configuration, see [here](https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/install-using-helm-chart) and [here](https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/managing-deployments-using-helm-chart) for all the available configuration options.

```
helm repo add elastic https://helm.elastic.co
helm repo update
helm install elastic-operator elastic/eck-operator -n elastic-system --create-namespace
helm install es-quickstart elastic/eck-stack -n elastic-stack --create-namespace --set=eck-kibana.enabled=false
```

You should now have an Elasticsearch service running on `https://elasticsearch-es-default.elastic-stack.svc.cluster.local:9200`.

To get the password for the `elastic` user you can run the below command.

```
kubectl -n elastic-stack get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}{{"\n"}}'
```

### Prometheus

You can use the following commands to install Prometheus in Kubernetes

```
minikube addons enable metrics-server
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install halon-kps prometheus-community/kube-prometheus-stack \
--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
--set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
--set-json prometheus.prometheusSpec.serviceMonitorSelector={} \
--set-json prometheus.prometheusSpec.serviceMonitorNamespaceSelector={} \
--set-json prometheus.prometheusSpec.podMonitorSelector={} \
--set-json prometheus.prometheusSpec.podMonitorNamespaceSelector={}
helm install halon-pa prometheus-community/prometheus-adapter \
  --set prometheus.url=http://prometheus-operated.default.svc.cluster.local \
  --set prometheus.port=9090 \
  --set rules.default=true
```

Then enable `global.smtpd.prometheus.enabled` in `main/values.yaml`.
You should now be able to for example autoscale on the `halon_queue_queue_active_size` metric.
