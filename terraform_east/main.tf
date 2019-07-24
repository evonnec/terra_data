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
  	}

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
			#"sudo apt-get update -y",
			#"sudo apt-get -y install nginx",
			#"sudo apt install apt-transport-https ca-certificates curl software-properties-common awscli emacs25 bash -y",
			#"sudo apt install build-essential cmdtest python3-pip -y",
			"sudo apt install postgresql postgresql-contrib -y",
			"git clone https://github.com/evonnec/terra_data.git",
			#"aws s3 sync s3://var.s3_bucket_name[var.region] ."
			"chmod +x ~/terra_data/",
			#"./terra_data/postgres_setup.sh"
		]
	}

	#provisioner "local-exec" {
    	#command = "echo ${aws_instance.control.public_ip} > ip_address.txt"
		#command = 	""echo "CREATE USER ${var.postgres_user} PASSWORD '${var.postgres_pwd}'; CREATE DATABASE ${var.db_name}; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${var.postgres_user};" | sudo -u postgres psql""
  		#command = 	""echo "CREATE USER airflow PASSWORD 'airflow'; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO airflow;" | sudo -u postgres psql""
	#}

	#provisioner "local-exec" {

		#"touch ~/.pgpass",
		#"chmod 700 .pgpass",
		#"sed -i 's//*:5432:${var.db_name}:${var.postgres_user}:${var.postgres_pwd}/g' .pgpass",
		#"service postgresql restart",
		#"sudo -u postgres psql"
		#"sudo -u postgres sed -i ''s|listen_addresses = 'localhost'|listen_addresses = '*'|'' /etc/postgresql/[0-9][0-9]/main/postgresql.conf",
  		#"sudo -u postgres sed -i ''s|127.0.0.1/32|0.0.0.0/0|'' /etc/postgresql/[0-9][0-9]/main/pg_hba.conf",
  		#"sudo -u postgres sed -i ''s|::1/128|::/0|'' /etc/postgresql/[0-9][0-9]/main/pg_hba.conf",
  		#"sudo -u postgres sed -i ''s|    peer|    md5|g''' /etc/postgresql/[0-9][0-9]/main/pg_hba.conf",
		
	#	command = ""echo "\du" | sudo -u postgres psql""
	#}

	#provisioner "local-exec" {
	#	command = ""echo "\password postgres" | sudo -u postgres psql""
	#}

	#provisioner "local-exec" {
	#	command = ""echo "\q" | sudo -u postgres psql"
	#}

	#provisioner "remote-exec" {	
	#	inline = [
	#	"sudo service postgresql reload",
	#	"chmod +x ./terra_data/"

}






