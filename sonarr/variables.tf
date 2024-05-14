variable "docker_image" {
  type        = string
  description = "repository image"
  default     =  "lscr.io/linuxserver/sonarr"
}

variable "docker_version" {
  type        = string
  description = "repository image version"
  default     =  "latest"
}

#Docker Container
#network
variable "docker_network" {
  type        = string
  description = "network the container is attached to"
  default     =  "arr-net"
}
#name
variable "resource_name" {
  type        = string
  description = "name of resource"
  default     =  "sonarr"
}
#internal only?
variable "internal_network" {
  type        = bool
  description = "does network NOT have internet access?"
  default     =  false
}
#port
variable "internal_port" {
  type        = number
  description = "internal port number for container"
  default     =  8989
}
#restart options
variable "restart" {
  type        = string
  description = "restart option"
  default     =  "unless-stopped"
}

#Traefik
#hostname
variable "hostname" {
  type        = string
  description = "name of hostname"
  default     =  "sonarr"
}

#Homepage
#description
variable "homepage_description" {
  type        = string
  description = "description of app in homepage"
  default     =  "Series *arr app"
}
#group
variable "homepage_group" {
  type        = string
  description = "group in homepage"
  default     =  "arr"
}