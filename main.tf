provider "aws" {
  region = "us-east-1"
}

#Creating AWS Service catalog Portfolio 
resource "aws_servicecatalog_portfolio" "portfolio" {
  name          = "My Test Portfolio"
  description   = "Ec2 Apache webserver"
  provider_name = "Gowtham"
}

#creation of serive catalog product
resource "aws_servicecatalog_product" "example" {
  name  = "example"
  owner = "example-owner"
  type  = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    template_url = "https://s3.us-east-1.amazonaws.com/cf-templates-pk0vw74r4mwj-us-east-1/2023-04-08T080349.176Zlaa-3-ec2-with-ssh-22-80.yml"
    name         = "TestAwsServiveEC2"
    description  = "v1.0"
    type         = "CLOUD_FORMATION_TEMPLATE"
  }
}

#Associating the service catalog product with portfolio
resource "aws_servicecatalog_product_portfolio_association" "example" {
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  product_id   = aws_servicecatalog_product.example.id
}

#To manage  Service Catalog Principal Portfolio Association
resource "aws_servicecatalog_principal_portfolio_association" "example" {
  portfolio_id  = aws_servicecatalog_portfolio.portfolio.id
  principal_arn = "arn:aws:iam::328268088738:user/tf_user"
}

#Shares the specified portfolio with the specified account or organization node
# resource "aws_servicecatalog_portfolio_share" "example" {
#   principal_id = "012128675309"
#   portfolio_id = aws_servicecatalog_portfolio.portfolio.id
#   type         = "ACCOUNT"
# }

#Lists the paths to the specified product and also also determines the constraints put on the product.
data "aws_servicecatalog_launch_paths" "example" {
  product_id = aws_servicecatalog_product.example.id
}

# provisions and manages a Service Catalog provisioned product.
resource "aws_servicecatalog_provisioned_product" "example" {
  name                       = "Simple_Ec2"
  product_id                 = aws_servicecatalog_product.example.id
  path_id                    = data.aws_servicecatalog_launch_paths.example.summaries[0].path_id
  provisioning_artifact_name = aws_servicecatalog_product.example.provisioning_artifact_parameters[0].name
}
