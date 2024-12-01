#s3-KMS-Policy

resource "aws_kms_key" "s3_kms_key" {
  description              = "KMS Key for S3 bucket encryption"
  deletion_window_in_days  = 10
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  rotation_period_in_days  = 90
  tags = {
    Name = "${local.formatted_bucket_tag_name}-s3-kms-key"
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "s3-bucket-kms-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.user_account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow S3 to Use Key",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:ViaService": "s3.${var.region}.amazonaws.com"
        }
      }
    }
  ]
}
EOF
}


#RDS-KMS-Policy

resource "aws_kms_key" "rds_kms_key" {
  description              = "KMS key for encrypting RDS instance"
  deletion_window_in_days  = 10
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  rotation_period_in_days  = 90

  tags = {
    Name = "CSYE6225-RDS-KMS-Key"
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "rds-kms-policy",
  "Statement": [
    {
      "Sid": "AllowRootUserAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.user_account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "AllowRDSAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:ViaService": "rds.${var.region}.amazonaws.com"
        }
      }
    },
    {
      "Sid": "AllowRDSServiceRoleAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.user_account_id}:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

#EBS-KMS-Policy

resource "aws_kms_key" "ebs_kms_key" {
  description              = "EBS Key for encryption"
  deletion_window_in_days  = 10
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  rotation_period_in_days  = 90
  multi_region             = true
  tags = {
    Name = "CSYE6225-EBS-KMS-Key"
  }

  policy = <<EOF
{
    "Id": "key-for-ebs",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.user_account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow Auto Scaling Service Role to Use the Key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.user_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow Auto Scaling to Create and Manage Grants",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.user_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
EOF
}



# secretmanager KMS key 

resource "aws_kms_key" "db_password_key" {
  description             = "KMS key for encrypting the database password in Secrets Manager"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  rotation_period_in_days = 90


  tags = {
    Name        = "DBPasswordKMSKey"
    Environment = "production"
  }
}

resource "aws_kms_key_policy" "db_password_key_policy" {
  key_id = aws_kms_key.db_password_key.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowSecretsManagerAccess",
        Effect = "Allow",
        Principal = {
          Service = "secretsmanager.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },
      {
        Sid    = "AllowRootAccess",
        Effect = "Allow",
        Principal = {
          "AWS" : "arn:aws:iam::${var.user_account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      }
    ]
  })
}
