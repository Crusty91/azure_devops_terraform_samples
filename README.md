Starter pack pour commencer a deployer des resources dans Azure, depuis Azure DevOps, avec Terraform et un Keyvault.

# Resources communes

le repertoir common_resources contient les templates et scripts pour deployer un compte de stockage avec un container pour les tfstates ainsi qu'un keyvault pour les variables de déploiements.

Pour l'utiliser:
1. Installer terraform & az cli locallement
1. Aller dans le repertoir common_resources
1. Creer un fichier local.auto.tfvars et définir chage variable
    1. baseName: nom de base pour nommer les ressources (ex: demo)
    1. location: localisation des ressources (ex: canadaeast)
    1. environment: utilisé pour nommer et taguer les ressources (ex: common)
    1. tenantId: utiliser pour la configuration du keyvault pour donner acces a l'utilisateur courant
    1. objectId: identifiant unique dans AAD. On peut utiliser la command 'az ad signed-in-user show' et récupérer la valeur de 'ObjectId'
1. Executer le script deploy.ps1

# aci

Afin de démontrer l'utilisation de cette environment de base pour déployer des ressources, un projet de déploiement d'architecture a été mis en place.
Le déploiement est fait pour s'opérer depuis Azure DevOps en utilisant le fichier azure-pipelines-ACI.yml.
Le déploiement va utiliser les ressources communes pour fonctionner.
Le déploiement va utiliser les variables contenues dans le keyvault pour se configurer.

Pour l'utiliser:
1. Créer un compte Azure DevOps
1. Créer un projet
1. Créer un nouveau pipeline en connectant a github et en utilisant un fichier yml existant: utiliser le fichier azure-pipelines-ACI.yml
1. Modifier le fichier azure-pipelines-ACI.yml pour ajuster suivant vos besoins
    1. Modifier la connexion utilisée pour se connecter au KeyVault et le nom du keyvault pour correspondre a l'execution du déploiement des ressources communes.
    1. Au besoin, modifier les access policies du keyvault pour donner acces a la connection utilisée
1. executer le déploiement.