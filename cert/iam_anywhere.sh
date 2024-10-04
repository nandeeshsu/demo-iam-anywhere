# Extract content  of CA certificate
cert_value=`cat MyAWSCA.pem`

# Create anywhere trust anchor using CA certificate
trust_anchor_arn=$(aws rolesanywhere create-trust-anchor --enabled --name demo-trust-anchor --source "sourceData={x509CertificateData=$cert_value},sourceType=CERTIFICATE_BUNDLE" --query 'trustAnchor.trustAnchorArn' --output text)

echo $trust_anchor_arn

# Create IAM role which will be assumed
role_arn=$(aws iam create-role --role-name demo-rolesanywhere --assume-role-policy-document file://iam_anywhere_role_trust_policy.json --query 'Role.Arn' --output text)
echo $role_arn

role_policy=$(aws iam attach-role-policy --role-name demo-rolesanywhere --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess)

# Create roles anywhere profile linking trust anchor to role
profile_arn=$(aws rolesanywhere create-profile --enabled --name demo-anywhere-profile --role-arns "$role_arn" --query 'profile.profileArn' --output text)
echo $profile_arn

# Sleep to allow above changes to propogate
echo "Sleeping for 20 seconds"
sleep 20

# Generate credentials
credentials=$(./aws_signing_helper credential-process \
    --certificate onpremise.pem \
    --private-key onpremise.key \
    --trust-anchor-arn $trust_anchor_arn \
    --profile-arn $profile_arn \
    --role-arn $role_arn)
access_key_id=$(echo $credentials | jq -r ".AccessKeyId")
secret_access_key=$(echo $credentials | jq -r ".SecretAccessKey")
session_token=$(echo $credentials | jq -r ".SessionToken")
# Verify credentials
AWS_ACCESS_KEY_ID=$access_key_id AWS_SECRET_ACCESS_KEY=$secret_access_key AWS_SESSION_TOKEN=$session_token aws sts get-caller-identity
