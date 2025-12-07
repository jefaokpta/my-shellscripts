#!/bin/bash

hdLocal="/dev/nvme0n1p2"
hdExterno="/run/media/jefaokpta/TIMESHIFT"
montagemLocal="/mnt"

nomeSnapshot=$1
if [ -z "$nomeSnapshot" ]
then
  echo "🧨 Falta o nome do snapshot!"
  exit 1
fi

## Montar subvolumes do BTRFS
echo "🔧 Montando HD local..."
sudo mount -o subvolid=5 $hdLocal $montagemLocal

## Tornando snapshot read only
echo "📦 Criando snapshot read only..."
sudo btrfs subvolume snapshot -r $montagemLocal/timeshift/snapshots/$nomeSnapshot/@ $montagemLocal/timeshift/snapshots/${nomeSnapshot}_ro

## Sincronizando dados BTRFS
echo "⚡ Sincronizando dados..."
sudo sync

## Copiando snapshot para HD externo
echo "🚚 Copiando snapshot para HD externo..."
sudo btrfs send $montagemLocal/timeshift/snapshots/${nomeSnapshot}_ro | sudo btrfs receive $hdExterno

## Desmontando HD local
echo "🔌 Desmontando HD local..."
sudo umount /mnt