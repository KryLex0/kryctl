# list all kube context and allow user to change context
kubectl config get-contexts
echo "Enter the context you want to use"
read context
kubectl config use-context $context