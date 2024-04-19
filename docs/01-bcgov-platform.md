# BCGOV Platform
This documentation package illustrates the steps taken to host a Drupal app on the BC Gov Openshift environment. The sample application throughout is the Finance Data Catalogue which is built on the BC Base Build (bcbb). See [bcbb-related repositories](https://github.com/bcgov/?q=bcbb)

![OpenShift Console](assets/images/openshift-console.png)

## Login to Silver Cluster

Proceed to the OpenShift console:

https://console.apps.silver.devops.gov.bc.ca/dashboards

You may be greeted by the **OpenShift 4 Platform OAuth - Login to Silver Cluster** screen; from there click "Developer Log In" which takes you to the **Pathfinder Single Sign-On** (SSO) screen.

![SSO Screen](assets/images/bcgov_sso.png)

Select "Azure AD OIDC" and authenticate with your first.last@gov.bc.ca email address and using Microsoft Authenticator.

Once you are logged into the OpenShift console you can select "Copy login command" under your profile name.

```sh
oc login --token=<token> --server=https://api.silver.devops.gov.bc.ca:6443
```
