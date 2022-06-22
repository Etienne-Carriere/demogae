resource "google_app_engine_flexible_app_version" "back" {
  version_id = "v1"
  service    = var.asso_name
  runtime    = "java"

  entrypoint {
    shell = "java -jar gae-gcp.jar"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.back.name}/${google_storage_bucket_object.back.name}"
    }
  }

  handlers{
    url_regex = "/.*"
    redirect_http_response_code = "REDIRECT_HTTP_RESPONSE_CODE_301"
    security_level              = "SECURE_ALWAYS"
    script {
      script_path = "auto"
    }
  }

  liveness_check {
    path = "/api/hello"
  }

  readiness_check {
    path = "/api/hello"
  }

  manual_scaling {
    instances = 1
  }

  resources {
    cpu = 2
    disk_gb = 10
    memory_gb = 2
    volumes {
      name = "ramdisk1"
      size_gb = 1
      volume_type = "tmpfs"
    }
  }

  env_variables = {
    SPRING_PROFILES_ACTIVE = "gcp,mysql"
    database_name = google_sql_database.asso.name
  }
  delete_service_on_destroy = true
}

resource "google_storage_bucket" "back" {
  name     = "flixbee-appengine-static-content"
  location = "US"
}

resource "google_storage_bucket_object" "back" {
  name   = "test.zip"
  bucket = google_storage_bucket.back.name
  source = "./back.zip"
}

