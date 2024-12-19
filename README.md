# KIETWIFI

A bash script that automates the process of logging into KIET's college and hostel wifi. It securely stores credentials and can be configured to run automatically at system startup.

## Features

- One-time credential setup and secure storage
- Automatic login on system startup
- Proper error handling and exit codes

## Prerequisites

- bash shell
- curl
- wget
- systemd (optional, for service installation)

## Installation

1. Download the script:
```bash
sudo wget -O /usr/local/bin/wifi_login.sh https://raw.githubusercontent.com/VanshSahay/kietwifi/main/wifi_login.sh
```

2. Make the script executable:
```bash
sudo chmod +x /usr/local/bin/wifi_login.sh
```

## Configuration

On first run, the script will prompt for:
- Username
- Password

These credentials are stored securely in `~/.wifi_credentials` with restricted permissions (600).

## Usage

### Manual Execution
```bash
/usr/local/bin/wifi_login.sh
```

### Automatic Startup

1. Create a systemd service file:
```bash
sudo nano /etc/systemd/system/wifi-login.service
```

2. Add the following content:
```ini
[Unit]
Description=Automatic WiFi Login Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/wifi_login.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

3. Enable and start the service:
```bash
sudo systemctl enable wifi-login.service
sudo systemctl start wifi-login.service
```

## Logs

Login attempts are logged to `/var/log/wifi_login.log` with timestamps.

To view logs:
```bash
tail -f /var/log/wifi_login.log
```

## Troubleshooting

1. **Login Failures**
   - Check if credentials are correct
   - Verify network connectivity
   - Review logs in `/var/log/wifi_login.log`

2. **Script Not Running at Startup**
   - Check systemd service status:
     ```bash
     sudo systemctl status wifi-login.service
     ```

3. **Credential Reset**
   - Delete the credentials file and run the script again:
     ```bash
     rm ~/.wifi_credentials
     /usr/local/bin/wifi_login.sh
     ```

## Contributing

Feel free to submit issues and enhancement requests!
