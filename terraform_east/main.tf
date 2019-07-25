resource "aws_instance" "control" {
	ami                  			= var.amis[var.region]
	instance_type           		= "t2.xlarge"
	vpc_security_group_ids 			= [var.security_group[var.region]]
	key_name 						= var.key_pair_name[var.region]
	associate_public_ip_address 	= true
	monitoring						= true
	#depends_on 					= [aws_route_table.public_route_table]

	root_block_device {
		volume_size = "100"
  	}	#this would ideally be replaced with an elastic block store block device with mounting instructions

	connection {
		user   						= "ubuntu"
		agent 						= "false"
		host 						= self.public_ip
		private_key 				= "${file("~/.ssh/${aws_instance.control.key_name}.pem")}"
		# The connection will use the local SSH agent for authentication.
		type 						= "ssh"
	}

	provisioner "remote-exec" {
		inline = [
			"sleep 40",
			"export PATH=$PATH:usr/bin",
			"sudo apt-get update -y",
			"sudo apt-get -y install nginx",
			"sudo apt install apt-transport-https ca-certificates curl software-properties-common awscli emacs25 bash -y",
			"sudo apt install build-essential cmdtest python3-pip -y",
			"sudo apt install postgresql postgresql-contrib -y",
			"git clone https://github.com/evonnec/terra_data.git",
			"chmod +x ~/terra_data/",
			"source ./terra_data/env_vars.sh"
			"source ./terra_data/setup.sh",
			"./terra_data/setup.sh"
		]
	}
}

resource aws_key_pair "terra_data" {
    key_name = "terra_data_${var.random_string}"
    public_key = "${file("~/.ssh/${var.terra_data_key})}"
}




