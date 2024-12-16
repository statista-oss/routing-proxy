# Statista Proxy

> route between your legacy and your new application using different strategies

## Configuration

set the following environment variables for this container:
    
```bash
STRATEGY=PERCENTAGE | COOKIE
OLD_DOMAIN=old.statista.com
COOKIE_STRATEGY_NAME=my_app_routing=new
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

> this cookie needs to be present in our [cookie consent](https://forms.office.com/pages/responsepage.aspx?id=OfiFB67f4U-gaID-j8YfK0gVGkEOyf1NiUPPYqdVPa5UNFFUUVNPSEZNMDVSOExKNDE0NksxQURSMi4u&route=shorturl) 

### PERCENTAGE_OLD
how much traffic should be routed to the old application

### PERCENTAGE_NEW
how much traffic should be routed to the new application


## Local Testing

build the image

```bash
docker build -t statista-proxy .
```

### Percentage based routing
run the container

```bash
docker run -p80:80 -e STRATEGY=PERCENTAGE -e OLD_DOMAIN=haproxy.com:443 -e NEW_DOMAIN=apache.org:443 -e PERCENTAGE_NEW=50 -e PERCENTAGE_OLD=50 -e COOKIE_PERCENTAGE_NAME=my_app statista_proxy
```

run requests (since its round robin every request should be flipped)

```bash
curl -I localhost:80
```

> notice the `set-cookie` header which should contain `my_app=new_domain` or `my_app=old_domain`
further requests made by the same client will stick to this server

### Cookie based routing

```bash
docker run -p80:80 -e STRATEGY=COOKIE -e OLD_DOMAIN=haproxy.com:443 -e NEW_DOMAIN=apache.org:443 -e COOKIE_STRATEGY_NAME="my_app_routing=new" statista_proxy
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