#steps to follow to SSH unto EC3 instance
chmod 400 jk_key.pem
ssh -i "jk_key.pem" ec2-user@18.223.14.39
#update repos
sudo yum update -y