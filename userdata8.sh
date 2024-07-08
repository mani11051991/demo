 #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y software-properties-common
              wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
              sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
              sudo apt-get update -y
              sudo apt-get install -y grafana
              sudo systemctl start grafana-server
              sudo systemctl enable grafana-server
