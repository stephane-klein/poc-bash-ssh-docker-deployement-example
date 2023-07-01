# POC deployment based on ssh and bash

Root issue: https://github.com/stephane-klein/backlog/issues/250

Prerequisites:

- https://asdf-vm.com/

Initialize *asdf*:

```sh
$ asdf plugin add scaleway-cli
$ asdf plugin-add jq https://github.com/AZMCode/asdf-jq.git
$ asdf install
```

```sh
$ cp .secret.skel .secret
```

Update `.secret` and `.envrc` with your personnal access key, secret key…

Load variable env:

```sh
$ direnv allow
```

## Part 1: deploy the server

You can use this command to choose the type of server to install, depending on your financial constraints and resource requirements:

```
$ scw instance server-type list
NAME              HOURLY PRICE  LOCAL VOLUME MAX SIZE  CPU  GPU  RAM      ARCH    AVAILABILITY
DEV1-S            € 0.014       20 GB                  2    0    2.0 GiB  x86_64  available
DEV1-M            € 0.026       40 GB                  3    0    4.0 GiB  x86_64  available
DEV1-L            € 0.05        80 GB                  4    0    8.0 GiB  x86_64  available
DEV1-XL           € 0.073       120 GB                 4    0    12 GiB   x86_64  available
ENT1-XXS          € 0.073       0 B                    2    0    8.0 GiB  x86_64  available
ENT1-XS           € 0.147       0 B                    4    0    16 GiB   x86_64  available
ENT1-S            € 0.29        0 B                    8    0    32 GiB   x86_64  available
ENT1-M            € 0.59        0 B                    16   0    64 GiB   x86_64  available
ENT1-L            € 1.18        0 B                    32   0    128 GiB  x86_64  available
ENT1-XL           € 2.35        0 B                    64   0    256 GiB  x86_64  available
ENT1-2XL          € 3.53        0 B                    96   0    384 GiB  x86_64  out of stock
GP1-VIZ           € 0.10        300 GB                 8    0    32 GiB   x86_64  available
GP1-XS            € 0.102       150 GB                 4    0    16 GiB   x86_64  available
GP1-S             € 0.204       300 GB                 8    0    32 GiB   x86_64  available
GP1-M             € 0.406       600 GB                 16   0    64 GiB   x86_64  available
GP1-L             € 0.789       600 GB                 32   0    128 GiB  x86_64  available
GP1-XL            € 1.671       600 GB                 48   0    256 GiB  x86_64  available
PLAY2-PICO        € 0.014       0 B                    1    0    2.0 GiB  x86_64  available
PLAY2-NANO        € 0.027       0 B                    2    0    4.0 GiB  x86_64  available
PLAY2-MICRO       € 0.054       0 B                    4    0    8.0 GiB  x86_64  available
POP2-HC-2C-4G     € 0.053       0 B                    2    0    4.0 GiB  x86_64  available
POP2-2C-8G        € 0.073       0 B                    2    0    8.0 GiB  x86_64  available
POP2-HM-2C-16G    € 0.103       0 B                    2    0    16 GiB   x86_64  available
POP2-HC-4C-8G     € 0.106       0 B                    4    0    8.0 GiB  x86_64  available
POP2-4C-16G       € 0.147       0 B                    4    0    16 GiB   x86_64  available
POP2-HM-4C-32G    € 0.206       0 B                    4    0    32 GiB   x86_64  available
POP2-HC-8C-16G    € 0.213       0 B                    8    0    16 GiB   x86_64  available
POP2-8C-32G       € 0.29        0 B                    8    0    32 GiB   x86_64  available
POP2-HM-8C-64G    € 0.412       0 B                    8    0    64 GiB   x86_64  available
POP2-HC-16C-32G   € 0.426       0 B                    16   0    32 GiB   x86_64  available
POP2-16C-64G      € 0.59        0 B                    16   0    64 GiB   x86_64  available
POP2-HM-16C-128G  € 0.824       0 B                    16   0    128 GiB  x86_64  available
POP2-HC-32C-64G   € 0.851       0 B                    32   0    64 GiB   x86_64  available
POP2-32C-128G     € 1.18        0 B                    32   0    128 GiB  x86_64  available
POP2-HM-32C-256G  € 1.648       0 B                    32   0    256 GiB  x86_64  available
POP2-HC-64C-128G  € 1.702       0 B                    64   0    128 GiB  x86_64  available
POP2-64C-256G     € 2.35        0 B                    64   0    256 GiB  x86_64  available
POP2-HM-64C-512G  € 3.296       0 B                    64   0    512 GiB  x86_64  available
PRO2-XXS          € 0.055       0 B                    2    0    8.0 GiB  x86_64  available
PRO2-XS           € 0.11        0 B                    4    0    16 GiB   x86_64  available
PRO2-S            € 0.219       0 B                    8    0    32 GiB   x86_64  available
PRO2-M            € 0.438       0 B                    16   0    64 GiB   x86_64  available
PRO2-L            € 0.877       0 B                    32   0    128 GiB  x86_64  available
RENDER-S          € 1.243       400 GB                 10   1    42 GiB   x86_64  available
STARDUST1-S       € 0.005       10 GB                  1    0    1.0 GiB  x86_64  out of stock
```

