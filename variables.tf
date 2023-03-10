variable "mysql_container_name" {
  type        = string
  description = "name of the container"
  default     = "mysql-server"
}

variable "zabbix_java_gw_container_name" {
  type        = string
  description = "name of the container"
  default     = "zabbix-java-gateway"
}

variable "zabbix_server_mysql_container_name" {
  type        = string
  description = "name of the container"
  default     = "zabbix-server-mysql"
}

variable "zabbix_web_nginx_mysql_container_name" {
  type        = string
  description = "name of the container"
  default     = "zabbix-web-nginx-mysql"
}


# variable "zabbix_exposed_port" {
#   type        = number
#   description = "exposed port of the Zabbix container"
#   default     = 30110
# }
