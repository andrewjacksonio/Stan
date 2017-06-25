# Stan

This repository is my submission for devops lab technical assessment.

## Jenkins

[Jenkins](https://jenkins.io/) was employed as the C.I. tool of choice to automate the build pipeline.  You can access the builds via http://jenkins.andrewjackson.io/ with the credentials supplied via email.  The builds functions are:
  - Validate Puppet manifest syntax and style guidelines - triggered by GitHub checkin
  - Validate Packer template syntax and configuration - triggered by successful Puppet validation
  - Validate CloudFormation template syntax - triggered by successful Packer validation
  - Build AWS AMI - base web server instance for the load balanced stack - triggered by successful Packer build
  - Deploy Stack - Runs CloudFormation template and build stack if stack does not exist - Triggered manually if all above builds are successful

A number of Tools and plugins were used for the pipeline, they were:

| Tool/Plugin | Link |
| ------ | ------ |
| Jenkins CI | https://jenkins.io/ |
| Jenkins GitHub | https://wiki.jenkins.io/display/JENKINS/GitHub+Plugin |
| Jenkins Warnings | https://wiki.jenkins-ci.org/display/JENKINS/Warnings+Plugin |
| Jenkins Copy Artifact | https://wiki.jenkins-ci.org/display/JENKINS/Copy+Artifact+Plugin |
| Jenkins Credentials | https://wiki.jenkins-ci.org/display/JENKINS/Credentials+Plugin |
| Packer | https://www.packer.io/ |
| Puppet Agent | https://puppet.com/ |
| Puppet-Lint | http://puppet-lint.com/ |
| AWS CLI | https://aws.amazon.com/cli/ |

## Packer

[Packer](https://www.packer.io/) has been used to build the linux AMI web instance for the stack.
- template source: [packer_webserver.json](https://github.com/andrewjacksonio/Stan/blob/master/packer_webserver.json)
```sh
$ packer build -var aws_access_key=$AWSKey -var aws_secret_key=$AWSSecret -var aws_keypair_name=StanKey -var aws_keypair_filepath=$KeyFile packer_webserver.json
```
## Puppet

[Puppet](https://puppet.com/) has been used to configure the web instance provisioned by Packer.   Packer will install puppet and run puppet apply

## Cloud Formation

Template [cfn_stack.template](https://github.com/andrewjacksonio/Stan/blob/master/cfn_stack.template) can be executed from the AWS console or via [AWSCLI](https://aws.amazon.com/cli/).  All required defaults to get started are included in the template to be run in Oregon region.
```sh
$ aws cloudformation create-stack --stack-name StanStack1 --template-body file://cfn_stack.template --parameters ParameterKey=ImageId,ParameterValue=ami-********
```