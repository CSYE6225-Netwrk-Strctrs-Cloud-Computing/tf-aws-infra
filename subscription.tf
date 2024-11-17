resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.user_creation_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.user_creation_lambda.arn
}


resource "aws_lambda_permission" "allow_sns_invocation" {
  statement_id  = "AllowSNSInvocation"
  action        = "lambda:InvokeFunction"
  principal     = "sns.amazonaws.com"
  function_name = aws_lambda_function.user_creation_lambda.function_name
  source_arn    = aws_sns_topic.user_creation_topic.arn
}
