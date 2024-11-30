// security_group
resource "aws_security_group" "sg" {
  vpc_id = var.vpc_id                      // vpc配下でvpc_idを生成
  name   = "${var.env}-${var.name}-private-all-SG" // セキュリティーグループの名前を指定
  
  // アウトバンド側の設定
  egress {
    from_port        = 0            // 開始ポート
    to_port          = 0            // 終了ポート
    protocol         = "-1"         // すべてのプロトコルを許可
    cidr_blocks      = ["0.0.0.0/0"] // すべてのIPv4アドレス範囲からのトラフィックを許可
    ipv6_cidr_blocks = ["::/0"]     // すべてのIPv6アドレス範囲からのトラフィックを許可
  }
}

resource "aws_security_group_rule" "in"{
  type = "ingress"
  to_port = 0
  from_port = 0
  protocol = "-1"
  source_security_group_id = aws_security_group.sg.id
  security_group_id = aws_security_group.sg.id
}
