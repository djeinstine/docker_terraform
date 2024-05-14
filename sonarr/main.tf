#image
resource "docker_image" "sonarr" {
  name         = "${var.docker_image}:${var.docker_version}"
  keep_locally = true
}

#container
resource "docker_container" "sonarr" {
  depends_on=[null_resource.manage_directories]

  image = docker_image.sonarr.name
  name  = var.resource_name
  restart = var.restart
  network_mode = "bridge"
  env=[
    "PUID=${local.synology_userid}",
    "PGID=${local.synology_groupid}",
    "TZ=${local.timezone}"
  ]

  networks_advanced {
    name = var.docker_network
  }

  #config at /dockerpath/sonarr
  volumes {
    read_only = false
    container_path  = "/config"
    host_path = "${local.docker_path}/${var.resource_name}"
  }
  volumes {
    read_only = false
    container_path  = "/Media"
    host_path = "/volume1/Media"
  }
}

#manually create config directory
resource "null_resource" "manage_directories"{
  triggers = {
    docker_path     = local.docker_path
    resource_name   = var.resource_name
  }

  #create folder
  provisioner "local-exec" {
    when    = create
    command = "mkdir -p ${self.triggers.docker_path}/${self.triggers.resource_name}"
  }
}

#create traefik file config at /path/to/traefik/dynamic_config/sonarr.yml
resource "local_file" "traefik_config" {
  directory_permission = "0700"
  file_permission = "0600"
  filename  = "${local.traefik_root}/${var.resource_name}.yml"
  content  = templatefile("basic_traefik_service.tftpl", 
              { service = resource.docker_container.sonarr.name,
              docker_url = resource.docker_container.sonarr.name,
              hostname = var.hostname, 
              domain_name = local.domain_name,
              web_port = var.internal_port})
}

#create homepage service
resource "local_file" "homepage_config" {
  filename  = "${local.homepage_root}/${var.resource_name}.${var.homepage_group}"
  content  = templatefile("homepage_service.tftpl", 
              { service_name = title(resource.docker_container.sonarr.name), 
              service_icon = "sonarr.png", 
              service_url = "https://${var.hostname}.${local.domain_name}",
              service_descripton = var.homepage_description})
}