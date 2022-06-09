variable "project" {}
variable "region" {}
variable "password" {}
variable "cidr-name" {}
variable "cidr" {}
provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_sql_database_instance" "instance" {
  name                    = "cloudmatos-sql-1"
  database_version        = "MYSQL_5_7"
  region                  = "${var.region}"
  settings {
    tier                  = "db-f1-micro"
    ip_configuration {
      ipv4_enabled        = "true"
      authorized_networks {
        name              = "${var.cidr-name}"
        value             = "${var.cidr}"
      }   
    }
  }
  deletion_protection     =  "false"
}

resource "google_sql_database" "database" {
  name     = "test"
  instance = "${google_sql_database_instance.instance.name}"
}

resource "google_sql_user" "users" {
  name     = "root"
  instance = "${google_sql_database_instance.instance.name}"
  host     = "%"
  password = "${var.password}"
}
