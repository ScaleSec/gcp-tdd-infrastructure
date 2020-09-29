module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = "tdd-testing-environment"
  names         = ["chef-inspec"]
  display_name  = "Chef InSpec Service Account"
  description   = "The Service Account used by Chef InSpec for Infrastructure Testing"
  project_roles = ["tdd-testing-environment=>roles/viewer"]
}
