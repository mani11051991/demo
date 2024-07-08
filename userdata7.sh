#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y wget tar

# Create Prometheus user
              sudo useradd --no-create-home --shell /bin/false prometheus
              sudo mkdir /etc/prometheus
              sudo mkdir /var/lib/prometheus
              sudo chown prometheus:prometheus /etc/prometheus
              sudo chown prometheus:prometheus /var/lib/prometheus

              # Download and install Prometheus
              wget https://github.com/prometheus/prometheus/releases/download/v2.30.3/prometheus-2.30.3.linux-amd64.tar.gz
              tar -xvf prometheus-2.30.3.linux-amd64.tar.gz
              cd prometheus-2.30.3.linux-amd64
              sudo cp prometheus /usr/local/bin/
              sudo cp promtool /usr/local/bin/
              sudo cp -r consoles /etc/prometheus
              sudo cp -r console_libraries /etc/prometheus
              sudo cp prometheus.yml /etc/prometheus
              sudo chown -R prometheus:prometheus /etc/prometheus
              sudo chown prometheus:prometheus /usr/local/bin/prometheus
              sudo chown prometheus:prometheus /usr/local/bin/promtool

              # Create Prometheus systemd service
              echo "[Unit]
              Description=Prometheus
              Wants=network-online.target
              After=network-online.target

              [Service]
              User=prometheus
              Group=prometheus
              Type=simple
              ExecStart=/usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus/ --web.console.templates=/etc/prometheus/consoles --web.console.libraries=/etc/prometheus/console_libraries

              [Install]
              WantedBy=multi-user.target" | sudo tee /etc/systemd/system/prometheus.service

              sudo systemctl daemon-reload
              sudo systemctl start prometheus
              sudo systemctl enable prometheus
