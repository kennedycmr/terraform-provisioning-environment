terraform {
  backend "gcs" {
    # Values configured as part of environment variables in pipeline
  }
}



# Import current project
data "google_project" "gcp_project_id" {
  project_id = var.GCP_PROJECT_ID
}

