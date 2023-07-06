data "aws_caller_identity" "current" {}

locals {
  account_id    = data.aws_caller_identity.current.account_id
  ossAccountId = var.env == "dev" ? "1023521001" : (var.env == "int" || var.env == "pvs") ? "1333115252" : "9956599262"
}

resource "aws_sns_topic" "gbs-cap-complete-topic" {
  content_based_deduplication = false
  fifo_topic                  = false
  kms_master_key_id           = "alias/aws/sns"
  name                        = "gbs-${var.env}-cap-complete-topic"

  policy = <<EOF

{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:us-east-1:646309344050:gbs-dev-cap-complete-topic",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${local.account_id}"
        }
      }
    },
    {
      "Sid": "__console_sub_0",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${local.ossAccountId}"
        ]
      },
      "Action": [
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:us-east-1:646309344050:gbs-dev-cap-complete-topic"
    }
  ]
}
EOF

  # tags = merge(var.cigna_required_tags, {
  #   ComplianceDataCategory = "pci"
  #   DataClassification     = "restricted"
  #   DataSubjectArea        = "claim"
  # })
}

