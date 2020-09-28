title "ScaleSec Lunch n Learn"
gcp_project_id = attribute("gcp_project_id")
gcp_zone = attribute("gcp_zone")
gcp_instance_name = attribute("gcp_instance_name")

control "limit-public-exposure" do
  impact 1.0
  title "Instance does not have an External IP address"
  desc "Check that compute instances do not have an IP address"
  describe google_compute_instance(project: gcp_project_id, zone: gcp_zone, name: gcp_instance_name) do
    its('first_network_interface_type'){ should_not eq "one_to_one_nat" }
  end
end

control "no-default-service-account" do
  impact 1.0
  title "Instance does not use the default service account"
  desc "Check that compute instance has a custom service account attached to it and not default (nil)"
  describe google_compute_instance(project: gcp_project_id, zone: gcp_zone, name: gcp_instance_name) do
    its('service_accounts'){ should_not be nil }
  end
end

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

# plural resources can be leveraged to loop across many resources
control "gcp-regions-loop-1.0" do                                                     # A unique ID for this control
  impact 1.0                                                                         # The criticality, if this control fails.
  title "Ensure regions have the correct properties in bulk."                         # A human-readable title
  desc "An optional description..."
  google_compute_regions(project: gcp_project_id).region_names.each do |region_name|  # Loop across all regions by name
    describe google_compute_region(project: gcp_project_id, name: region_name) do     # The test for a single region
      it { should be_up }
    end
  end
end
