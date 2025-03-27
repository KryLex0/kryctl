ENDPOINT_URL="https://oos.eu-west-2.outscale.com"

# Liste tous les profils disponibles dans ~/.aws/credentials
echo "Profils disponibles :"
grep -oP '^\[\K[^\]]+' ~/.aws/credentials | sed 's/^/\t- /'