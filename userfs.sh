#!/bin/bash

cd /home/nic/proiect_itbi/director_radacina 
a_users=($(users))

for u in "${a_users[@]}"; do

        #verificare daca exista directorul userului 
    if [[ ! -d "$u" ]]; then
        mkdir ./"$u"
        touch ./"$u"/procs
    fi

    
   
done

