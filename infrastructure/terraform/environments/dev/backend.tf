terraform {
  backend "azurerm" {
    use_azuread_auth = true
    use_cli = true

    storage_account_name = "stnorthstartfstate001"
    container_name = "tfstate"
    key = "dev.terraform.tfstate"
  }
}