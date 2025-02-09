### label the node groups 
kubectl label node <on-demand-node-name> node-type=on-demand
kubectl label node <spot-node-name> node-type=spot

### applying the deployments 

kubectl apply -f hard_affinity_sample_app.yaml
kubectl apply -f soft_affinity_sample_app.yaml

### install and use opensource from UI
### prerequisite : you need to have prometheus 

helm install prometheus --repo https://prometheus-community.github.io/helm-charts prometheus \
  --namespace prometheus-system --create-namespace \
  --set prometheus-pushgateway.enabled=false \
  --set alertmanager.enabled=false \
  -f https://raw.githubusercontent.com/opencost/opencost/develop/kubernetes/prometheus/extraScrapeConfigs.yaml


  helm install opencost --repo https://opencost.github.io/opencost-helm-chart opencost \
  --namespace opencost -f local.yaml

  kubectl port-forward --namespace opencost service/opencost 9003 9090

### use opencost from CLI
### prerequisite : you need to have krew,  https://krew.sigs.k8s.io/docs/user-guide/setup/install/

kubectl krew install cost

alias kcac='kubectl cost --service-port 9003 --service-name opencost --kubecost-namespace opencost --allocation-path /allocation/compute'

kubectl cost --service-port 9003 --service-name opencost --kubecost-namespace opencost --allocation-path /allocation/compute  \
    namespace \
    --historical \
    --window 5d \
    --show-cpu \
    --show-memory \
    --show-pv \
    --show-efficiency=false

### read more about opencost here : https://www.opencost.io/
