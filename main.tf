provider "google" {
  credentials = file("/Users/shivankgarg/tf-workspace/gcp-key/tokyo-dream-365917-a984eb29d7c0.json")
  project = "tokyo-dream-365917"
  region = "us-west2"
  zone = "us-west2-a"
}

resource "google_compute_instance" "first-resource" {
    name = "gcp-tf"
    machine_type = "e2-micro"
    boot_disk {
      initialize_params {
            image = "debian-cloud/debian-11"
            labels = {
                my_labels = "disk_shiv"
            }
        }
    }
    network_interface {
       network =  "default" // enable pvt ip address for this instance
       access_config {}      // enable public ip address for this instance
    }   
}

# firewall: Security groups are at the instance level and used to control traffic to instances.
/*s
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
*/

# Firewall rules are at GCP project level (VMs, storage bucket, firewall rules) and used to control traffic between subnetworks and the internet
resource "google_compute_firewall" "example" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["22"] # ssh
    # ports   = ["22", "80"] 
/* ssh secure shell (secure encrypted communications between two untrusted hosts over an insecure network. SSH is commonly used to log into a remote machine and execute commands, but it also supports tunneling, forwarding TCP ports and X11 connections.) + 
    HTTP (protocol for requesting and transferring files on the World Wide Web-inetrnet)
*/
  }

  source_ranges = ["0.0.0.0/0"] # all IP addess (in the range of 0.0.0.0 to 255.255.255.255) which is equal to all IPs.
}

/* For example, if an IP address is 192.168.1.100 and the subnet mask is 255.255.255.0, 
    the network address would be 192.168.1.0 and the host address would be 100. */
    