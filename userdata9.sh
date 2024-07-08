
wget -O splunk-9.0.4.1-419ad9369127-linux-2.6-x86_64.rpm "https://download.splunk.com/products/splunk/releases/9.0.4.1/linux/splunk-9.0.4.1-419ad9369127-linux-2.6-x86_64.rpm"
sudo yum install ./splunk-9.0.2-17e00c557dc1-linux-2.6-x86_64.rpm -y
sudo bash
cd /opt/splunk/bin
./splunk start --accept-license --answer-yes
