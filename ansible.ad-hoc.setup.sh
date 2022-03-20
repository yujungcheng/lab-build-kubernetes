#!/bin/bash

ansible -i hosts all -m setup -u ubuntu
