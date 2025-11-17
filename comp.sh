#!/bin/bash
# build_linuxon_progress.sh – lekki kernel Linuxon z procentami

set -e

KERNEL_DIR="./linux-kernel"
OUTPUT_DIR="./linux-build"

if [ ! -d "$KERNEL_DIR" ]; then
    echo "Nie znaleziono katalogu linux-kernel. Sklonuj kernel najpierw."
    exit 1
fi

cd "$KERNEL_DIR"

# 1️⃣ Czyszczenie
make mrproper

# 2️⃣ Minimalna konfiguracja
make defconfig
make prepare

# 3️⃣ Obliczamy ile plików do kompilacji (tylko C w kernel/ i arch/)
TOTAL=$(find kernel arch -name '*.c' | wc -l)
COUNT=0
START_TIME=$(date +%s)

# 4️⃣ Funkcja do pokazania procentów i ETA
function show_progress() {
    PERCENT=$((COUNT*100/TOTAL))
    NOW=$(date +%s)
    ELAPSED=$((NOW-START_TIME))
    if [ $COUNT -gt 0 ]; then
        ETA=$((ELAPSED * TOTAL / COUNT - ELAPSED))
    else
        ETA=0
    fi
    printf "\rProgress: %3d%% | Compiled: %4d/%4d | ETA: %4ds" $PERCENT $COUNT $TOTAL $ETA
}

# 5️⃣ Kompilacja w pętli po katalogach (CC)
FILES=$(find kernel arch -name '*.c')
mkdir -p "$OUTPUT_DIR"

for f in $FILES; do
    COUNT=$((COUNT+1))
    # kompilacja pojedynczego pliku do obiektu
    make -j1 $f > /dev/null 2>&1 || { echo; echo "Błąd kompilacji $f"; exit 1; }
    show_progress
done

# 6️⃣ Tworzenie bzImage
make -j$(nproc) bzImage > /dev/null 2>&1
cp arch/x86/boot/bzImage "$OUTPUT_DIR/"

echo
echo "Kompilacja zakończona. Obraz w $OUTPUT_DIR/bzImage"
echo "Uruchom w QEMU:"
echo "qemu-system-x86 -kernel $OUTPUT_DIR/bzImage -nographic -append \"console=ttyS0\""
