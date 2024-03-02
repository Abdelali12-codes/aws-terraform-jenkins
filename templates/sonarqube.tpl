#!/bin/bash 

sudo apt update

#### install java ###


sudo apt install -y wget apt-transport-https
mkdir -p /etc/apt/keyrings

wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc

echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

apt update
apt install temurin-17-jdk -y
update-alternatives --config java
/usr/bin/java --version


#### install sonarqube #####

# Append limits.conf configurations
echo 'sonarqube   -   nofile   65536' | sudo tee -a /etc/security/limits.conf
echo 'sonarqube   -   nproc    4096' | sudo tee -a /etc/security/limits.conf

# Append sysctl.conf configuration
echo 'vm.max_map_count = 262144' | sudo tee -a /etc/sysctl.conf
sudo sysctl --system

sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
sudo apt install unzip -y
sudo unzip sonarqube-9.9.0.65466.zip -d /opt
sudo mv /opt/sonarqube-9.9.0.65466 /opt/sonarqube
sudo groupadd sonar
sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube -R


sonar_properties_content=$(cat <<EOF
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.jdbc.username=${db_username}
sonar.jdbc.password=${db_password}
sonar.jdbc.url=jdbc:postgresql://${db_host}/sonarqube
EOF
)

# Append the content to sonar.properties
echo "$sonar_properties_content" | sudo tee /opt/sonarqube/conf/sonar.properties > /dev/null




# Define the content to be added to sonar.service
sonar_service_content=$(cat <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF
)

# Append the content to sonar.service
echo "$sonar_service_content" | sudo tee /etc/systemd/system/sonar.service > /dev/null

# Reload systemd to apply changes
sudo systemctl daemon-reload

# Start and enable the SonarQube service
sudo systemctl start sonar
sudo systemctl enable sonar


