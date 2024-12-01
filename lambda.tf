resource "random_uuid" "lambda_bucket_uuid" {}


resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "lambda-code-bucket-${random_uuid.lambda_bucket_uuid.result}"
}


resource "aws_s3_bucket_object" "lambda_object" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "user_creation_lambda.zip"
  source = var.lambda_zip_path
  acl    = "private"
}


resource "aws_lambda_function" "user_creation_lambda" {
  function_name = "user-creation-lambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  s3_bucket = aws_s3_bucket.lambda_bucket.bucket
  s3_key    = aws_s3_bucket_object.lambda_object.key

  vpc_config {
    subnet_ids         = aws_subnet.aws_tanuj_private_subnets[*].id
    security_group_ids = [aws_security_group.lambda_sg.id]
  }


  timeout = 30

  depends_on = [
    aws_security_group.lambda_sg
  ]
  environment {
    variables = {
      SECRET_NAME = var.user_creation_secret_name
    }
  }
}



