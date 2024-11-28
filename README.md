# consul-ent-setup

## Prerequisite
1. Consul enterprise license in set in environment variable `CONSUL_LICENSE`.
2. Docker and docker compose running on local system.

## Setup
Follow below steps to setup the Consul Enterprise. The setup is ACL enabled and hence has steps to generate partirion scoped token. For demo purpouse the `billing` partiton is considered.


```sh
# clone the helper repo
$ gh repo clone srahul3/consul-ent-setup && cd consul-ent-setup

# Start consul server agent
$ docker compose up consul-server --detach

# Enter the sever shell
$ docker exec -it consul-server /bin/sh

# Create admin partition 'billing'
$ CONSUL_HTTP_TOKEN=a234daab-bfd1-cbd3-1f83-abf24e094b39 consul partition create --name billing

# Pulling the required configuration
$ cd /tmp && curl -LO https://github.com/srahul3/consul-ent-setup/archive/refs/heads/main.zip && unzip main.zip && cd /tmp/consul-ent-setup-main/configs

# creating access policy for esm instance
$ CONSUL_HTTP_TOKEN=a234daab-bfd1-cbd3-1f83-abf24e094b39 consul acl policy create -name "esm" -rules @policy.hcl -description "esm" -partition "billing"

# Generating the ACL token for ESM and copy the secret-id to be provided in `config.hcl` in ESM configuration as `token`
$ CONSUL_HTTP_TOKEN=a234daab-bfd1-cbd3-1f83-abf24e094b39 ./bin/consul acl token create -partition "billing" -policy-name="esm" -secret="52e7af34-4d54-43bf-8548-4861c39bdd5b"

# Registering the fake service
$ curl --request PUT --data @service.json localhost:8500/v1/catalog/register -H "x-consul-token: a234daab-bfd1-cbd3-1f83-abf24e094b39"

# exit docker
$ exit

# Start consul server agent
$ docker compose up consul-client --detach

```

## Fake service

Clone the repo, compile and run the application using below command
```sh
$ gh repo clone nicholasjackson/fake-service
$ LISTEN_ADDR=0.0.0.0:19090 ./bin/fake-service
```
## Consul ESM
Clone the repo, compile and run the application using below command
```sh
$ gh repo clone hashicorp/consul-ecs
$ go run main.go --config-file=config.hcl
```

Put ESM config in the `config.hcl` file.
```hcl
partition = "billing"
http_addr = "http://localhost:8502"
token = "52e7af34-4d54-43bf-8548-4861c39bdd5b"
```

## Destroy

Run below shell commands:
```sh
$ docker compose down consul-server
$ docker compose down consul-client
```
