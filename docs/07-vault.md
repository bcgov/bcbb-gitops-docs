# Vault

https://docs.developer.gov.bc.ca/vault-getting-started-guide/#log-in-to-vault-ui

ea352d-nonprod
ea352d-prod

```sh
export LICENSE_PLATE=ea352d
export VAULT_NAMESPACE=platform-services
export VAULT_ADDR=https://vault.developer.gov.bc.ca
vault login -method=oidc role=ea352d
```

```sh
Complete the login via your OIDC provider. Launching browser to:

    https://loginproxy.gov.bc.ca/auth/realms/platform-services/protocol/openid-connect/auth

Waiting for OIDC authentication to complete...
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  <token>
token_accessor         <token>
token_duration         768h
token_renewable        true
token_policies         ["default" "ea352d"]
identity_policies      []
policies               ["default" "ea352d"]
token_meta_email       william.hearn@gov.bc.ca
token_meta_role        ea352d
token_meta_username    william.hearn@gov.bc.ca
```

```sh
vault kv put $LICENSE_PLATE-nonprod/dev/drupal drupal-password=XXXXX openid-connect-client-secret=XXXXX openid-connect-client-id=XXXXX gcnotify-test-apikey=XXXXX gcnotify-team-apikey=XXXXX gcnotify-test-template=XXXXX
vault kv put $LICENSE_PLATE-nonprod/dev/mysql mysql-root-password=XXXXX mysql-password=XXXXX
vault kv put $LICENSE_PLATE-nonprod/dev/solr solr-password=XXXXX
```
