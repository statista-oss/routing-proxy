# Routing Proxy

uses HAPROXY under the hood.

> route between your legacy and your new application using different strategies

## Configuration

set the following environment variables for this container:
    
```bash
STRATEGY=PERCENTAGE | COOKIE
OLD_DOMAIN=old.domain.com:443
NEW_DOMAIN=new.domain.com:443
COOKIE_STRATEGY_NAME="my_app_routing=new"
COOKIE_PERCENTAGE_NAME=my_app_sticky_name
PERCENTAGE_OLD=70
PERCENTAGE_NEW=30 
```

### STRATEGY

- `PERCENTAGE` will route the traffic based on the percentage of the old and new application
- `COOKIE` will route the traffic based on a present cookie value (`COOKIE_STRATEGY_NAME`)

### OLD_DOMAIN
the domain of the old application

### NEW_DOMAIN
the domain of the new application

### COOKIE_STRATEGY_NAME
this cookie will taken into account when a forced routing to the new application is wanted

### COOKIE_PERCENTAGE_NAME
this is the name of the cookie for implementing the sticky session

### PERCENTAGE_OLD
how much traffic should be routed to the old application

### PERCENTAGE_NEW
how much traffic should be routed to the new application

### SERVER_COUNT (optional, default=5)
as we are using DNS Resolver we try to create a server for each IP address we get back from the DNS query. 
This is the maximum amount of servers we will create. 


## Local Testing

build the image

```bash
docker build -t statista-proxy .
```

### Percentage based routing
run the container

```bash
docker run -p80:80 -e STRATEGY=PERCENTAGE -e OLD_DOMAIN=haproxy.com:443 -e NEW_DOMAIN=apache.org:443 -e PERCENTAGE_NEW=50 -e PERCENTAGE_OLD=50 -e COOKIE_PERCENTAGE_NAME=my_app statista-proxy
```

run requests (since its round robin every request should be flipped)

```bash
curl -I localhost:80
```

> notice the `set-cookie` header which should contain `my_app=new_domain` or `my_app=old_domain`
further requests made by the same client will stick to this server

### Cookie based routing

```bash
docker run -p80:80 -e STRATEGY=COOKIE -e OLD_DOMAIN=haproxy.com:443 -e NEW_DOMAIN=apache.org:443 -e COOKIE_STRATEGY_NAME="my_app_routing=new" statista-proxy
```

run requests (since its round robin every request should be flipped)

```bash
curl -I localhost:80
```
> should be the old application


```bash
curl -I --cookie "my_app_routing=new" localhost:80
```
> should be the new application


## Usage

### Docker-Compose

```yaml
  routing-proxy:
    image: ghcr.io/statista-oss/routing-proxy:latest
    environment:
      STRATEGY: PERCENTAGE
      OLD_DOMAIN: haproxy.com:443
      NEW_DOMAIN: apache.org:443
      COOKIE_PERCENTAGE_NAME: my_app
      PERCENTAGE_OLD: 50
      PERCENTAGE_NEW: 50
    ports:
      - 80:80
```

currently only HTTP (as it mostly will run behind an SSL loadbalancer anyways) is supported.

### ECS Fargate

when defining this image in your `Task-Definition`, make sure you add those `systemControls`:

```js
{
  systemControls: [
    {
      namespace: 'net.ipv4.ip_unprivileged_port_start',
      value: '0',
    }
  ]
}
```

## TODOS

- [ ] add SSL support
- [ ] logging support?
- [ ] route based on specific users/user-groups (cookie lookups)