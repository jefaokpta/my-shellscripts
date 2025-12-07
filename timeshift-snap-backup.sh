#!/bin/bash

snapshot=$1
if [ -z "$snapshot" ]
then
  echo "🧨 Falta o caminho completo do snapshot!"
  exit 1
fi

## Montar subvolumes do BTRFS
sudo mount -o subvolid=5 /dev/nvme0n1p2 /mnt 

## Tornando snapshot read only
sudo btrfs subvolume snapshot -r fonte /run/media/jefaokpta/TIMESHIFT



## Desmontando HD local
sudo umount /mnt