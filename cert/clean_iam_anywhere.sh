# Remove all private keys, certificates and CSR
#rm *.key
#rm *.pem
#rm *.csr

# Get profile ID using name
profile_id=$(aws rolesanywhere list-profiles --query 'profiles[?name==`demo-anywhere-profile`].profileId' --output text)
# Get trust anchor ID using name
trust_anchor_id=$(aws rolesanywhere list-trust-anchors --query 'trustAnchors[?name==`demo-trust-anchor`].trustAnchorId' --output text)
# Delete profile
aws rolesanywhere delete-profile --profile-id $profile_id
#detach role policy before deleting role
aws iam detach-role-policy --role-name demo-rolesanywhere --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
# Delete role
aws iam delete-role --role-name demo-rolesanywhere
# Delete trust anchor
aws rolesanywhere delete-trust-anchor --trust-anchor-id $trust_anchor_id