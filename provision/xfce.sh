#!/bin/sh

yum -y groupinstall "X Window System"

#install the lightweight xfce desktop
yum -y groupinstall xfce
yum -y install xfce4-terminal

#install additional themes. these can be selected with the desktop settings widget on xfce
wget -O crunchy-dark-grey.tar.gz https://dl.orangedox.com/xCs7czovfGqWuOhBgm/crunchy-dark-grey.tar.gz?dl=1
tar -xvf crunchy-dark-grey.tar.gz
mv crunchy-dark-grey /usr/share/themes
rm -f  crunchy-dark-grey.tar.gz

#install x2go for remote window access
yum -y install x2goserver-xsession

#install some helpful extras
yum -y install firefox install gedit

#manual stuff after installation
echo -e "\n\nDon't forget to select the theme you want as default, this script doesn't take care of that...\n\n"

echo -e "X2Go Client (https://lbtwiki.cern.ch/bin/view/Main/InstallingX2go)
Tab-key not working for bash-completion on XFCE
A bizarre bug redirects tab to window-switch on XFCE. You can fix this by editing one line in a file called:
$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
In this file change the following line:
<property name=\"<Super>Tab\" type=\"string\" value=\"switch_window_key\"/>
to this:
<property name=\"<Super>\" type=\"empty\"/>
Don't ask... , restart your session and enjoy."
