module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = "scalesec-dev"
  prefix        = "chef-inspec"
  display_name  = "Chef InSpec Service Account"
  description   = "The Service Account used by Chef InSpec for Infrastructure Testing"
}
