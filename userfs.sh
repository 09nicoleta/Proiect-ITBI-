#!/bin/bash

cd "$HOME"/proiect_itbi/director_radacina 

while true; do
    a_users=($(users))

    for user in "${a_users[@]}"; do

            #verificare daca exista directorul userului 
        if [[ ! -d "$user" ]]; then
            mkdir ./"$user"
            touch ./"$user"/procs
        fi
        ps -u "$user" -o pid,comm>"$user"/procs
        #stergerea fisierului 
        if [[ -f "./$user/lastlogin" ]]; then
            rm "./$user/lastlogin" 

        fi
        
    done

    for user in *; do
        inact=1

        for x in "${a_users[@]}"; do
            if [[ "$x" == "$user" ]]; then
                inact=0
                break
            fi
        done

        if [[ "$inact" == 1 ]]; then
            >./"$user"/procs
            lastlog -u "$user" | tail -n 1 | awk '{print $4, $5, $6, $9, $7}'>./"$user"/lastlogin
            
        fi
    done
    sleep 30
done