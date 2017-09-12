#echo -e "${LTGREEN}COMMAND: ${GRAY}_COMMAND_GOES_HERE_${NC}"
#_COMMAND_GOES_HERE_

cd ${HOME}/course_files/${COURSE_NUM}/suse-cloud-vagrant/vagrant
echo -e "${LTGREEN}COMMAND: ${GRAY}vagrant destroy${NC}"
vagrant destroy
echo -e "${LTGREEN}COMMAND: ${GRAY}vagrant box remove suse/sles12sp2${NC}"
vagrant box remove suse/sles12sp2
echo -e "${LTGREEN}COMMAND: ${GRAY}vagrant box remove suse/cloud7-admin${NC}"
vagrant box remove suse/cloud7-admin

# For some reason, virsh vol-delete doesn't work for the vagrant images...
echo -e "${LTGREEN}COMMAND: ${GRAY}rm -f /var/lib/libvirt/images/{suse-VAGRANTSLASH*,sbd.img}${NC}"
rm -f /var/lib/libvirt/images/{suse-VAGRANTSLASH*,sbd.img,drbd*.img,vagrant-*}
echo -e "${LTGREEN}COMMAND: ${GRAY}virsh pool-refresh default${NC}"
virsh pool-refresh default

# Make sure that all VMs are really dead and gone...
for VM in $(virsh list --all | grep -v Id | grep -v "^-" | awk '{ print $2 }')
do 
  virsh destroy ${VM}
  virsh undefine ${VM}
done
