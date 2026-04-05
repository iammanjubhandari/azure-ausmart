# us-prod

US production environment. Same modules, different region.

Copy `au-dev/` files here and update `terraform.tfvars`:
- location = "eastus2"
- Prod-sized values
- Different state key in backend config
