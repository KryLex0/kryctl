ENDPOINT_URL=${args["--endpoint"]}
PROFILE=${args["--profile"]}
DEFAULT_ENDPOINT_URL="https://oos.eu-west-2.outscale.com"

# Check if the endpoint URL is set, if not, use the default
if [ -z "$ENDPOINT_URL" ]; then
  echo "ENDPOINT_URL not set, using default $DEFAULT_ENDPOINT_URL"
  ENDPOINT_URL="$DEFAULT_ENDPOINT_URL"
fi



#aws s3 sync s3://hdh-prod-logs-probants --profile hdh-preprod --endpoint $ENDPOINT_URL ./