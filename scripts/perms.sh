sudo chmod 0664 /etc/systemd/system/{vault*,consul*}
sudo chmod 0664 /lib/systemd/system/{vault*,consul*}
sudo chmod 0755 /usr/bin/consul-online.sh
sudo systemctl enable vault.service
sudo systemctl enable consul.service

