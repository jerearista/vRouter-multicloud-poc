%EOS-STARTUP-CONFIG-START%
switchport default mode routed
!
transceiver qsfp default-mode 4x10G
!
hostname vRouter-${octet}
!
spanning-tree mode mstp
!
aaa authentication policy on-success log
aaa authentication policy on-failure log
!
no aaa root
!
username ec2-user nopassword
username ec2-user sshkey ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr3gRMpQOat1ozxSIqXX+e5x+7WNba6ZXXUhTJvKwTWlryqsCvqCXyV1L2B/s6u0DtNFi2NpH0YsjXZedKqSMQTont68eqnzrxz+KT+XkMkA1HfaRQ7M/qz5d3CwAGjGRziDmbDkSFyDuNZAiIuajwxltQ5qeZ7WCYVJUCAh0v/3v+cf9oPI4tQYKuORgm8EuG6r2/kIlfGrdgscm/Ww/XH4+gS9VKaBMKulZF1fiEWk5fXAykDijstCwQdF3pddvP44x3Uws7fuAA2q/vc8JDpZS344t+CRGbECZHCBxLcq8ZrOvOUgb511NwNme2p0vRbj6RTDgNyxdWQgRIk7R9 ec2-user-key
!
interface Ethernet1
   description To-Mgmt
   mtu 8973
   no switchport
   ip address ${eth1_ip}/28
!
interface Ethernet2
   description To-VPC-114
   mtu 8973
   no switchport
   ip address ${eth2_ip}/28
!
interface Ethernet3
   description APP-side
   mtu 8973
   no switchport
   ip address ${eth3_ip}/28
!
interface Tunnel1
   description Tunnel_To_VPC-114
   mtu 8973
   ip address 10.114.115.2/30
   tunnel source ${eth2_ip}
   tunnel destination 10.115.114.6
   tunnel key 101
!
ip route 10.115.114.0/28 10.115.115.1
!
ip routing
!
router bgp 65102
   neighbor 10.114.115.1 remote-as 65102
   neighbor 10.114.115.1 maximum-routes 12000
   redistribute connected
!
%EOS-STARTUP-CONFIG-END%
