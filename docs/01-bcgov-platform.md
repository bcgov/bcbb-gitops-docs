# BCGOV Platform
This documentation package illustrates the steps taken to host a Drupal app on the BC Gov Openshift environment. The sample application referred to throughout this documentation is the [Finance Data Catalogue](https://www.github.com/bcgov/MFIN-Data_Catalogue) which is built using the BC Base Build (bcbb). See [bcbb-related repositories](https://github.com/bcgov/?q=bcbb). The Openshift Silver cluster host namespace is `ea352d` for the Finance Data Catalogue.

![OpenShift Console](assets/images/openshift-console.png)

## Login to Silver Cluster

Proceed to the OpenShift console:

https://console.apps.silver.devops.gov.bc.ca/dashboards

You may be greeted by the **OpenShift 4 Platform OAuth - Login to Silver Cluster** screen; from there click "Developer Log In" which takes you to the **Pathfinder Single Sign-On** (SSO) screen.

![SSO Screen](assets/images/bcgov_sso.png)

Select "IDIR - MFA" and authenticate with your BC Government email address and Microsoft Authenticator code, if prompted.

Once you are logged into the OpenShift console you can select "Copy login command" under your profile name.

```sh
oc login --token=<token> --server=https://api.silver.devops.gov.bc.ca:6443
```
