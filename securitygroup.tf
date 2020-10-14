resource "aws_security_group" "myinstance" {
  vpc_id = aws_vpc.main.id
  name = "myinstance"
  description = "security group for my instance"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
      from_port = 6379
      to_port = 6379
      protocol = "tcp"
      security_groups = [aws_security_group.redis-sg.id]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = [aws_security_group.elb-securitygroup.id]
  }

  tags = {
    Name = "myinstance"
  }
}

resource "aws_security_group" "redis-sg" {
  vpc_id = aws_vpc.main.id
  name = "redis"
  description = "security group for redis"
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.myinstance.id]
  }
  tags = {
    Name = "redis"
  }
}

resource "aws_security_group" "elb-securitygroup" {
  vpc_id = aws_vpc.main.id
  name = "elb"
  description = "security group for load balancer"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 
  tags = {
    Name = "elb"
  }
}
