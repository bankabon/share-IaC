// 作成されたaws_instance.nat_ec2リソースのインスタンスIDを表示
output "instance_id" {
  value = aws_instance.nat_ec2.id
}

// 関連付けられたaws_security_group.sgリソースのセキュリティグループIDを表示
output "security_group_id" {
    value = aws_security_group.sg.id
}