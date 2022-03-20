#!/bin/bash


mac_master='52:54:00:c9:e3:6f'
mac_node1='52:54:00:30:e1:74'
mac_node2='52:54:00:c0:13:87'
mac_node3='52:54:00:03:25:8e'
ip_master='192.168.122.10'
ip_node1='192.168.122.11'
ip_node2='192.168.122.12'
ip_node3='192.168.122.13'


virsh net-update default add ip-dhcp-host "<host mac='${mac_master}' name='master' ip='${ip_master}'/>" --live --config
virsh net-update default add ip-dhcp-host "<host mac='${mac_node1}' name='node1' ip='${ip_node1}'/>" --live --config
virsh net-update default add ip-dhcp-host "<host mac='${mac_node2}' name='node2' ip='${ip_node2}'/>" --live --config
virsh net-update default add ip-dhcp-host "<host mac='${mac_node3}' name='node3' ip='${ip_node3}'/>" --live --config

