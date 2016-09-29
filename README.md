# Docker for shadowsocks-libev

### Run docker

You should run the container in the command below:

```bash
docker run -d -v yourconfig.json:/etc/shadowsocks.json -p 8388:8388 --name shadowsocks playniuniu/shadowsocks
```

### Configuration

Remeber to replace your password 

```json
{
    "server": "0.0.0.0",
    "server_port": 8388,
    "local_port": 1080,
    "password": "YOUR PASSWORD",
    "timeout": 300,
    "method": "aes-256-cfb"
}
```
