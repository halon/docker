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
RELEASE=halon
NAMESPACE=default
helm dependency update main
helm install ${RELEASE} main --render-subchart-notes --namespace ${NAMESPACE} --create-namespace
```

### TLS

To enable TLS communication between the control sockets of the different pods run the below commands.

#### Create a CA

```
DAYS=3650
NUMBITS=4096
CN=halon-ca

openssl genrsa -out halon-ca.key ${NUMBITS}
openssl req -x509 -new -nodes -sha256 -days ${DAYS} -key halon-ca.key -out halon-ca.crt -subj "/CN=${CN}"

kubectl -n "${NAMESPACE}" create configmap halon-tls-ca-crt --from-file=tls.crt=halon-ca.crt
```

#### Generate `smtpd` controlsocket server certificate and key

```
DAYS=3650
NUMBITS=2048
CN="${RELEASE}-smtpd.${NAMESPACE}.svc"
SAN="DNS:${RELEASE}-smtpd,DNS:${RELEASE}-smtpd.${NAMESPACE},DNS:${RELEASE}-smtpd.${NAMESPACE}.svc,DNS:${RELEASE}-smtpd.${NAMESPACE}.svc.cluster.local"

openssl genrsa -out ${RELEASE}-smtpd-controlsocket-server.key ${NUMBITS}
openssl req -new -sha256 -key ${RELEASE}-smtpd-controlsocket-server.key -out ${RELEASE}-smtpd-controlsocket-server.csr -subj "/CN=${CN}"
openssl x509 -req -sha256 -days ${DAYS} -in ${RELEASE}-smtpd-controlsocket-server.csr -CA halon-ca.crt -CAkey halon-ca.key -CAcreateserial -out ${RELEASE}-smtpd-controlsocket-server.crt -extfile <(printf "subjectAltName=%s" "${SAN}")

kubectl -n "${NAMESPACE}" create secret tls ${RELEASE}-smtpd-tls-controlsocket-server --cert=${RELEASE}-smtpd-controlsocket-server.crt --key=${RELEASE}-smtpd-controlsocket-server.key
kubectl -n "${NAMESPACE}" create configmap ${RELEASE}-smtpd-tls-controlsocket-server-crt --from-file=tls.crt=${RELEASE}-smtpd-controlsocket-server.crt
```

#### Generate `smtpd` controlsocket client certificate and key

```
DAYS=3650
NUMBITS=2048
CN="${RELEASE}-smtpd.${NAMESPACE}.svc"
SAN="DNS:${RELEASE}-smtpd,DNS:${RELEASE}-smtpd.${NAMESPACE},DNS:${RELEASE}-smtpd.${NAMESPACE}.svc,DNS:${RELEASE}-smtpd.${NAMESPACE}.svc.cluster.local"

openssl genrsa -out ${RELEASE}-smtpd-controlsocket-client.key ${NUMBITS}
openssl req -new -sha256 -key ${RELEASE}-smtpd-controlsocket-client.key -out ${RELEASE}-smtpd-controlsocket-client.csr -subj "/CN=${CN}"
openssl x509 -req -sha256 -days ${DAYS} -in ${RELEASE}-smtpd-controlsocket-client.csr -CA halon-ca.crt -CAkey halon-ca.key -CAcreateserial -out ${RELEASE}-smtpd-controlsocket-client.crt -extfile <(printf "subjectAltName=%s" "${SAN}")

kubectl -n "${NAMESPACE}" create secret tls ${RELEASE}-smtpd-tls-controlsocket-client --cert=${RELEASE}-smtpd-controlsocket-client.crt --key=${RELEASE}-smtpd-controlsocket-client.key
kubectl -n "${NAMESPACE}" create configmap ${RELEASE}-smtpd-tls-controlsocket-client-crt --from-file=tls.crt=${RELEASE}-smtpd-controlsocket-client.crt
```

#### Generate `clusterd` controlsocket server certificate and key

```
DAYS=3650
NUMBITS=2048
CN="${RELEASE}-clusterd.${NAMESPACE}.svc"
SAN="DNS:${RELEASE}-clusterd,DNS:${RELEASE}-clusterd.${NAMESPACE},DNS:${RELEASE}-clusterd.${NAMESPACE}.svc,DNS:${RELEASE}-clusterd.${NAMESPACE}.svc.cluster.local"

openssl genrsa -out ${RELEASE}-clusterd-controlsocket-server.key ${NUMBITS}
openssl req -new -sha256 -key ${RELEASE}-clusterd-controlsocket-server.key -out ${RELEASE}-clusterd-controlsocket-server.csr -subj "/CN=${CN}"
openssl x509 -req -sha256 -days ${DAYS} -in ${RELEASE}-clusterd-controlsocket-server.csr -CA halon-ca.crt -CAkey halon-ca.key -CAcreateserial -out ${RELEASE}-clusterd-controlsocket-server.crt -extfile <(printf "subjectAltName=%s" "${SAN}")

kubectl -n "${NAMESPACE}" create secret tls ${RELEASE}-clusterd-tls-controlsocket-server --cert=${RELEASE}-clusterd-controlsocket-server.crt --key=${RELEASE}-clusterd-controlsocket-server.key
kubectl -n "${NAMESPACE}" create configmap ${RELEASE}-clusterd-tls-controlsocket-server-crt --from-file=tls.crt=${RELEASE}-clusterd-controlsocket-server.crt
```

#### Generate `smtpd-api` web server certificate and key

```
DAYS=3650
NUMBITS=2048
CN="${RELEASE}-smtpd-api.${NAMESPACE}.svc"
SAN="DNS:${RELEASE}-smtpd-api,DNS:${RELEASE}-smtpd-api.${NAMESPACE},DNS:${RELEASE}-smtpd-api.${NAMESPACE}.svc,DNS:${RELEASE}-smtpd-api.${NAMESPACE}.svc.cluster.local"

openssl genrsa -out ${RELEASE}-smtpd-api.key ${NUMBITS}
openssl req -new -sha256 -key ${RELEASE}-smtpd-api.key \-out ${RELEASE}-smtpd-api.csr -subj "/CN=${CN}"
openssl x509 -req -sha256 -days ${DAYS} -in ${RELEASE}-smtpd-api.csr -CA halon-ca.crt -CAkey halon-ca.key -CAcreateserial -out ${RELEASE}-smtpd-api.crt -extfile <(printf "subjectAltName=%s" "${SAN}")

kubectl -n "${NAMESPACE}" create secret tls ${RELEASE}-smtpd-api-tls --cert=${RELEASE}-smtpd-api.crt --key=${RELEASE}-smtpd-api.key
kubectl -n "${NAMESPACE}" create configmap ${RELEASE}-smtpd-api-tls-crt --from-file=tls.crt=${RELEASE}-smtpd-api.crt
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