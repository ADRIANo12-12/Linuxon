#!/bin/bash

# build_and_run.sh - Kompiluj moduł i wyświetl logi dmesg

set -e

echo "================================================"
echo "Kompilowanie modułu linuxrun..."
echo "================================================"

# Kompiluj moduł
make -C /lib/modules/$(uname -r)/build M=$(pwd) modules

echo ""
echo "================================================"
echo "Czyszczenie poprzedniej wersji modułu..."
echo "================================================"

# Usuń poprzedni moduł jeśli jest załadowany
sudo rmmod linuxrun 2>/dev/null || true

echo ""
echo "================================================"
echo "Załadowanie nowego modułu..."
echo "================================================"

# Załaduj nowy moduł z parametrami
sudo insmod linuxrun.ko message="hello from module" debug=1

echo ""
echo "================================================"
echo "Logi dmesg (ostatnie 30 linii):"
echo "================================================"

# Wyświetl logi dmesg
sudo dmesg -w

echo ""
echo "================================================"
echo "Gotowe!"
echo "================================================"
