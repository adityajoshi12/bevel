# helm repo add hashicorp https://helm.releases.hashicorp.com
# kubectl create namespace vault
# helm install vault hashicorp/vault --namespace vault -f vault/values.yaml

# sleep 60
# kubectl exec -it -n vault vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json> vault/keys.json

ROOT_TOKEN=$(cat vault/keys.txt | grep '^Initial' | rev | cut -d ' ' -f 1 | rev)
UNSEAL_KEY=$(cat vault/keys.txt | grep "Unseal Key 1:" | sed -e "s/Unseal Key 1: //g")
echo "INFO: unseal Vault $UNSEAL_KEY"
KEY_INDEX=0
while [[ $(kubectl exec -it -n vault vault-0 vault status > /dev/null)$? != 0 ]]; do
  sleep 1s
  kubectl exec -it -n vault vault-0 -- vault operator unseal ${UNSEAL_KEY}
done
# doctl kubernetes cluster create bevel
# doctl kubernetes cluster delete bevel
