# gcp-custom-network-terraform

A terraform boilerplate for creating a 3-tier web app architecture using a custom network. This includes a VM in public subnet exposed to internet and a private subnet instance only accessible to the instance in public subnet.


The high-level overview diagram:



## Prerequisites

1.   A `gcp` bucket to store the remote state
2.   A specific `gitlab-runner` to run the jobs specified in the `.gitlab-ci.yml` *

* or you can use a `shared` gitlab-runner but do the configurations accordingly. For this you need the `Google` credentials file for the specific gcp project with relavent permissions.

For setting up a `specific` gitlab runner follow this [these] steps in my other repository.

[these]: https://gitlab.com/iamdempa/k8s-gcp-cicd

## Two Branches - Two backend configurations

This repository has two branches namely `no-backend` and `with-backend` for configuring the `terraform` backend block for `gcp` as per your requirements.

| Branch | Use Case | 
|-----------------|:-------------|
| 1. **no-backend** | Congire the `terraform` backend through `Gitlab` CI/CD variable/s  | 
| 2. **with-backend**     |  Configure the backend with Google Cloud Platform account credentials in JSON format     | 


For the 2nd scenario, you need to create a Variable to store the `credentials` file and here I have set the variable name as `GCE_TOKEN` - (Settings -> CI/CD -> Variables)

And also **replace** the `bucket` and `prefix` values with yours.

```
terraform init -backend-config="bucket=<your-bucket-name>" \
               -backend-config="prefix=<prefix>" \
               -backend-config="credentials=$GCE_TOKEN"
```