```sh
$ terraform init
```

```sh
$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # scaleway_instance_ip.server1_public_ip will be created
  + resource "scaleway_instance_ip" "server1_public_ip" {
      + address         = (known after apply)
      + id              = (known after apply)
      + organization_id = (known after apply)
      + project_id      = (known after apply)
      + reverse         = (known after apply)
      + server_id       = (known after apply)
      + zone            = (known after apply)
    }

  # scaleway_instance_server.server1 will be created
  + resource "scaleway_instance_server" "server1" {
      + boot_type                        = "local"
      + bootscript_id                    = (known after apply)
      + cloud_init                       = (known after apply)
      + enable_dynamic_ip                = false
      + enable_ipv6                      = false
      + id                               = (known after apply)
      + image                            = "ubuntu_jammy"
      + ip_id                            = (known after apply)
      + ipv6_address                     = (known after apply)
      + ipv6_gateway                     = (known after apply)
      + ipv6_prefix_length               = (known after apply)
      + name                             = (known after apply)
      + organization_id                  = (known after apply)
      + placement_group_policy_respected = (known after apply)
      + private_ip                       = (known after apply)
      + project_id                       = (known after apply)
      + public_ip                        = (known after apply)
      + security_group_id                = (known after apply)
      + state                            = "started"
      + type                             = "DEV1-S"
      + user_data                        = (known after apply)
      + zone                             = (known after apply)

      + root_volume {
          + boot                  = false
          + delete_on_termination = true
          + name                  = (known after apply)
          + size_in_gb            = 10
          + volume_id             = (known after apply)
          + volume_type           = (known after apply)
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

```sh
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # scaleway_account_ssh_key.stephane-klein-public-ssh-key will be created
  + resource "scaleway_account_ssh_key" "stephane-klein-public-ssh-key" {
      + created_at      = (known after apply)
      + disabled        = false
      + fingerprint     = (known after apply)
      + id              = (known after apply)
      + name            = "stephane-klein-public-ssh-key"
      + organization_id = (known after apply)
      + project_id      = (known after apply)
      + public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEzyNFlEuHIlewK0B8B0uAc9Q3JKjzi7myUMhvtB3JmA2BqHfVHyGimuAajSkaemjvIlWZ3IFddf0UibjOfmQH57/faxcNEino+6uPRjs0pFH8sNKWAaPX1qYqOFhB3m+om0hZDeQCyZ1x1R6m+B0VJHWQ3pxFaxQvL/K+454AmIWB0b87MMHHX0UzUja5D6sHYscHo57rzJI1fc66+AFz4fcRd/z+sUsDlLSIOWfVNuzXuGpKYuG+VW9moiMTUo8gTE9Nam6V2uFwv2w3NaOs/2KL+PpbY662v+iIB2Yyl4EP1JgczShOoZkLatnw823nD1muC8tYODxVq7Xf7pM/NSCf3GPCXtxoOEqxprLapIet0uBSB4oNZhC9h7K/1MEaBGbU+E2J5/5hURYDmYXy6KZWqrK/OEf4raGqx1bsaWcONOfIVXbj3zXTUobsqSkyCkkR3hJbf39JZ8/6ONAJS/3O+wFZknFJYmaRPuaWiLZxRj5/gw01vkNVMrogOIkQtzNDB6fh2q27ghSRkAkM8EVqkW21WkpB7y16Vzva4KSZgQcFcyxUTqG414fP+/V38aCopGpqB6XjnvyRorPHXjm2ViVWbjxmBSQ9aK0+2MeKA9WmHN0QoBMVRPrN6NBa3z20z1kMQ/qlRXiDFOEkuW4C1n2KTVNd6IOGE8AufQ== contact@stephane-klein.info"
      + updated_at      = (known after apply)
    }

  # scaleway_instance_ip.server1_public_ip will be created
  + resource "scaleway_instance_ip" "server1_public_ip" {
      + address         = (known after apply)
      + id              = (known after apply)
      + organization_id = (known after apply)
      + project_id      = (known after apply)
      + reverse         = (known after apply)
      + server_id       = (known after apply)
      + zone            = (known after apply)
    }

  # scaleway_instance_server.server1 will be created
  + resource "scaleway_instance_server" "server1" {
      + boot_type                        = "local"
      + bootscript_id                    = (known after apply)
      + cloud_init                       = (known after apply)
      + enable_dynamic_ip                = false
      + enable_ipv6                      = false
      + id                               = (known after apply)
      + image                            = "ubuntu_jammy"
      + ip_id                            = (known after apply)
      + ipv6_address                     = (known after apply)
      + ipv6_gateway                     = (known after apply)
      + ipv6_prefix_length               = (known after apply)
      + name                             = (known after apply)
      + organization_id                  = (known after apply)
      + placement_group_policy_respected = (known after apply)
      + private_ip                       = (known after apply)
      + project_id                       = (known after apply)
      + public_ip                        = (known after apply)
      + security_group_id                = (known after apply)
      + state                            = "started"
      + type                             = "DEV1-S"
      + user_data                        = (known after apply)
      + zone                             = (known after apply)

      + root_volume {
          + boot                  = false
          + delete_on_termination = true
          + name                  = (known after apply)
          + size_in_gb            = 10
          + volume_id             = (known after apply)
          + volume_type           = (known after apply)
        }
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

scaleway_account_ssh_key.stephane-klein-public-ssh-key: Creating...
scaleway_instance_ip.server1_public_ip: Creating...
scaleway_account_ssh_key.stephane-klein-public-ssh-key: Creation complete after 0s [id=9f74bc84-5b4d-4769-a3f0-eb83304aaf57]
scaleway_instance_ip.server1_public_ip: Creation complete after 1s [id=fr-par-1/3b9b6220-798c-4907-8c24-e71bee80c94f]
scaleway_instance_server.server1: Creating...
scaleway_instance_server.server1: Still creating... [10s elapsed]
scaleway_instance_server.server1: Still creating... [20s elapsed]
scaleway_instance_server.server1: Creation complete after 24s [id=fr-par-1/b17673c5-2b8c-4f36-8d4d-a6bbd933b4c6]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

```
$ scw instance server list
ID                                    NAME                   TYPE    STATE    ZONE      PUBLIC IP     PRIVATE IP   TAGS  IMAGE NAME
b17673c5-2b8c-4f36-8d4d-a6bbd933b4c6  tf-srv-frosty-dewdney  DEV1-S  running  fr-par-1  51.15.192.91  10.68.40.41  []    Ubuntu 22.04 Jammy Jellyfish
```

Fetch public ip:

```
$ scw instance server list name=server1 -o json | jq -r ".[0].public_ip.address"
```

or:

```sh
$ direnv reload
$ echo $SERVER1_IP
51.158.119.141
```

Add server fingerprint to you `known_hosts`:

```
$ ssh -o "StrictHostKeyChecking no" root@$SERVER1_IP
# exit
```

```
$ ./scripts/install.sh
```

## Part 2: deploy Miniflux application

...

## Part 3: destroy the server

```sh
$ terraform destroy
```
