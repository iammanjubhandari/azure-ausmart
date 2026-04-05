# au-prod

Australia production environment. Same modules as au-dev with production-sized variables.

Copy `au-dev/` files here and update `terraform.tfvars` with prod values:
- Larger node sizes
- Higher node counts
- enable_key_vault = true
- enable_waf = true
- enable_high_availability = true
