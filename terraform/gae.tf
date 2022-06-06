resource "google_app_engine_flexible_app_version" "myapp_v1" {
  count = length(var.asso_list)
  version_id = "v1"
  service    = element(var.asso_list, count.index)
  runtime    = "java"

  entrypoint {
    shell = "java -jar gae-gcp.jar"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
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
    path = "/api/books"
  }

  readiness_check {
    path = "/api/books"
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
  }
  delete_service_on_destroy = true
}

resource "google_storage_bucket" "bucket" {
  name     = "flixbee-appengine-static-content"
  location = "US"
}

resource "google_storage_bucket_object" "object" {
  name   = "test.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./test.zip"
}

