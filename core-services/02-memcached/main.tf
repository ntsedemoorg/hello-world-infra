resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "memcached-cache"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.4"
  port                 = 11211
}

