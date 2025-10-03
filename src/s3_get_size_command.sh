# ENDPOINT_URL="https://oos.eu-west-2.outscale.com"
DEFAULT_ENDPOINT_URL="oos.eu-west-2.outscale.com"

# inspect_args
PROFILE=${args["--profile"]}
BUCKET=${args["--bucket"]}
AWS_CREDENTIALS="$HOME/.aws/credentials"
AWS_CONFIG="$HOME/.aws/config"
ENDPOINT_URL=$(awk -v profile="[$PROFILE]" '$0 == profile {getline; getline; getline; print $3}' $AWS_CONFIG)

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
echo "  Bucket=$BUCKET"

echo "Do you want to continue? [y/N]"
read -r response
VALID_RESPONSES=("y" "Y" "yes" "YES" "Yes" "o" "O" "oui" "OUI" "Oui")

if [[ ! " ${VALID_RESPONSES[@]} " =~ " ${response} " ]]; then
  echo "Aborting."
  exit 0
fi

# Check if bucket exists and is accessible
if ! aws s3 ls s3://$BUCKET --profile $PROFILE --endpoint-url $ENDPOINT_URL > /dev/null 2>&1; then
  echo "Error: The bucket '$BUCKET' does not exist or is not accessible."
  echo "List of available buckets:"
  yes | kryctl s3 ls --profile $PROFILE
  exit 1
fi

BUCKET_SIZE=$(aws s3api list-objects --bucket $BUCKET \
  --endpoint-url $ENDPOINT_URL \
  --output json --query "sum(Contents[].Size)" \
  --profile $PROFILE)

# Print the bucket size in multiple human-readable formats (Bytes, MB, GB, TB) dynamically
echo "Bucket size:"
echo "  - $BUCKET_SIZE Bytes"

MB=$(bc <<< "scale=2; $BUCKET_SIZE/1024/1024")
GB=$(bc <<< "scale=2; $BUCKET_SIZE/1024/1024/1024")
TB=$(bc <<< "scale=2; $BUCKET_SIZE/1024/1024/1024/1024")

# Display MB if >= 0.01
if (( $(bc <<< "$MB >= 0.01") )); then
  echo "  - $MB MB"
fi

# Display GB if >= 0.01
if (( $(bc <<< "$GB >= 0.01") )); then
  echo "  - $GB GB"
fi

# Display TB if >= 0.01
if (( $(bc <<< "$TB >= 0.01") )); then
  echo "  - $TB TB"
fi

exit 0
