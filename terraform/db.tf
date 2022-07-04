data "google_sql_database_instance" "flixbee2" {
  name = "flixbee2"
}

resource "google_sql_database" "asso" {
  name     = var.asso_name
  instance = data.google_sql_database_instance.flixbee2.name
}
