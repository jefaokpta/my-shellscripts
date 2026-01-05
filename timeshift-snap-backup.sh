#!/bin/bash

hdLocal="/dev/sda2"
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
mount -o subvolid=5 $hdLocal $montagemLocal
MOUNT_EXIT_CODE=$?
if [ $MOUNT_EXIT_CODE -ne 0 ]; then
    echo "❌ Montagem falhou"
    exit 1
fi

## Criando snapshot read only
echo "📦 Criando snapshot read only..."
btrfs subvolume snapshot -r $montagemLocal/timeshift-btrfs/snapshots/$nomeSnapshot/@ $montagemLocal/timeshift-btrfs/snapshots/${nomeSnapshot}_ro
MKSNAP_EXIT_CODE=$?
if [ $MKSNAP_EXIT_CODE -ne 0 ]; then
    echo "❌ Criação do snapshot read only falhou"
    exit 1
fi

## Sincronizando dados BTRFS
echo "⚡ Sincronizando dados..."
sync

## Copiando snapshot para HD externo
echo "🚚 Copiando snapshot para HD externo..."
btrfs send $montagemLocal/timeshift-btrfs/snapshots/${nomeSnapshot}_ro | btrfs receive $hdExterno
COPY_EXIT_CODE=$?
if [ $COPY_EXIT_CODE -ne 0 ]; then
    echo "❌ Cópia do snapshot falhou"
    exit 1
fi

## Desmontando HD local
echo "🔌 Desmontando HD local..."
umount /mnt

echo "✅ Backup do snapshot $nomeSnapshot concluído!"

## Fim do script
## pra restaurar o snapshot, copiar do hd externo para o hd local:
## sudo btrfs send /run/media/jefaokpta/TIMESHIFT/@ | sudo btrfs receive /mnt/timeshift/snapshots
## Caso va restaurar snapshot em uma nova instalação:
## Atualize todo o sistema com: sudo dnf upgrade -y
## iniciar o sistema em modo live com pendrive bootável
## substituir o /etc/fstab do snapshot no hd externo com o da nova instalação
## substituir o /boot/grub2 do snapshot no hd externo com o da nova instalação
## substituir o /boot/loader do snapshot no hd externo com o da nova instalaçao
## finalmente substituir o @ da instalação nova com o snapshot copiado no hd externo
## depois reiniciar o sistema