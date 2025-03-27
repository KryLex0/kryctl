# ENDPOINT_URL="https://oos.eu-west-2.outscale.com"
DEFAULT_ENDPOINT_URL="oos.eu-west-2.outscale.com"

# inspect_args
AWS_CREDENTIALS=${args["--credentials-path"]}
ENDPOINT_URL=${args["--endpoint"]}
PROFILE=${args["--profile"]}

if [ -z "$AWS_CREDENTIALS" ]; then
  echo "AWS_CREDENTIALS not set, using default location $HOME/.aws/credentials"
  AWS_CREDENTIALS="$HOME/.aws/credentials"
else
  # verify it exists
  if [ ! -f "$AWS_CREDENTIALS" ]; then
    echo "Error: AWS_CREDENTIALS file not found at $AWS_CREDENTIALS"
    exit 1
  else
    echo "Using AWS_CREDENTIALS file at $AWS_CREDENTIALS"
  fi
fi

if [ -z "$ENDPOINT_URL" ]; then
  echo "ENDPOINT_URL not set, using default $DEFAULT_ENDPOINT_URL"
fi

# Vérifie que le profil existe dans $AWS_CREDENTIALS
if ! grep -q "^\[$PROFILE\]" $AWS_CREDENTIALS; then
  echo "Erreur : Le profil '$PROFILE' n'existe pas dans $AWS_CREDENTIALS."
  kryctl s3 profiles
  exit 1
fi

# Récupère les clés depuis $AWS_CREDENTIALS
ACCESS_KEY_ID=$(awk -v profile="[$PROFILE]" '$0 == profile {getline; print $3}' $AWS_CREDENTIALS)
SECRET_ACCESS_KEY=$(awk -v profile="[$PROFILE]" '$0 == profile {getline; getline; print $3}' $AWS_CREDENTIALS)

# Vérifie si les clés ont été trouvés
if [ -z "$ACCESS_KEY_ID" ] || [ -z "$SECRET_ACCESS_KEY" ]; then
  echo "Erreur : Impossible de trouver les clés pour le profil '$PROFILE'."
  exit 1
fi

echo "AK/SK found for profile '$PROFILE' :"
echo "  ACCESS_KEY_ID=$ACCESS_KEY_ID"
echo "  SECRET_ACCESS_ID=$SECRET_ACCESS_KEY"
echo "  ENDPOINT_URL=$ENDPOINT_URL"

echo "Do you want to continue? [y/N]"
read -r response
VALID_RESPONSES=("y" "Y" "o" "O")

if [[ ! " ${VALID_RESPONSES[@]} " =~ " ${response} " ]]; then
  echo "Aborting."
  exit 0
fi

# Lance le conteneur Docker avec les clés et l'endpoint récupérés
docker run --rm -d --name s3-manager-ui -p 8080:8080 \
  -e "ACCESS_KEY_ID=$ACCESS_KEY_ID" \
  -e "SECRET_ACCESS_KEY=$SECRET_ACCESS_KEY" \
  -e "ENDPOINT=$ENDPOINT_URL" \
  cloudlena/s3manager

echo "Docker container started in detached mode."
echo "You can access the UI at http://localhost:8080"

exit 0
