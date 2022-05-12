# Setup Build Server

## prerequisites

- Arch Linux based (Preffered `tos`)
- TOS repositry linked with pacman
- openjdk8
- sshd
- bash

### Tos repository
In case you are not using TOS then add the following to `/etc/pacman.conf`

> NOTE: All build servers need to depend on the testing version of the repo

```
[tos]
Server = https://testing.odex.be
```


## On the server itself 
1. Export signing gpg key from existing infra
```bash
gpg --export-secret-keys sign@odex.be > private.key
```
2. Copy over the `private.key` file to the new remote agent
3. Import signing gpg key to new remote agent
```bash
gpg --import private.key
```
4. Modify the `gpg-agent` to cache passwords for longer (So the kernel signing won't fail)
```bash
vim .gnupg/gpg-agent.conf
# The content of the file:
default-cache-ttl 34560000
max-cache-ttl 34560000
```
5. Add environment variables to `~/.profile`
```bash
export GPG_PASS="our_super_secret_password"
# new gpg repo key (after may)
export GPG_EMAIL="sign@odex.be"
export GPG_REPO_KEY="DA6A53ED6DAAEA42EFD324D93A772EB5222FCEBC"

```
6. Allow sudo without password
```bash
sudoedit /etc/sudoers
# And add the following:
# <the_build_username> ALL=(ALL:ALL) NOPASSWD: ALL
# e.g.
# build ALL=(ALL:ALL) NOPASSWD: ALL
```
7. Add ssh key to `~/.ssh/authorized_keys`
```txt
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHsv3hB3mo+PcRcYpPk6jy6MBg3Zf6Gbc0Apmonq6USVkcZfpYSXCVnJ00vwmN6fyQhpltoN4Sj8tSU2LZt3r346IwN9Zs0Ms+wVzQ6aUu6uQRpGWNSnLMQ79SzzrhVdV+Yfu2R2Ibqd52hkZJA9p5vdpGvS0BjSUlQlmjtjTp3oIHHn5Mye0bBzBg7Af5LFfuHl2kEbeGDUqwwEVw/dnXAChAodVxQmPHGXWqAgL+Nz9rV9bfUr75nTapV0vbXuE2pXarKQNwX0AQJU1Y0vZDoe7yofRpfSRuzxKQnWr7va3IF4FqCgigC3qRioR5BWAgs6n4XSdBA8i7YmuG5hvLfyGG0gORiecdlT3druCODHUwBVgBL2TPKjeYH2J6QaLrMfq5/rSnqh1nJAMLrfz5DiPD24qkU7wjiiICnU2c5lYqZqugutTokBWNE7+XErMwaBPSkVr52MNY6PoezXFbdQQZZSS7VnN1+szCldOp4K8oSClYbXvj2SIbL/NR3Dk= zeus@tos
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/dj3IbFULx8DElfycHYwtlWL9SUWADkqfHWLQXqbqyRbVb8LmmtEB/uBIGlwaC5mV0+7kfpot//3wFBA/mn4k4NdsCe3CmG1nLTgkOr2KIh+m62Y1IlYEeGDAPFyu+LcVAFLVGYYR6nZcPI5SwKMNNJR6aQbAgc7vcN2pJnhEwiKTzIg/FXnPzXT3HwgbhmT6ks6rA3OQAWUdGGwYnBzHCD0se/GlI7N/yuvdFGGbTMLVqpIJiotKn6A3PkrcYpB532kaGWGMG6wIVAlps1A1HRF7bvFpiEPmwRzz2ZUajGsGPxHrqwjpulAmJlvgtAnXWni+H4Tc4fQsLdO55Gjp51LOrf5C+jLRClCevOjlOyoCz50PehKcTTd+f8oTfoDyAoKOjKJui9Ab/zDrx8qsz+YmAXffadNEc9HefM9yO3/q+y1fnJYgDXOQv7bBBlJN/8qRwHm/Vf36Gxb57HE49Hl+ne24yq9qp4Re8SjqdcP8x7UMGe0in77pHLeZJK8= zeus@core
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAXbI/ZrobxdV6iFTBvQeXqAIklFuP1Owwt7HVdCFFA9 tom@odex.be
```

and then fix the permissions of the authorized_keys
```bash
chmod 600 ~/.ssh/authorized_keys
```

## In Jenkins
1. Navigate to https://jenkins.odex.be -> manage -> manage nodes & clouds
2. Click on new node -> give a new name -> permanent agent
3. Set number of executors to `1`
4. Set labels to `archlinux`
5. Set launch method to `SSH`
6. Set the host to the ip or DNS name of the remote agent
7. Credentials -> Create a new username & ssh private key pair and select it here
8. Save

