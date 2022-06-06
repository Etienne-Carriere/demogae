resource "google_sql_database_instance" "main" {
  name             = "flixbee"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}



resource "google_sql_database" "referential" {
  name     = "referential"
  instance = google_sql_database_instance.main.name
}

resource "google_sql_database" "dev" {
  name     = "dev"
  instance = google_sql_database_instance.main.name
}

resource "google_sql_database" "asso" {
  count    = length(var.asso_list)
  name     = "asso-${element(var.asso_list,count.index)}"
  instance = google_sql_database_instance.main.name
}

data "google_sql_database_instance" "flixbee2" {
  name = "flixbee2"
}

resource "google_sql_database" "referential1" {
  name     = "referential"
  instance = data.google_sql_database_instance.flixbee2.name
}

resource "google_sql_database" "dev1" {
  name     = "dev"
  instance = data.google_sql_database_instance.flixbee2.name
}

resource "google_sql_database" "asso1" {
  count    = length(var.asso_list)
  name     = "asso-${element(var.asso_list,count.index)}"
  instance = data.google_sql_database_instance.flixbee2.name
}

