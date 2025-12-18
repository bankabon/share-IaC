variable "env" {
  type        = string
  description = "環境名（例: production, staging, development）"
}

variable "name" {
  type        = string
  description = "リソース名のプレフィックス"
}

variable "desc" {
  type        = string
  description = "WAF ACLの説明"
}

variable "metric_name" {
  type        = string
  description = "CloudWatchメトリクス名"
}

variable "account" {
  type        = string
  description = "AWSアカウントID"
}

variable "alb_arn" {
  type        = string
  description = "関連付けるALBのARN"
}