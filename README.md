
# Integrate Jenkins with AWS

This projects will walk you through steps in setting up a jenkins master/slave server to create a CI/CD Pipeline



## Author

- [@SylvesterYiadom](https://www.syiadom.com/)

High level overview of steps involved
-  Create VPC (Single Public Subnet)
-  Create Security groups
-  Spin up EC2 and install and configure Jenkins , create AMI out of EC2
-  Create a user with ec2 permissions spin up ec2 instances to run jenkins jobs

## Blog Post

- [Integrate AWS with Jenkins](https://medium.com/@SylvesterYiadom/integrate-jenkins-with-aws-part-i-e51f141b7ec2)



## Technologies
- AWS (VPC, EC2, IAM)
- Jenkins
- Git
- Maven

## Running Tests
We will use the Java spring-petclinic to ran a test job on our Jenkins worker node

Github repo: https://github.com/spring-projects/spring-petclinic