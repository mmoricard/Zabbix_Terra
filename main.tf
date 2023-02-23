# get the nginx docker image
resource "docker_image" "nginx_latest" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_image" "nginx" {
  name         = "nginxdemos/hello:latest"
  keep_locally = false
}

# start a container and expose the 30100 port
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = var.nginx_container_name
  ports {
    internal = 80
    external = var.nginx_exposed_port
  }
}

resource "docker_container" "nginx_latest" {
  image = docker_image.nginx_latest.image_id
  name  = var.nginx_container_name2
  ports {
    internal = 80
    external = 30102
  }
}
