# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }



# # IAM Role for EC2
# resource "aws_iam_role" "ec2_role" {
#   name = "${var.project_name}-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# # Attach AmazonSSMManagedInstanceCore to the EC2 role
# resource "aws_iam_role_policy_attachment" "ssm_core" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }


# # IAM Policy for ECR access
# resource "aws_iam_role_policy" "ecr_policy" {
#   name = "${var.project_name}-ecr-policy"
#   role = aws_iam_role.ec2_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "ecr:GetAuthorizationToken",
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# # Instance profile for EC2
# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#   name = "${var.project_name}-instance-profile"
#   role = aws_iam_role.ec2_role.name
# }

# resource "aws_instance" "application_server" {
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = var.instance_type
#   key_name               = var.key_name
#   ebs_optimized          = true
#   monitoring             = true
#   vpc_security_group_ids = [aws_security_group.app_sg.id]
#   iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

#   metadata_options {
#     http_tokens   = "required"
#     http_endpoint = "enabled"
#   }

#   root_block_device {
#     encrypted = true
#   }


#   user_data = <<-EOF
# #!/bin/bash
# set -xe

# # Update package index
# apt-get update -y

# # Update packages and install dependencies
# apt-get update -y
# apt-get install -y unzip curl jq docker.io

# # Install AWS CLI v2
# echo "Installing AWS CLI v2..."
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip -q awscliv2.zip
# sudo ./aws/install

# # Install prerequisite packages
# apt-get install -y ca-certificates curl gnupg lsb-release

# # Add Docker’s official GPG key
# mkdir -p /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# # Set up the Docker repository
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
#   https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# # Update and install Docker
# apt-get update -y
# apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# # Enable and start Docker
# systemctl enable docker
# systemctl start docker

# # (Optional) Add ubuntu user to the docker group so you can use Docker without sudo
# usermod -aG docker ubuntu

# # Verify installation
# docker --version

#   EOF



#   tags = {
#     Name = "${var.project_name}-instance"
#   }
# }

# resource "aws_security_group" "app_sg" {
#   name        = "${var.project_name}-sg"
#   description = "Allow SSH and HTTP inbound traffic"

#   ingress {
#     description = "SSH from my IP"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.my_ip]
#   }

#   ingress {
#     description = "HTTP from anywhere"
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     name = "${var.project_name}-sg"
#   }
# }


# resource "aws_ssm_parameter" "instance_id" {
#   name  = "/nodejs-app/instance-id"
#   type  = "String"
#   value = aws_instance.application_server.id
# }

