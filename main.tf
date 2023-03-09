# get the mysql server docker image 
resource "docker_image" "mysql_server" {
  name         = "mysql:8.0-oracle"
  keep_locally = false
}

# get the zabbix java gateway server docker image 
resource "docker_image" "zabbix_java_gateway" {
  name         = "zabbix/zabbix-java-gateway:alpine-6.4-latest"
  keep_locally = false
}

# get the zabbix server mysql docker image 
resource "docker_image" "zabbix_server_mysql" {
  name         = "zabbix/zabbix-server-mysql:alpine-6.4-latest"
  keep_locally = false
}

# get the zabbix web nginx server docker image 
resource "docker_image" "zabbix_web_nginx_mysql" {
  name         = "zabbix/zabbix-web-nginx-mysql:alpine-6.4-latest"
  keep_locally = false
}

resource "docker_network" "private_network" {
  name = "zabbix-net2"
  ipam_config {
    subnet   = "172.30.0.0/16"
    ip_range = "172.30.240.0/20"
  }
}

resource "docker_container" "mysql-server" {
  name  = var.mysql_container_name
  image = docker_image.mysql_server.image_id
  tty   = true
  env = [
    "MYSQL_DATABASE=zabbix",
    "MYSQL_USER=zabbix",
    "MYSQL_PASSWORD=zabbix_pwd",
    "MYSQL_ROOT_PASSWORD=root_pwd"
  ]
  networks_advanced {
    name = docker_network.private_network.name
  }
  restart = "unless-stopped"
  command = ["mysqld", "--character-set-server=utf8", "--collation-server=utf8_bin", "--default-authentication-plugin=mysql_native_password"]

}

resource "docker_container" "zabbix_java_gateway" {
  name  = var.zabbix_java_gw_container_name
  image = docker_image.zabbix_java_gateway.image_id
  networks_advanced {
    name = docker_network.private_network.name
  }
  restart = "unless-stopped"

}

resource "docker_container" "zabbix_server_mysql" {
  name  = var.zabbix_server_mysql_container_name
  image = docker_image.zabbix_server_mysql.image_id
  networks_advanced {
    name = docker_network.private_network.name
  }
  ports {
    internal = 10051
    external = 10051
  }
  env = [
    "DB_SERVER_HOST=mysql-server",
    "MYSQL_DATABASE=zabbix",
    "MYSQL_USER=zabbix",
    "MYSQL_PASSWORD=zabbix_pwd",
    "MYSQL_ROOT_PASSWORD=root_pwd",
    "ZBX_JAVAGATEWAY=zabbix-java-gateway"
  ]
  restart = "unless-stopped"

}

resource "docker_container" "zabbix_web_nginx_mysql" {
  name  = var.zabbix_web_nginx_mysql_container_name
  image = docker_image.zabbix_web_nginx_mysql.image_id
  networks_advanced {
    name = docker_network.private_network.name
  }
  ports {
    internal = 80
    external = 7777
  }
  env = [
    "ZBX_SERVER_HOST=zabbix-server-mysql",
    "DB_SERVER_HOST=mysql-server",
    "MYSQL_DATABASE=zabbix",
    "MYSQL_USER=zabbix",
    "MYSQL_PASSWORD=zabbix_pwd",
    "MYSQL_ROOT_PASSWORD=root_pwd"
  ]
  restart = "unless-stopped"

}




# # start a container and expose the 30110 port
# resource "docker_container" "zabbix" {
#   image = docker_image.zabbix_server.image_id
#   name  = var.zabbix_container_name
#   ports {
#     internal = 80
#     external = var.zabbix_exposed_port
#   }
# }


