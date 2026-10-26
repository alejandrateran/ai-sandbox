terraform {
  required_version = ">= 1.9.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Proyecto inicial de GCP
resource "google_project" "bootstrap" {
  name            = "AI Sandbox Bootstrap"
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account
}

# 2. Bucket para almacenar el estado de Terraform
resource "google_storage_bucket" "terraform_state" {
  name     = var.bucket_name
  location = var.region
  project  = google_project.bootstrap.project_id

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }
}

# 3. Cuenta de servicio para el pipeline
resource "google_service_account" "terraform_pipeline" {
  project      = google_project.bootstrap.project_id
  account_id   = "terraform-pipeline"
  display_name = "Terraform CI/CD Pipeline"
}