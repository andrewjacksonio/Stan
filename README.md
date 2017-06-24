# Stan

This repository is my submission for devops lab technical assessment.

## Packer

[Packer](https://www.packer.io/) has been used to build the linux AMI web instance for the stack.
- template source: [packer_webserver.json](https://github.com/andrewjacksonio/Stan/blob/master/packer_webserver.json)
```sh
$ packer build -var 'aws_access_key=********' -var 'aws_secret_key=*********' packer_webserver.json
```
## Puppet

[Puppet](https://puppet.com/) has been used to configure the web instance provisioned by Packer.   Packer will install puppet and run puppet apply

## Cloud Formation

Template [cfn_stack.template](https://github.com/andrewjacksonio/Stan/blob/master/cfn_stack.template) can be executed from the AWS console or via [AWSCLI](https://aws.amazon.com/cli/).  All required defaults to get started are included in the template to be run in Oregon region.
