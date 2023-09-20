terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}


provider "ncloud" {
  access_key  = var.access_key
  secret_key  = var.secret_key
  region      = "KR"
  site        = "PUBLIC"
  support_vpc = true
}

data "ncloud_vpc" "main" {
  id = var.vpc_id
}

# LoadBalancer
resource "ncloud_lb" "main" {
  name           = "be-lb-${var.env}"
  network_type   = "PUBLIC"
  type           = "NETWORK_PROXY"
  subnet_no_list = [ncloud_subnet.main.subnet_no]
}

# loadbalancer use subnet
resource "ncloud_subnet" "main" {
  vpc_no         = data.ncloud_vpc.main.id
  subnet         = cidrsubnet(data.ncloud_vpc.main.ipv4_cidr_block, 8, 2)
  zone           = "KR-2"
  network_acl_no = data.ncloud_vpc.main.default_network_acl_no
  subnet_type    = "PRIVATE"
  name           = "subnet-lb-${var.env}"
  usage_type     = "LOADB"
}

resource "ncloud_lb_listener" "main" {
  load_balancer_no = ncloud_lb.main.load_balancer_no
  protocol         = "TCP"
  port             = 80
  target_group_no  = ncloud_lb_target_group.main.target_group_no
}

# target group
resource "ncloud_lb_target_group" "main" {
  name        = "be-tg-${var.env}"
  vpc_no      = data.ncloud_vpc.main.vpc_no
  protocol    = "PROXY_TCP"
  target_type = "VSVR"
  port        = 8000
  description = "for django be"
  health_check {
    protocol       = "TCP"
    http_method    = "GET"
    port           = 8000
    url_path       = "/admin"
    cycle          = 30
    up_threshold   = 2
    down_threshold = 2
  }
  algorithm_type = "RR"
}

# target group attachment
resource "ncloud_lb_target_group_attachment" "main" {
  target_group_no = ncloud_lb_target_group.main.target_group_no
  target_no_list  = [var.be_instance_no]
}
