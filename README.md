
# Integrate Jenkins with AWS
This is a step by step project on how to integrate Jenkins with AWS.


High level overview of steps involved
- Create VPC (Single Public Subnet)
- Create Security groups 
- Spin up EC2 instance, install and configure Jenkins , create AMI out of EC2
- Create permissions to run jobs on worker nodes in Jenkins
- Test with a test project

## Blog Post

- [Integrate Jenkins with AWS](https://medium.com/@SylvesterYiadom/integrate-jenkins-with-aws-part-i-e51f141b7ec2)

## Technologies
- AWS (VPC, EC2, IAM)
- Jenkins
- Git
- Maven
## Running Tests
We will use the Java spring-petclinic to ran a compile job on the Jenkins worker node

Github repo: https://github.com/spring-projects/spring-petclinic

## Future-to-dos
- Add a build trigger within Jenkins to automatically integrate changes
- Automate the creation of amazon resources using either Terraform, Cloudformation, AWS CDK or Python (Pulumi)
- Automate the installation of Jenkins and its dependencies using User data.
- Create a full CI/CD pipeline job on a worker node.
## Author

- [@SylvesterYiadom](https://www.syiadom.com/)