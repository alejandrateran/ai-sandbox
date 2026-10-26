mock_provider "google" {}

variables {
  project_id      = "test-ai-bootstrap"
  org_id          = "123456789012"
  billing_account = "ABCDEF-123456-789ABC"
  bucket_name     = "test-ai-terraform-state"
  region          = "us-central1"
}

run "validate_bootstrap" {
  command = plan

  assert {
    condition     = google_project.bootstrap.project_id == var.project_id
    error_message = "Project ID is incorrect."
  }

  assert {
    condition     = google_storage_bucket.terraform_state.versioning[0].enabled == true
    error_message = "Bucket versioning must be enabled."
  }

  assert {
    condition     = google_storage_bucket.terraform_state.public_access_prevention == "enforced"
    error_message = "Public access must be prevented."
  }

  assert {
    condition     = google_service_account.terraform_pipeline.account_id == "terraform-pipeline"
    error_message = "Service account ID is incorrect."
  }
}