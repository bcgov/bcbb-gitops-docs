# BCGOV Platform

![OpenShift Console](assets/images/openshift-console.png)

## Login to Silver Cluster

Proceed to the OpenShift console:

https://console.apps.silver.devops.gov.bc.ca/dashboards

You will likely be greeted by the Pathfinder SSO

Select "Azure AD OIDC" and authenticate with your first.last@gov.bc.ca email address and using Microsoft Authenticator.

Once you are logged into the OpenShift console you can select "Copy login command" under your profile name.

```sh
oc login --token=<token> --server=https://api.silver.devops.gov.bc.ca:6443
```
