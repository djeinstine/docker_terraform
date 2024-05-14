# Declaring the Required provider (Docker provider)
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
  backend "pg" {
    conn_str = "postgres://username:password@terraform_backend.hosename.com/terraform_backend?sslmode=disable"
    schema_name = "sonarr"
  }
}
# Specifying the Docker provider configuration
provider "docker" {}