run () {
  echo -e "${LTGREEN}COMMAND: ${GRAY}$*${NC}"
  "$@"
}

on_admin () {
  run sshpass -p vagrant ssh -o StrictHostKeyChecking=no root@192.168.124.10 "$@"
}

set -e

run sudo zypper --gpg-auto-import-keys --no-gpg-checks --non-interactive in ${HOME}/course_files/${COURSE_NUM}/*.rpm

pushd ${HOME}/course_files/${COURSE_NUM}
run vagrant box add ${HOME}/course_files/${COURSE_NUM}/cloud7-admin-vagrant.x86_64-0.0.1.libvirt.json
run vagrant box add ${HOME}/course_files/${COURSE_NUM}/sles12sp2.x86_64-0.0.1.libvirt.json
popd

cd ${HOME}/course_files/${COURSE_NUM}/
run tar xf suse-cloud-vagrant.tar

cd ${HOME}/course_files/${COURSE_NUM}/suse-cloud-vagrant/vagrant

run sudo bash -c 'rm -f /var/lib/libvirt/images/{suse-VAGRANTSLASH*,sbd.img,drbd*.qcow2,vagrant_*}'
run virsh pool-refresh default
run vagrant up admin
run vagrant up controller1
run vagrant up
on_admin chmod +x /root/bin/setup-node-aliases.sh
on_admin /root/bin/setup-node-aliases.sh
on_admin crowbar batch build HA-compute-cloud-demo.yaml
on_admin ssh controller1 chmod +x /root/bin/upload-cirros 
on_admin ssh controller1 /root/bin/upload-cirros
