
install_mdadm() {
      yum install -y mdadm smartmontools hdparm gdisk
}

zero_suberblock() {
mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g,h,i}
}

conf_raid10(){
mdadm --create --verbose /dev/md0 -l 10 -n 8 /dev/sd{b,c,d,e,f,g,h,i}
}

check_raid() {
     cat /proc/mdstat
}

save_raid() {
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf
}

create_fs() {
parted -s /dev/md0 mklabel gpt
#parted /dev/md0 mkpart primary ext4 0% 100%
sudo mkfs.ext4 /dev/md0
mkdir -p /raid
mount /dev/md0 /raid/
}

main() {
    install_mdadm
#  zero_suberblock
  conf_raid10
  check_raid
  save_raid
  create_fs
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
