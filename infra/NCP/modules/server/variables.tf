variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
  sensitive = true
}
variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "servername" {
  type = string
}

variable "init_script_name" {
  type = string
}

variable "init_script_vars" {
  type = map(any)
}

variable "server_product_code" {
  type = string
}

variable "acg_port_range" {
  type = string
}