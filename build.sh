#!/bin/bash


if [ $# -ne 2 ]; then
    echo "No se ingresó la ruta a ningún archivo nasm o no se ingresó la ruta hacia el USB."
    exit 1
fi


nasm -f win64 "$1" -o BOOTX64.obj
if [ $? -ne 0 ]; then
    echo "Error: No se pudo ensamblar el archivo NASM."
    exit 1
fi


lld-link /subsystem:efi_application /entry:efi_main /machine:x64 /nodefaultlib /out:BOOTX64.efi BOOTX64.obj
if [ $? -ne 0 ]; then
    echo "Error: Falló el enlazado con lld-link."
    exit 1
fi


sudo mkdir -p "$2/EFI/BOOT"
if [ $? -ne 0 ]; then
    echo "Error: No se pudieron crear las carpetas en la USB."
    exit 1
fi


sudo cp BOOTX64.efi "$2/EFI/BOOT"
if [ $? -ne 0 ]; then
    echo "Error: No se pudo copiar el archivo a la USB."
    exit 1
fi

echo "Se ha creado el archivo BOOTX64.efi y se ha transferido a la USB en EFI/BOOT."
