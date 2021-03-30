# [default] Oregon resources
provider "aws" {
    region = "us-west-2"
}

# HK resources
provider "aws" {
    region = "ap-east-1"
    alias = "hk"
}

# algo
resource aws_instance "algo" {
    # instance_id = "i-05d3da7fc45b12af4"

    instance_type = "t2.micro"

    ami = "ami-02c45ea799467b51b"
    tags = {
        "Environment" = "Algo"
        "Name" = "algo"
    }
    user_data = <<EOT
#cloud-config
output: {all: '| tee -a /var/log/cloud-init-output.log'}

package_update: true
package_upgrade: true

packages:
 - sudo

users:
  - default
  - name: algo
    homedir: /home/algo
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: adm,netdev
    shell: /bin/bash
    lock_passwd: true
    ssh_authorized_keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL0MlWJvBOBMfyE2AWzRa4gSHD4B80mJnNTFd7ZmGJBjGVww0FvY6167A0REC+rBjC7uifWLBjMQ3b4b5rKN5O0iNP5bmzywiLZdqYBvgawTBDCEjkWRc37hWna0uX/xCHwIuP+pNkoCXivPf5DoDxlCRHVcPeVayXIVWhhMNHmP9dRMmsmGv4aVF6Qy4IdrHN+v8altmYNQhL4/nuVIN/VCVYEp0cJABkvWAZKdqjXgEAAprcWjIPD/4CwRtMqJ6MSeIYsvFy6S3rR7Tzv0gOv6NZR5xRyi8YD+23mLOAYcb9hIpXa3SOHoCr4z8VL07HCLxwcNlt0z9Y2t/tJ/hf"

write_files:
  - path: /etc/ssh/sshd_config
    content: |
      Port 4160
      AllowGroups algo
      PermitRootLogin no
      PasswordAuthentication no
      ChallengeResponseAuthentication no
      UsePAM yes
      X11Forwarding yes
      PrintMotd no
      AcceptEnv LANG LC_*
      Subsystem	sftp	/usr/lib/openssh/sftp-server


runcmd:
  - set -x
  - sudo apt-get remove -y --purge sshguard || true
  - systemctl restart sshd.service
EOT
}

resource aws_instance "charm_dot_io" {
    # instance_id = "i-0dc76eb4d9c9055be"

    instance_type = "t3a.nano"

    ami = "ami-0d1cd67c26f5fca19"
}

resource aws_instance "binance-bot" {
    ami = "ami-036915aa0cb1d91a1"

    instance_type = "t3.micro"

    ebs_optimized = true

    provider = aws.hk
}