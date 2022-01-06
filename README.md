
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

- [https://medium.com/@SylvesterYiadom](https://medium.com/@SylvesterYiadom/integrate-jenkins-with-aws-part-i-e51f141b7ec2)

1. Login to AWS console and go to the VPC console
-  Launch a VPC using the default settings
- Change VPC name to Jenkins-VPC (or any name of your choice)
- Change public subnet name to Jenkins-Public-subnet (or any name of your choice)
- Create VPC

2. Create a SG to allow SSH and connectivity to the jenkins server on port 8080
- Go to the Ec2 console and select security groups from the left menu option
- Click on create security groups, give it a name and select the VPC created in step 1
- Add two inbound rules with the following configuration

    SSH -> 22 Source (My IP ie your home IP)
    Custom TCP -> 8080 Source (My IP ie your home IP) 

3. Next steps will be to create an Ec2 instance for the Jenkins master server in the VPC we created in the previous step 1
- Go to the ec2 console
- Click on launch instance
- Select Amazon Linux 2 AMI (HVM) Free-tier option with type t2 micro
- Click next to configure instance details
- For Network, select the VPC created in step 1
- For Subnet select the public subnet created in step 1
- Enable Auto-assign Public IP
- Leave the rest as default and click next 
- Leave the default Root block storage
- Next, select an existing security group and select the security group we created from step 2
- Next review and launch
- Create an RSA Keypair , download and store it . We will use that to SSH unto the Ec2 server to install Jenkins
- Launch instance , wait for it to launch and we will SSH unto it.



## Installation

Install Jenkins unto the EC2 instance following the steps below

- Open an SSH client.
- Locate your private key file. The key used to launch this instance is jenkins-key-pair.pem
- Run this command, if necessary, to ensure your key is not publicly viewable.
 chmod 400 <key_name>.pem

```bash
  ssh -i "<key_name>.pem" ec2-user@EC2-INSTANCE-IP

```
Run the following commands to update instance repository and install Jenkins
```bash
sudo yum update -y

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    
sudo yum install -y java-1.8.0-openjdk-devel 
    
sudo amazon-linux-extras install epel -y # repository that provides 'daemonize'
    
sudo yum install jenkins -y
    
sudo systemctl start jenkins

systemctl status jenkins #check if jenkins is running
```

Open your browser and using the Public IPv4 DNS on port 8080, connect to the Jenkins server

    Eg: ec2-YOUR-EC2-IP.REGION.compute.amazonaws.com:8080
- Back on your Jenkins server ssh session


Use the following command to access the password for jenkins and complete the Installation
    
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Install suggested plugging and set up admin user credentials
- Click Finish and Start Using Jenkins










## Technologies
- AWS (VPC, EC2, IAM)
- Jenkins
