#!/bin/bash

# Executables
CL_VER=23.05.2

# Import signing keys
# Ref. https://docs.corelightning.org/docs/security-policy
gpg --keyserver hkps://keys.openpgp.org --recv-keys "15EE 8D6C AB0E 7F0C F999 BFCB D920 0E6C D1AD B8F1" # Rusty Russell
gpg --keyserver hkps://keys.openpgp.org --recv-keys "B731 AAC5 21B0 1385 9313 F674 A26D 6D9F E088 ED58" # Christian Decker
gpg --keyserver hkps://keys.openpgp.org --recv-keys "30DE 693A E0DE 9E37 B3E7 EB6B BFF0 F678 10C1 EED1" # Lisa Neigut
gpg --keyserver hkps://keys.openpgp.org --recv-keys "0437 4E42 789B BBA9 462E 4767 F3BF 63F2 7474 36AB" # Alex Myers

# Get the machine architecture
architecture=$(uname -m)

# Check the architecture and print the corresponding message
case $architecture in
    x86_64)
        CL_FILE=clightning-v${CL_VER}-Ubuntu-20.04.tar.xz
        echo "Installing Core-Lightning ${CL_VER} for x86_64"
        cd /tmp && \
        curl -# -sLO https://github.com/ElementsProject/lightning/releases/download/v${CL_VER}/${CL_FILE}
        curl -# -sLO https://github.com/ElementsProject/lightning/releases/download/v${CL_VER}/SHA256SUMS
        curl -# -sLO https://github.com/ElementsProject/lightning/releases/download/v${CL_VER}/SHA256SUMS.asc
        
        gpg --verify /tmp/SHA256SUMS.asc && \
        cd /tmp && grep "${CL_FILE}" /tmp/SHA256SUMS | sha256sum -c -
        cd / && tar -xvf /tmp/${CL_FILE}
        
        echo "alias lightning-cli=\"lightning-cli --lightning-dir=/lightningd\"" > "/root/.bashrc"
        echo "[[ \$PS1 && -f /usr/share/bash-completion/bash_completion ]] && \\" >> "/root/.bashrc"
        echo "    . /usr/share/bash-completion/bash_completion" >> "/root/.bashrc"
        
    ;;
    aarch64)
        echo "Executables not available for Core-Lightning ${CL_VER} for aarch64"
        echo "Compiling the source code..."
        
        cd /tmp && \
        git clone https://github.com/ElementsProject/lightning.git && \
        cd lightning && \
        git fetch --all --tags && \
        git reset --hard v${CL_VER} && \
        git verify-tag v${CL_VER} && \
        ./configure --enable-experimental-features --enable-developer && \
        make && \
        make install
        
        echo "alias lightning-cli=\"lightning-cli --lightning-dir=/lightningd\"" > "/root/.bashrc"
        echo "[[ -f /usr/share/bash-completion/bash_completion ]] && \\" >> "/root/.bashrc"
        echo "    . /usr/share/bash-completion/bash_completion" >> "/root/.bashrc"
        
    ;;
esac
