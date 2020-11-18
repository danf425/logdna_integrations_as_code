Terraform seems to introduce code-breaking changes (or at least in need of refactoring) every 2 minor versions or so. Therefore, I've included a `.tfswitchrc` file.

Simply run `tfswitch` from either `terraform/cloudwatch` or `terraform/s3`
This code is tied to TF v0.13.5. It might work w/ future and past version, but it has not been tested. 