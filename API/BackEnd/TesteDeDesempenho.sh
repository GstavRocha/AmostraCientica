#!/bin/bash 
if [ $# -eq 0]; then
    echo "USO: $0 <script>"
    exit 1
fi

SCRIPT=$1

if [! -f "$SCRIPT"]; then
    echo " Arquivo não encontrado"
fi
echo "Executando o script: $SCRIPT"
time bash "$SCRIPT"