 #!/bin/bash
              sudo yum update -y
              sudo yum install -y software-properties-common
              wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
              sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
              sudo yum update -y
              sudo yum install -y grafana
              sudo systemctl start grafana-server
              sudo systemctl enable grafana-server
