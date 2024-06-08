resource "aws_ecs_cluster" "node_cluster" {
  name = "node_cluster"
}

resource "aws_ecs_task_definition" "test_node" {
  family                   = "node"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "node",
    "image": "627562689753.dkr.ecr.eu-north-1.amazonaws.com/node:v1",
    "cpu": 1024,
    "memory": 2048,
    "essential": true
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 8080
      }
    ]
  }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "node_service" {
  name            = "node_service"
  cluster         = aws_ecs_cluster.node_cluster.id
  task_definition = aws_ecs_task_definition.test_node.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets          = [aws_subnet.main_subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
  }
 
  load_balancer {
    target_group_arn = aws_lb_target_group.alb-example.arn
    container_name   = "node"
    container_port   = 80
  }

}