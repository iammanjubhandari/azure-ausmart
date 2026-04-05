location               = "australiaeast"
project_name           = "ausmart"
environment            = "dev"
owner                  = "manju"
# alert_email is in secrets.auto.tfvars (gitignored — not committed)
cluster_name           = "ausmart-aks"
node_vm_size           = "Standard_D2s_v3"
node_min_count         = 1
node_max_count         = 6
node_count             = 3
enable_key_vault       = false
enable_waf             = false
enable_high_availability = false
monthly_budget         = "500"
