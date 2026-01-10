#!/bin/bash

cd "$HOME"
if [[ ! -d proiect_itbi ]]; then
    mkdir proiect_itbi
    mkdir ./proiect_itbi/director_radacina 
elif [[ ! -d ./proiect_itbi/director_radacina ]]; then
    mkdir ./proiect_itbi/director_radacina
fi

cd "$HOME"/proiect_itbi/director_radacina 

while true; do
    
    toti_userii=($( awk -F: '$3>999 && $1!="nobody" {print $1}' /etc/passwd ))
        
    #verificare daca exista directorul userului 
    for user in "${toti_userii[@]}"; do
        if [[ ! -d "$user" ]]; then 
            mkdir ./"$user"
            touch ./"$user"/procs
        fi   
    done

    #utilizatorii activi
    a_users=($(who | awk '{print $1}' | sort | uniq))
    for user in "${a_users[@]}"; do

        ps -u "$user" -o pid,comm>"$user"/procs 2>/dev/null
        
        #ascunderea fisierului 
        if [[ -f "./$user/lastlogin" ]]; then
            mv "./$user/lastlogin" "./$user/.lastlogin" 
        fi
    done

    for user in *; do
        
         #daca un user a fost sters
        if ! grep -qw "$user" /etc/passwd; then
            rm -r ./"$user"
            continue
        fi  

        #verificare daca un user s-a deconectat
        inact=1
        for x in "${a_users[@]}"; do
            if [[ "$x" == "$user" ]]; then
                inact=0
                break
            fi
        done

        #user deconectat
        if [[ "$inact" == 1 ]]; then
            >./"$user"/procs
            lastlog -u "$user" | tail -n 1 | awk '{print $4, $5, $6, $9, $7}'>./"$user"/.lastlogin
            mv ./"$user"/.lastlogin ./"$user"/lastlogin
        fi
    done
    sleep 30
done
