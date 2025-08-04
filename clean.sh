#!/bin/bash -eux

# uninstall ansible ale remova ppa
apt -y remove --purge ansible
apt-add-repository --remove ppa:ansible/ansible

# apt cleanup
apt -y autoremove
apt update

# zero out the rest of the free space using dd, then delete written file
dd if=/dev/zero of=/EMPTY bs=1M || true
rm -f /EMPTY

# add sync so packer dosent quit to early, before the large file is deleted
sync