variable "account_id" {
  type        = list(string)
  description = "スイッチロールを許可するAWSアカウントIDのリスト"
}

variable "policy_arn" {
  type        = string
  description = "アタッチするIAMポリシーのARN（空の場合はReadOnlyAccessが適用される）"
  default     = ""
}
