provider "aws" {
  region = "us-west-2"
}

# master
resource "aws_instance" "my_instance_master" {
  ami           = "ami-0aff18ec83b712f05"
  instance_type = "t3.small"
  tags = {
    "Name" = "tfk8s-master-node"
  }
  key_name        = "kube-server"
  security_groups = ["launch-wizard-5"]
  root_block_device {
    volume_size = 10
  }
}

# resource "aws_ebs_volume" "my_instance_master_vol" {
#   availability_zone = "us-west-2a"
#   size              = 10 # Size in GiB

#   tags = {
#     Name = "k8s-master-vol"
#   }
# }

# resource "aws_volume_attachment" "my_instance_master_attachment" {
#   device_name = "/dev/sda1"
#   volume_id   = aws_ebs_volume.my_instance_master_vol.id
#   instance_id = aws_instance.my_instance_master.id
# }

# worker
resource "aws_instance" "my_instance_worker" {
  ami           = "ami-0aff18ec83b712f05"
  instance_type = "t3.small"
  # instance_type = "t3.micro"
  tags = {
    "Name" = "tfk8s-worker-node"
  }
  key_name        = "kube-server"
  security_groups = ["launch-wizard-6"]
  root_block_device {
    volume_size = 10
  }
}

# resource "aws_ebs_volume" "my_instance_worker_vol" {
#   availability_zone = "us-west-2a"
#   size              = 10 # Size in GiB

#   tags = {
#     Name = "k8s-master-vol"
#   }
# }

# resource "aws_volume_attachment" "my_instance_worker_attachment" {
#   device_name = "/dev/sda1"
#   volume_id   = aws_ebs_volume.my_instance_worker_vol.id
#   instance_id = aws_instance.my_instance_worker.id
# }