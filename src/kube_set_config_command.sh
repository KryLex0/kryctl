# list all kubeconfig starting by config_ files in ~/.kube/ and print them if exist
kubeconfigs=($(ls ~/.kube/config_* 2>/dev/null))

if [ ${#kubeconfigs[@]} -eq 0 ]; then
    echo "No kubeconfig found"
else
    echo "Available kubeconfig:"
    # print all kubeconfig like "X. name"
    for i in ${!kubeconfigs[@]}; do
        echo "$i. ${kubeconfigs[$i]}"
    done
fi

echo "Enter the kubeconfig number you want to use"
read kubeconfig_number
cp ${kubeconfigs[$kubeconfig_number]} ~/.kube/config