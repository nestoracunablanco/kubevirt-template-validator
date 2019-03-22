# kubevirt-template-validator

`kubevirt-template-validator` is a [kubevirt](http://kubevirt.io) addon to check the [annotations on templates](https://github.com/kubevirt/common-templates/blob/master/templates/VALIDATION.md) and reject them if unvalid.
It is implemented using a [validating webhook](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/).

[![Go Report Card](https://goreportcard.com/badge/github.com/fromanirh/kubevirt-template-validator)](https://goreportcard.com/report/github.com/fromanirh/kubevirt-template-validator)

## License

Apache v2

## Dependencies

* [kubernetes APIs](https://github.com/kubernetes/kubernetes)


## Installation - K8S

**PLEASE NOTE**: vanilla kubernetes **does not support openshift template (obviously)** so the webhook
cannot function properly. Anyway, if you want to install it in your kubernetes cluster anyway, follow these steps:

1. Create and deploy the certificates in a Kubernetes Secret, to be used in the following steps:
```bash
./cluster/k8s/webhook-create-signed-cert.sh
```

2. [OPTIONAL] Check that the secret exists:
```bash
kubectl get secret -n kubevirt kubevirt-template-validator-certs
NAME                                TYPE      DATA      AGE
kubevirt-template-validator-certs   Opaque    2         1h
```

3. Deploy the service:
```bash
kubectl create -f ./cluster/k8s/manifests/service.yaml
```

4. Register the webhook. In order to set up the webhook, we need a CA bundle. We can reuse the one from the certs we create from the step #1.
```bash
cat ./cluster/k8s/manifests/validating-webhook.yaml | ./cluster/k8s/extract-ca.sh | kubectl apply -f -
```

Done!

### installation on OKD/OCP

1. Make sure the validating webhooks are enabled. You either need to configure the platform when you install it
or to use OKD/OCP >= 4.0. See:
- https://github.com/openshift/origin/issues/20842
- https://github.com/openshift/openshift-ansible/issues/7983

2. Then, make sure you have the `template:view` cluster role binding in your cluster. If not, add it:
```bash
oc create -f ./cluster/okd/manifests/template-view-role.yaml
```

3. Deploy the service:
```bash
kubectl create -f ./cluster/okd/manifests/service.yaml
```
OKD can automatically generate the TLS certificates thanks to the annotation in the provided manifests. So, unlike the steps
for kubernetes#1, you don't have to do this manually.

4. Register the webhook. Like for Kubernetes, we need to set up the CA bundle

TODO

### Disable the webhook

To disable the webhook, just de-register it from the apiserver:
```bash
$KUBECTL delete -f ./cluster/$PLATFORM/manifests/validating-webhook.yaml
```

## Caveats & Gotchas

content pending
