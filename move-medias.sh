#!/bin/bash

## move arquivos baseados na data de modificação

# sudo mv $(ls -l|grep \ 2022\ |grep document-|awk '{print $9}') /mnt/volume_sfo3_01/whatsapp-medias/documents/

mediaList=$(ls -l | grep \ 2022\ | awk '{print $9}')

#mediaList=$(ls -l | grep Feb | awk '{print $9}')

for media in $mediaList
do
    echo "Moving - $media"
    mv $media /mnt/wip-medias
done
