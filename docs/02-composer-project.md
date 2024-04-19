# Composer Project

The following repository has been setup based on the [Composer for Drupal Project](https://github.com/drupal-composer/drupal-project) standards:

https://github.com/bcgov/MFIN-Data-Catalogue

  ![MFIN Data Catalogue](assets/images/mfin-data-catalogue.png)

## Continuous Integration

[Docker Scaffold for Drupal WxT](https://github.com/drupalwxt/docker-scaffold) has been integrated into the Composer Project.

* https://github.com/bcgov/MFIN-Data-Catalogue/actions

> **Note**: Currently only a basic site installation is performed (see Next Steps below).

![Docker Scaffold](assets/images/docker-scaffold.png)

## Next Steps

* Use minified database rather then site installation for testing and compliance
* Push built containers into [Artifactory]((https://artifacts.developer.gov.bc.ca/))
* Initiate XRay Scan attaching results to Build
* Bump the application manifests image tag in the [tenant repo](https://github.com/bcgov-c/tenant-gitops-ea352d)
