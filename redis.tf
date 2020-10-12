resource "aws_elasticache_subnet_group" "redis-sg" {
  name       = "redis-cache-subnet"
  subnet_ids = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id, aws_subnet.main-public-3.id]
}

resource "aws_elasticache_replication_group" "redis-rg" {
  replication_group_id          = var.cluster_id
  replication_group_description = "Redis cluster for DevOps Test"
  engine_version                = "5.0.5"
  node_type                     = "cache.t2.micro"
  port                          = 6379
  automatic_failover_enabled    = true
  subnet_group_name             = aws_elasticache_subnet_group.redis-sg.name
  security_group_ids            = [aws_security_group.redis-sg.id]

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 2
  }
}
