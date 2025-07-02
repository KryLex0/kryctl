#k get clusters.management.cattle.io -n fleet-default c-m-chzpn7mr -o yaml
echo "Script to find a specific string in all CRDs of the current cluster"

KUBECONFIG_PATH=${args["--kubeconfig"]}
KUBECONFIG=""
FILTER_STRING=""

# check if argument is supplied
if [ $# -eq 0 ]; then
  # Ask the filter string
  read -p "Enter the filter string: " FILTER_STRING
  echo "Filter string: $FILTER_STRING"
fi

if [ ! -f "$KUBECONFIG_PATH" ]; then
  # If the kubeconfig file does not exist, exit with an error
  echo "Error: Kubeconfig file not found at $KUBECONFIG_PATH"
  exit 1
fi

if [ -n "$KUBECONFIG_PATH" ]; then
  echo "Using kubeconfig file: $KUBECONFIG_PATH"
  KUBECONFIG="--kubeconfig $KUBECONFIG_PATH"
else
  echo "Using default kubeconfig file"
  KUBECONFIG="--kubeconfig $HOME/.kube/config"
fi

# List all crd
CRDS=$(kubectl $KUBECONFIG get crd -o jsonpath='{.items[*].metadata.name}')

for CRD in $CRDS; do
  echo "CRD: $CRD"
  ## name of the tag to search "OscK8sNodeName"
  kubectl $KUBECONFIG get $CRD -A -o yaml | grep -i "$FILTER_STRING"
  
  ## name of the ressource "machines.cluster.x-k8s.io"
  # kubectl get $CRD -A -o yaml | grep "sample-cluster1-pool-master-7478dc8dfbxkzf6c-bp2r5"
done

## ressources containing tag "name" from outscale:
# - outscalemachines.rke-machine.cattle.io
# - machines.cluster.x-k8s.io