#!/bin/bash

ansible all -u ubuntu -m ansible.builtin.apt -a "update_cache=yes name=* state=latest" --ask-become-pass --become
