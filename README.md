## AWS infraestructure with VPC, Loadbalancer and EC2 for a application with front and back ends in the same space.

- [Install Terraform CLI](https://developer.hashicorp.com/terraform/install)
- [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- You can associente your credentials with `export AWS_ACCESS_KEY_ID=` and `export AWS_SECRET_ACCESS_KEY=`
- The AWS Key is set to be the file `aws-key.pub` in the project's root folder
- Change the `user_data.sh` to your project's preferences and remember to keep your secrets safe.


### Useful links:

- [Provider AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Modules](https://registry.terraform.io/browse/modules)
- [Resource aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
- [Resource aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
