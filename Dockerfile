FROM kalilinux/kali

RUN apt update && apt dist-upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y kali-desktop-xfce
RUN apt install -y sudo bash-completion 'ttf-*' xfce4-terminal
RUN apt install -y curl net-tools neovim
RUN DEBIAN_FRONTEND=noninteractive apt install -y kali-linux-default
RUN apt install -y iputils-ping gobuster
RUN apt install -y redshift redshift-gtk

RUN echo "[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion" >> /etc/bash.bashrc
RUN sed -i 's/--no-generate //' /usr/share/bash-completion/completions/apt
RUN echo "cd" >> /etc/bash.bashrc
ADD init.vim /home/root/.config/nvim/

RUN groupadd -g 1001 kali && useradd -g kali -m -s /bin/bash kali && echo kali:kali | chpasswd
RUN echo "kali ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/kali

USER kali

RUN mkdir -p /home/kali/.config/xfce4 && echo TerminalEmulator=xfce4-terminal > /home/kali/.config/xfce4/helpers.rc
ADD --chown=1000:1001 init.vim /home/kali/.config/nvim/
ADD --chown=1000:1001 xfce4-panel.xml /home/kali/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
ADD --chown=1000:1001 .mozilla /home/kali/.mozilla/
ADD --chown=1000:1001 .bashrc /home/kali/
ADD --chown=1000:1001 .bash_aliases /home/kali/
ADD --chown=1000:1001 .tmux.conf /home/kali/

CMD startxfce4
