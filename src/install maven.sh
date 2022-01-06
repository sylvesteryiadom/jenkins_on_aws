# download maven repo
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo

# add repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo

# install maven
sudo yum install -y apache-maven
#check maven version
mvn --version