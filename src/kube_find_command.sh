#k get clusters.management.cattle.io -n fleet-default c-m-chzpn7mr -o yaml
echo "Script to find a specific string in all CRDs of the current cluster"

FILTER_STRING=""

# check if argument is supplied
if [ $# -eq 0 ]; then
  # Ask the filter string
  read -p "Enter the filter string: " FILTER_STRING
  echo "Filter string: $FILTER_STRING"
fi

# Lst all crd
CRDS=$(kubectl get crd -o jsonpath='{.items[*].metadata.name}')

for CRD in $CRDS; do
  echo "CRD: $CRD"
  ## name of the tag to search "OscK8sNodeName"
  kubectl get $CRD -A -o yaml | grep -i "$FILTER_STRING"
  
  ## name of the ressource "machines.cluster.x-k8s.io"
  # kubectl get $CRD -A -o yaml | grep "sample-cluster1-pool-master-7478dc8dfbxkzf6c-bp2r5"
done

## ressources containing tag "name" from outscale:
# - outscalemachines.rke-machine.cattle.io
# - machines.cluster.x-k8s.io