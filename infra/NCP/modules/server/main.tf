terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

provider "ncloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = "KR"
  site = "PUBLIC"
  support_vpc = true
}

resource "ncloud_login_key" "loginkey" {
    key_name = "lion-${var.servername}-key-${var.env}"
}

# data "ncloud_subnet" "main"{
#   id = var.subnet_id
# }
resource "ncloud_server" "server" {
    #subnet_no                 = data.ncloud_subnet.main.id
    subnet_no                 = var.subnet_id
    name                      = "${var.servername}-server-${var.env}"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
    server_product_code = var.server_product_code
    login_key_name            = ncloud_login_key.loginkey.key_name
    init_script_no = ncloud_init_script.init.init_script_no
    
    network_interface {
      network_interface_no = ncloud_network_interface.main.id
      order = 0
    }
  }

resource "ncloud_init_script" "init" {   
  name = "set-${var.servername}-tf-${var.env}"
  content = templatefile(
    "${path.module}/${var.init_script_name}",
    var.init_script_vars
    )
}

data "ncloud_vpc" "main"{
  id = var.vpc_id
}

resource "ncloud_access_control_group" "main" {  
  name = "${var.servername}-acg-${var.env}"
  //vpc_no      = data.ncloud_vpc.main.vpc_no
  vpc_no = var.vpc_id
}

resource "ncloud_access_control_group_rule" "main" {
  access_control_group_no = ncloud_access_control_group.main.id

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = var.acg_port_range
    description = "accept ${var.acg_port_range}port ${var.servername}"
  }
}

resource "ncloud_network_interface" "main" {
    name                  = "${var.servername}-nic-${var.env}"
    subnet_no             = var.subnet_id
    access_control_groups = [
      data.ncloud_vpc.main.default_access_control_group_no, #default acg setting
      ncloud_access_control_group.main.id,
    ]
}