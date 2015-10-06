#!/usr/bin/env bash

echo "Installing Updates and cleaning up."
yum update -y
yum clean all
