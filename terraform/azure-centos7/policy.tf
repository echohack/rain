
resource "azurerm_policy_definition" "policy" {
  name         = "echohack-test-policy-standard-g"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "acceptance test policy definition"

  metadata = <<METADATA
    {
    "displayName": "Prevent VM SKU Size G*",
    "description": "This policy definition enforces that all virtual machines created in this scope have SKUs other than the G series to reduce cost."
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
        "allOf": [{
        "field": "type",
        "equals": "Microsoft.Compute/virtualMachines"
        },
        {
        "field": "Microsoft.Compute/virtualMachines/sku.name",
        "like": "Standard_G*"
        }
        ]
    },
    "then": {
        "effect": "deny"
    }
  }
POLICY_RULE

}

