locals {
  prefix = "ce9-chrisy-coach17"
}

resource "aws_ecr_repository" "ecr" {
  name         = "${local.prefix}-ecr"
  force_delete = true
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.9.0"

  cluster_name = "${local.prefix}-ecs"
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    ce9-chrisy-coach17-ecspush = { #task definition and service name -> #Change
      cpu    = 512
      memory = 1024
      container_definitions = {
        ce9-chrisy-coach17-container = { #container name -> Change
          essential = true
          image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.prefix}-ecr:latest"
          port_mappings = [
            {
              containerPort = 8080
              protocol      = "tcp"
            }
          ]
        }
      }
      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                         = [aws_subnet.chrisy-public_a.id, aws_subnet.chrisy-public_b.id] # Subnet IDs
      security_group_ids                 = [aws_security_group.ecs_tasks.id]                              #  Security Group ID
      task_execution_role                = aws_iam_role.ecs_task_execution_role.arn                       # added  task execution role.
    }
  }
}