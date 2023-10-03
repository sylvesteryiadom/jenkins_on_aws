const AWS = require('aws-sdk');
const eventbridge = new AWS.EventBridge();

exports.handler = async (event) => {
  // Extract the input from the event
  const userInput = event.input;

  // Query EventBridge for event buses starting with the user input
  const eventBusesResponse = await eventbridge.listEventBuses().promise();
  const matchingEventBuses = eventBusesResponse.EventBuses.filter((bus) =>
    bus.Name.startsWith(userInput)
  );

  // Evaluate daylight saving time and adjust the cron job time
  const currentTime = new Date();
  const isDaylightSavingTime = currentTime.dst();

  // Loop through matching event buses and adjust cron job times
  const adjustedEventBuses = [];
  for (const bus of matchingEventBuses) {
    const cronJob = bus.ScheduledEventBusName; // Assuming ScheduledEventBusName contains the cron job time

    // Parse the cron job time and adjust the hour
    const [minute, hour] = cronJob.split(' ');

    // Adjust the hour based on daylight saving time
    const adjustedHour = isDaylightSavingTime ? parseInt(hour) + 1 : parseInt(hour);

    // Create the adjusted cron job time
    const adjustedCronJob = `${minute} ${adjustedHour} * * ?`;

    // Update the EventBridge rule with the adjusted cron job time
    await updateEventBridgeRule(bus.Name, adjustedCronJob);

    // Store the adjusted event bus information
    adjustedEventBuses.push({
      name: bus.Name,
      adjustedCronJob,
    });
  }

  return adjustedEventBuses;
};

// Function to check daylight saving time
Date.prototype.dst = function () {
  var jan = new Date(this.getFullYear(), 0, 1);
  var jul = new Date(this.getFullYear(), 6, 1);
  return Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset()) === this.getTimezoneOffset();
};

// Function to update EventBridge rule
async function updateEventBridgeRule(ruleName, newCronExpression) {
  await eventbridge
    .putRule({
      Name: ruleName,
      ScheduleExpression: newCronExpression,
    })
    .promise();
}

locals {
  AWS_REGION   = data.aws_region.current.name
  AWS_ACCOUNT  = data.aws_caller_identity.current.id
  ossAccountId = var.env == "dev" ? ["111111", "2222222"] : (var.env == "int" || var.env == "prd") ? ["3333333", "444444", "555555"] : ["5555555", "1111111"]
}

resource "aws_sns_topic" "gbs-cap-complete-topic" {
  content_based_deduplication = false
  fifo_topic                  = false
  kms_master_key_id           = "alias/aws/sns"
  name                        = "gbs-${var.env}-cap-complete-topic"

  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "__default_policy_ID",
    "Statement" : [
      {
        "Sid" : "__default_statement_ID",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "SNS:Publish",
          "SNS:RemovePermission",
          "SNS:SetTopicAttributes",
          "SNS:DeleteTopic",
          "SNS:ListSubscriptionsByTopic",
          "SNS:GetTopicAttributes",
          "SNS:AddPermission",
          "SNS:Subscribe"
        ],
        "Resource" : "arn:aws:sns:${local.AWS_REGION}:${local.AWS_ACCOUNT}:gbs-${var.env}-cap-complete-topic",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceOwner" : "${local.AWS_ACCOUNT}"
          }
        }
      },
      {
        "Sid" : "__console_sub_0",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [join(",", local.ossAccountId)]
        },
        "Action" : [
          "SNS:Subscribe"
        ],
        "Resource" : "arn:aws:sns:${local.AWS_REGION}:${local.AWS_ACCOUNT}:gbs-${var.env}-cap-complete-topic"
      }
    ]
  })
  tags = local.all_tags
}
