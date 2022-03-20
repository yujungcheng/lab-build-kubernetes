#!/bin/bash

# example
virsh net-update default delete ip-dhcp-host "<host mac='52:54:00:03:25:8e' name='node3' ip='192.168.122.13'/>" --live --config
