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

echo "✅ Backup do snapshot $nomeSnapshot concluído!"

## Fim do script
## pra restaurar o snapshot, usar o comando:
## sudo btrfs send /run/media/jefaokpta/TIMESHIFT/@ | sudo btrfs receive /mnt/timeshift/snapshots
## Caso va restaurar snapshot em uma nova instalação:
## Atualize todo o sistema com: sudo dnf upgrade -y
## iniciar o sistema em modo live com pendrive bootável
## substituir o /etc/fstab do snapshot no hd externo com o da nova instalação
## substituir o /boot/efi do snapshot no hd externo com o da nova instalação
## substituir o /boot/grub2 do snapshot no hd externo com o da nova instalação
## substituir o /boot/loader do snapshot no hd externo com o da nova instalaçao
## finalmente substituir o @ da instalação nova com o snapshot copiado no hd externo
## depois reiniciar o sistema