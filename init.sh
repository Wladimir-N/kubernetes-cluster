#!/bin/bash
# Инициализация мастера
kubeadm init --config kubeadm-config.yaml

# Ставим cni
curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz{,.sha256sum}
cilium config set ipam kubernetes
cilium install

# устанавливаем ингрес
k edit node k8s-ingress195
metadata:
...
  labels:
...
    node-role.kubernetes.io/ingress: ""
helm upgrade --install ingress-nginx ingress-nginx   --repo https://kubernetes.github.io/ingress-nginx   --namespace ingress-nginx --create-namespace -f ingress/values.yaml
