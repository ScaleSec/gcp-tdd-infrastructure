title "ScaleSec Lunch n Learn"

# Perform some Setup
gcp_project_id = attribute("gcp_project_id")
gcp_zone = attribute("gcp_zone")
gcp_instance_name = attribute("gcp_instance_name")

# Ensure instance doesn't use the default service account
control "no-default-service-account" do
  impact 1.0
  title "Instance does not use the default service account"
  desc "Check that compute instance has a custom service account attached to it and not default (nil)"
  describe google_compute_instance(project: gcp_project_id, zone: gcp_zone, name: gcp_instance_name) do
    its('service_accounts'){ should_not be nil }
  end
end

# Ensure resources have proper tagging
control "proper-tagging" do
  impact 1.0
  title "Proper Tagging for Compute Resources"
  desc "Check that compute instances have proper tags"
  describe google_compute_instance(project: gcp_project_id, zone: gcp_zone, name: gcp_instance_name) do
    it { should exist }
    its('labels_keys') { should include 'environment' }
    its('labels_keys') { should include 'data_classification' }
  end
  describe google_compute_instance(project: gcp_project_id, zone: gcp_zone, name: gcp_instance_name).label_value_by_key('environment') do
    it { should match '^(test|staging|production)$' }
  end
  describe google_compute_instance(project: gcp_project_id, zone: gcp_zone, name: gcp_instance_name).label_value_by_key('data_classification') do
    it { should match '^(public|sensitive|secret|top_secret)$' }
  end
end
