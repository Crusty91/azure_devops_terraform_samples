az login
terraform init
terraform plan
terraform apply -auto-approve
az keyvault secret set --vault-name $(terraform output kvName) --name "baseName" --value $(terraform output baseName)
az keyvault secret set --vault-name $(terraform output kvName) --name "location" --value $(terraform output location)
az keyvault secret set --vault-name $(terraform output kvName) --name "commonRgName" --value $(terraform output rgName)
az keyvault secret set --vault-name $(terraform output kvName) --name "depStrContName" --value $(terraform output strContName)
az keyvault secret set --vault-name $(terraform output kvName) --name "depStraccName" --value $(terraform output straccName)
az keyvault secret set --vault-name $(terraform output kvName) --name "subscriptionId" --value $(az account show | jq .id)
az keyvault secret set --vault-name $(terraform output kvName) --name "owner" --value $(az account show | jq .user.name)