#1. define vpc
resource "aws_vpc" "main" {
 cidr_block           = "10.0.0.0/16"
 enable_dns_hostnames = true
 tags = {
   name = "main"
 }
}
#2. define subnets
resource "aws_subnet" "subnet" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1a"
 tags = {
    Name = "main-subnet-a"
  }
}

resource "aws_subnet" "subnet2" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1b"
 tags = {
    Name = "main-subnet-b"
  }
}

#3. define internet gatway
resource "aws_internet_gateway" "internet_gateway" {
 vpc_id = aws_vpc.main.id
 tags = {
   Name = "internet_gateway"
 }
}

#4. Create a Route table and associate the same with subnets
resource "aws_route_table" "route_table" {
 vpc_id = aws_vpc.main.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.internet_gateway.id
 }
}

resource "aws_route_table_association" "subnet_route" {
 subnet_id      = aws_subnet.subnet.id
 route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet2_route" {
 subnet_id      = aws_subnet.subnet2.id
 route_table_id = aws_route_table.route_table.id
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
}

# 5. Create a security group along with ingress and egress rules obs. not the best pratice
resource "aws_security_group" "security_group" {
 name   = "ecs-security-group"
 vpc_id = aws_vpc.main.id

 ingress {
   from_port   = 0
   to_port     = 0
   protocol    = -1
   self        = "false"
   cidr_blocks = ["0.0.0.0/0"]
   description = "any"
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds_postgres" {
  identifier            = "full-plate-db"
  engine                = "postgres"
  engine_version        = "13"
  instance_class        = "db.t4g.micro"
  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = "gp2"
  publicly_accessible   = false
  db_name               = "database1"
  username              = "postgres"
  password              = "postgres123"
  parameter_group_name  = "default.postgres13"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true
}

locals {
  db_hostname = aws_db_instance.rds_postgres.endpoint
}

resource "aws_security_group_rule" "allow_ecs_to_rds" {
count = length([
    for rule in aws_security_group.rds_sg.ingress : rule
    if rule.from_port == 5432 && rule.to_port == 5432 && rule.protocol == "tcp"
  ]) == 0 ? 1 : 0

  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.security_group.id
}

#8. Configure Application Load Balancer (ALB)
resource "aws_lb" "ecs_alb" {
 name               = "ecs-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.security_group.id]
 subnets            = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
 tags = {
   Name = "ecs-alb"
 }
}

resource "aws_lb_listener" "ecs_alb_listener" {
 load_balancer_arn = aws_lb.ecs_alb.arn
 port              = 80
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.ecs_tg.arn
 }
}

resource "aws_lb_target_group" "ecs_tg" {
 name        = "ecs-target-group"
 port        = 80
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.main.id

 health_check {
   path = "/"
 }
}

resource "aws_lb_target_group" "ecs_tg_4000" {
  name        = "ecs-target-group-4000"
  port        = 4000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path = "/health"
  }
}

# 9. setup cluster
resource "aws_ecs_cluster" "ecs_cluster" {
 name = "full_plate_cluster_tf"
}

#11. Task definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
 family                   = "full-plate-task-tf"
 network_mode             = "awsvpc"
 requires_compatibilities = ["FARGATE"]
 execution_role_arn       = "arn:aws:iam::471112543448:role/ecsTaskExecutionRole"
 task_role_arn            = "arn:aws:iam::471112543448:role/ecsTaskExecutionRole" 
 cpu                      = 512
 memory                   = 1024

 runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }
 
 container_definitions = jsonencode([
   {
     name      = "dockergs"
     image     = "471112543448.dkr.ecr.us-east-1.amazonaws.com/full_plate_tf_repository:latest"
     cpu       = 256
     memory    = 512
     essential = true
     logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/full-plate-task-tf"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
     portMappings = [
       {
         containerPort = 80
         hostPort      = 80
         protocol      = "tcp"
       },
       {
        containerPort = 4000
        hostPort      = 4000
        protocol      = "tcp"
       }
     ]
      environment = [
        { name = "DATABASE_URL", value = "ecto://postgres:postgres123@${local.db_hostname}:5432/database1" },
        { name = "SECRET_KEY_BASE", value = "TtvK69c6zV0DNWeia63fpeIO7rjRrjPc7mOLLjXKPOVhqAiIby/+GKcvcaKC6g62" }
      ]
   }
 ])
  depends_on = [aws_db_instance.rds_postgres]
}

#12. create ecs service
resource "aws_ecs_service" "ecs_service" {
 name            = "full-plate-service-tf"
 cluster         = aws_ecs_cluster.ecs_cluster.id
 task_definition = aws_ecs_task_definition.ecs_task_definition.arn
 desired_count   = 2
 launch_type     = "FARGATE" 

 network_configuration {
   subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
   security_groups = [aws_security_group.security_group.id]
   assign_public_ip = true
 }

 load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "dockergs"
    container_port   = 80
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg_4000.arn 
    container_name   = "dockergs"
    container_port   = 4000
  }

 depends_on = [aws_db_instance.rds_postgres]

 force_new_deployment = true

 load_balancer {
   target_group_arn = aws_lb_target_group.ecs_tg.arn
   container_name   = "dockergs"
   container_port   = 80
 }

 load_balancer {
  target_group_arn = aws_lb_target_group.ecs_tg_4000.arn
  container_name   = "dockergs"
  container_port   = 4000
}
}

resource "aws_lb_listener" "ecs_alb_listener_4000" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 4000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg_4000.arn
  }
}

output "rds_endpoint" {
  value = aws_db_instance.rds_postgres.endpoint
  description = "Endpoint do banco de dados RDS"
}
