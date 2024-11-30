resource "aws_instance" "nat_ec2" { 

  tags = {
    Name = "${var.env}-NAT-EC2" //EC2名
    Dlm  = "${var.env}-NAT-EC2" //Data Lifecycle Manager名
  }
// /test/main.tfの設定を継承する
  ami                         = "ami-012261b9035f8f938"     // Amazon Linux 2023
  instance_type               = var.instance_type           // インスタンスファミリーおよびタイプを指定
  key_name                    = var.key_name                //SSHキーを指定 ※要事前設定
  iam_instance_profile        = var.iam_instance            //セッションマネージャーをするためのiamロールを指定

  //キャパシティー予約をなしに設定
  capacity_reservation_specification {
    capacity_reservation_preference = "none"
  }
   network_interface {
    network_interface_id = aws_network_interface.nat_instance.id
    device_index         = 0
  }

  // EBSのルートボリューム設定
  root_block_device {
    // ボリュームサイズ(GiB)
    volume_size = 8
    // ボリュームタイプ
    volume_type = "gp3"
    // GP3のIOPS
    iops = 3000
    // GP3のスループット
    throughput = 125
    // EC2終了時に削除
    delete_on_termination = true

    // EBSのNameタグ
    tags = {
      Name = "${var.env}-${var.name}-nat-ec2"
    }
  }

// natインスタンス用のユーザーデータ　※EC2インスタンスの起動時に実行されるスクリプトを指定
  user_data = <<EOF
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1 | tee -a /etc/sysctl.conf
yum install -y nftables
nft add table nat
nft -- add chain nat prerouting { type nat hook prerouting priority -100 \; }
nft add chain nat postrouting { type nat hook postrouting priority 100 \; }
nft add rule nat postrouting oifname "$(ip -o link show device-number-0 | awk -F': ' '{print $2}')" masquerade
nft list table nat | tee /etc/nftables/al2023-nat.nft
'include "/etc/nftables/al2023-nat.nft"' | tee -a /etc/sysconfig/nftables.conf
systemctl start nftables
systemctl enable nftables
EOF
  }


resource "aws_network_interface" "nat_instance" {
  subnet_id       = var.nat_subnet
  private_ips     = ["${var.ip_address}"]
  security_groups = [aws_security_group.sg.id]

  source_dest_check = false
}
