# 1️⃣ Aktualizacja i instalacja wszystkich potrzebnych pakietów
sudo apt update && sudo apt install -y \
    build-essential \
    libncurses-dev \
    bison \
    flex \
    libssl-dev \
    libelf-dev \
    qemu-system-x86 \
    qemu-kvm \
    qemu-utils \
    git \
    bc \
    cpio \
    wget \
    make \
    gcc \
    pkg-config \
    python3 \
    python3-distutils \
    python3-dev \
    libglib2.0-dev \
    libpixman-1-dev

# 2️⃣ Sklonowanie najnowszego kernela z GitHub (fork lub oficjalny)
git clone https://github.com/torvalds/linux.git ~/linux-kernel
cd ~/linux-kernel

# 3️⃣ Opcjonalnie możesz przełączyć się na konkretną gałąź lub commit
# git checkout v6.x

# 4️⃣ Konfiguracja kernela
make mrproper           # czyszczenie poprzednich konfiguracji
make menuconfig         # interfejs ncurses do wyboru opcji kernela

# 5️⃣ Kompilacja kernela
make -j$(nproc)         # kompilacja całego kernela
make modules_install    # instalacja modułów
make install            # instalacja jądra w /boot

# 6️⃣ Uruchomienie w QEMU w trybie tekstowym (bez GUI)
qemu-system-x86_64 -kernel arch/x86/boot/bzImage -nographic -append "console=ttyS0"
