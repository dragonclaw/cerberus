#!/bin/bash


#|------------------------------------------------------------------------------
#|	create a live linux mint usb installer on an external usb drive
#|------------------------------------------------------------------------------

# Convert the .iso file to .img using the convert option of hdiutil 
hdiutil convert -format UDRW -o ~/Desktop/mint.img ~/Desktop/mint.iso

# check the list of devices
df -h

# unmount the drive
diskutil unmountDisk /dev/disk2

# copy the img to the usb drive
sudo dd if=~/Desktop/mint.img of=/dev/rdisk2 bs=1m

# After the dd command finishes, eject the drive:
diskutil eject /dev/rdisk2


#|------------------------------------------------------------------------------
#| format the usb stick you are going to intsall mint on to
#|------------------------------------------------------------------------------


# we are going to install oinux mint on a usb stick which needs to be formatted first


# plug in the usb stick and wiat for it to mount on the desktop 

# open disk utility and select the usb stick in the left sidebar
# you need to select the top level of the drive and not the second level

# select the partition tab, change the format to FAT

# then select the options button and make sure GUID Partition Table is selected
# then click apply to format the drive

# the drive needs to have the GUID Partition Table so the mac will boot up from the drive




#|------------------------------------------------------------------------------
#| install Linux Mint on 11 inch Mac airs ssd
#|------------------------------------------------------------------------------


#|------------------------------------------------------------------------------
#| back up your files
#|------------------------------------------------------------------------------

#  backup everything from your mac
# back up paswords, ssh keys, file etc to an external drive

#|------------------------------------------------------------------------------
#| clone the macs internal drive to an external usb drive
#|------------------------------------------------------------------------------

# shutdown your mac 

# turn your mac on and boot into recovery mode by holding r while the mac boots up

# on the recovery mode screen select disk utility

# select the top level of your macs internal drive in the left sidebar

# then select the recovery tab

# you should see a source and destination filefield where you can select drives

# the source should be filled with the internal drive of your mac,
# if you have filevault encryption turned on you need to go to the file menu and select unlock drivename
# and then enter your recovery password to decrypt the drive before you clone it

# now plug in a usb drive the same size or bigger than your macs internal drive

# you should see the usb drive appear in the left sidebar of the disk utilty window

# select the top level of your external usb drive in the left sidebar and drag it into the destintion filefield

# you should now have your macs internal hard drive in the source filefield and the external usb drive in the destintion filefield

# double check and then click ok to start cloning the macs internal drive to the external usb drive

# when disk utility has finished cloning you can quit to return to main recovery mode screen

# then quit the recovery mode screen and it will ask you to select a start up disk

# select the external usb you just created to boot up from to make sure it works

#|------------------------------------------------------------------------------
#| erase and format the mac internal drive to fat
#|------------------------------------------------------------------------------

# make sure you have backup everything from your macs internal drive

# boot up into external usb clone of your macs internal drive

# open disk utility 

# in the left hand sidebar you will see 4 drives listed

# the external usb drive should be listed at the top and have a coloured icon
# underneath it and slightly indent to the right will be usb drive partition

# you should also see your macs internal drive in the lefthand sidebar which doesnt have a cloured icon
# underneath it and slightly indent to the right will be internal drive partition

# you need to select the internal drive partition that is under the main drive and slightly indented to the right

# do not select the top level of the internal drive otherwsie you will erase the efi bootloader

# now you have internal drive partition selected click the erase tab and from the pop up menu select the top option, mac osx journal

# then click the erase button to erase the macs internal hard drive, this wont erase the bootloader which is on a seperate partition
# but it will erase the recovery partition

# after you have erased the macs internal drive you need to format it as Fat so linux mint can right to it during the install

# double check you have the internal drive partition that is under the main drive and slightly indented to the right selected

# then in the erase tab select mos dos fat from the format menu and erase the drive to format it as fat

# after you have erased the macs internal drive quit disk utility

# and then shut down the mac and unplug the external usb drive that you have boot up from

#|------------------------------------------------------------------------------
#| boot up from the linux mint live usb drive
#|------------------------------------------------------------------------------

# now plug in the linux mint live usb drive and boot up from it

# now you can either install linux mint to either an external usb drive or the macs internal ssd

# reboot the mac insert the usb drive and press option and then boot into linux

# Boot your system using the Linux Mint 14 live CD or USB stick


# IMPORTANT

# change your keyboard layout to Macintosh UK staight away

# then check your keyboard layout by typing out the passwords you are going to use in a text file
# because when you run the ubiquity installer you cant see the passwords you are typing in


# connect to wifi network


# we need to update the ubiquity installer to enable LUKS full disk encryption

# remove ubiquity
sudo apt-get remove ubiquity

# apt-get update
sudo apt-get update

# reinstall ubiquity
sudo apt-get install ubiquity

# start the ubiquity installer
sudo ubiquity


#|------------------------------------------------------------------------------
#| ubiquity installer
#|------------------------------------------------------------------------------


# select guided install full disk encryption

# select the drive to install to

# then enter the password for full disk encryption

# change your keyboard layout to Macintosh UK, 
# or the same keyboard layout you chose when you booted into the live usb drive

# because you cant see the passwords when are typing them in so you need to make sure you have the right keyboard layout

# create the user account

# when the installer finshes reboot the mac hold down alt and select the drive marked Windows ( dont worry its the linux drive )

# enter your password for full disk encryption

# then enter your user name and password


#|------------------------------------------------------------------------------
#| update the system after boot up
#|------------------------------------------------------------------------------


# after you log in for the first time update the system

# open the update manager, and then select all update and click apply

#|------------------------------------------------------------------------------
#|	Set up the command key instead of using control
#|------------------------------------------------------------------------------

# In Macs, instead of <Control>+c to copy and <Control>+c to paste, it's <Super>+c and <Super+v>, etc. 

# 1.) In your menu(mintMenu if you use Mint), select Keyboard. This will bring up the keyboard preferences.
# 2.) Go to the Layouts tab and click the Options button. This will now bring up a window with a list of options.
# 3.) Click on 'Alt/Win key behavior' and select 'Control is mapped to Win keys (and the usual Ctrl keys)'.
# 4.) Close that window, and in the Keyboard Preferences window, click 'Apply System-Wide'. Once you have done that, you can close Keyboard Preferences.


# Now the Mac/Win(Super) key should act like the Control key, meaning that you can now copy/paste text using <Super>+c and <Super>+v,
# among any other hotkeys that use the Control key. 
# The control key also still holds the same functionality as it did before


#|------------------------------------------------------------------------------
#|	linux batery life fstab settings ( props to darren at hak5 )
#|------------------------------------------------------------------------------


# back up fstab
sudo cp /etc/fstab{,.backup}

# edit fstab
sudo nano /etc/fstab

# disable last access time
# enable trim, by adding discard

# "noatime,nodiratime,discard" to drive options in /etc/fstab

/dev/mapper/mint-root /					ext4	noatime,nodiratime,discard

# swap disk

#Don't use swap until physical memory is full.
sudo cat /proc/sys/vm/swappiness
sudo echo 0 > /proc/sys/vm/swappiness


#Create RAM disk for temp filesystem

# check memory
df -h

#Find avail for tempfs, now edit /etc/fstab and add

tmpfs /tmp tmpfs defaults,noatime,size=512M,mode=1777 0 0
tmpfs /var/spool tmpfs defaults,noatime,size=512M,mode=1777 0 0
tmpfs /var/tmp tmpfs defaults,noatime,size=512M,mode=1777 0 0
# If you don't care about log files after reboots
tmpfs /var/log tmpfs defaults,noatime,size=512M,mode=0755 0 0
# the mode is the file permission. this is a single user system
# size=512M - size isn't allocated immediately, used as needed


#|------------------------------------------------------------------------------
#| iptables
#|------------------------------------------------------------------------------


# iptables for avahi and shairport speakers

sudo iptables -L

### flush existing rules and set chain policy setting to DROP
sudo iptables -F
sudo iptables -X

###### INPUT chain

### state tracking rules
sudo iptables -A INPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options
sudo iptables -A INPUT -m state --state INVALID -j DROP
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

### ACCEPT rules
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -s 192.168.1.0/24 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 6881 -s 192.168.1.0/24 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 5353 -s 192.168.1.0/24 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 5000:5005 -s 192.168.1.0/24 -j ACCEPT
sudo iptables -A INPUT -p udp -m udp --dport 6000:6005 -s 192.168.1.0/24 -j ACCEPT

###### OUTPUT chain ######

sudo iptables -A OUTPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options
sudo iptables -A OUTPUT -m state --state INVALID -j DROP
sudo iptables -A OUTPUT -o lo -j ACCEPT



##############################################

# save the ip tables, switch to root first
sudo su

iptables-save > /etc/iptables.rules


# resote iptables, switch to root first
sudo su

iptables-restore < /etc/iptables.rules

#|------------------------------------------------------------------------------
#| edit /etc/network/interfaces
#|------------------------------------------------------------------------------

# add pre-up iptables-restore < /etc/iptables.rules 

# Edit the /etc/network/interfaces file to look like this:

# Set up the local loopback interface
auto lo
iface lo inet loopback
pre-up iptables-restore < /etc/iptables.rules


#|------------------------------------------------------------------------------
#| emerging threats iptables and fwsnort install
#|------------------------------------------------------------------------------

# fwsnort and perl modules install
sudo apt-get install fwsnort

# install perl modules
sudo apt-get install libnetaddr-ip-perl

# download the latest emerging threats list
sudo fwsnort --update-rules

# run fwsnort so it picks up the the emerging threats list
sudo fwsnort

# run the generated script to add the emerging threats list to iptables
sudo /var/lib/fwsnort/fwsnort.sh



#|------------------------------------------------------------------------------
#| psad ids install to work with fwsnort and iptables
#|------------------------------------------------------------------------------


# psad ids install to work with fwsnort and iptables
sudo apt-get install psad

# press enter during the install to accept the default options

# select ok on the first screen

# then select local install on the second screen


# edit psad.conf and change the ALERTING_METHODS to noemail
sudo vim /etc/psad/psad.conf

ALERTING_METHODS            noemail;

#|------------------------------------------------------------------------------
#| /etc/sysctl.conf hardening
#|------------------------------------------------------------------------------

# edit /etc/sysctl.conf and the following options

sudo vim /etc/sysctl.conf

#
# /etc/sysctl.conf - Configuration file for setting system variables
# See /etc/sysctl.d/ for additional system variables
# See sysctl.conf (5) for information.
#

#kernel.domainname = example.com

# Uncomment the following to stop low-level messages on console
#kernel.printk = 3 4 1 3

##############################################################3
# Functions previously found in netbase
#

# Uncomment the next two lines to enable Spoof protection (reverse-path filter)
# Turn on Source Address Verification in all interfaces to
# prevent some spoofing attacks
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.rp_filter=1

# Uncomment the next line to enable TCP/IP SYN cookies
# See http://lwn.net/Articles/277146/
# Note: This may impact IPv6 TCP sessions too
net.ipv4.tcp_syncookies=1

# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=0

# Uncomment the next line to enable packet forwarding for IPv6
#  Enabling this option disables Stateless Address Autoconfiguration
#  based on Router Advertisements for this host
#net.ipv6.conf.all.forwarding=1


###################################################################
# Additional settings - these settings can improve the network
# security of the host and prevent against some network attacks
# including spoofing attacks and man in the middle attacks through
# redirection. Some network environments, however, require that these
# settings are disabled so review and enable them as needed.
#
# Do not accept ICMP redirects (prevent MITM attacks)
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_messages = 1
#net.ipv6.conf.all.accept_redirects = 0
# _or_
# Accept ICMP redirects only for gateways listed in our default
# gateway list (enabled by default)
net.ipv4.conf.all.secure_redirects = 0
#
# Do not send ICMP redirects (we are not a router)
net.ipv4.conf.all.send_redirects = 0
#
# Do not accept IP source route packets (we are not a router)
net.ipv4.conf.all.accept_source_route = 0
#net.ipv6.conf.all.accept_source_route = 0
#
# Log Martian Packets
net.ipv4.conf.all.log_martians = 1
#


#|------------------------------------------------------------------------------
#| arpon install to stop arp poisioning
#|------------------------------------------------------------------------------


# arpon install to stop arp poisioning
sudo apt-get install arpon

# edit the arpon config file
sudo nano /etc/default/arpon

# change the arpon config file from this

# For DARPI uncomment the following line
# DAEMON_OPTS="-q -f /var/log/arpon/arpon.log -g -d"

# Modify to RUN="yes" when you are ready
RUN="no"



# change the arpon config file to this
# For DARPI uncomment DAEMON_OPTS
# then change RUN="no" to RUN="yes"


# For DARPI uncomment the following line
DAEMON_OPTS="-q -f /var/log/arpon/arpon.log -g -d"

# Modify to RUN="yes" when you are ready
RUN="yes"


# start arpon
sudo /etc/init.d/arpon start


#|------------------------------------------------------------------------------
#| install hosts file for adblocking from someonewhocares.org
#|------------------------------------------------------------------------------


# download the 0.0.0.0 hosts file from someonewhocares.org

# then edit /etc/hosts and append the contents of the downloading hosts file

gksu gedit /etc/hosts


#|------------------------------------------------------------------------------
#|	change home directory file permissions
#|------------------------------------------------------------------------------


# change the file permissions to remove read and write access for other users

chmod 700 Desktop
chmod 700 Documents
chmod 700 Downloads
chmod 700 Music
chmod 700 Pictures
chmod 700 Templates
chmod 700 Videos

# change permissons on the home directory
chmod 700 /home/username/


#|------------------------------------------------------------------------------
#|	install encfs and dropbox
#|------------------------------------------------------------------------------

# install dropbox
sudo apt-get install nemo-dropbox

# install encfs
sudo apt-get install encfs


# install gnome-encfs-manager 

# Add the following line to your /etc/apt/sources.list:
# deb http://ppa.launchpad.net/gencfsm/ppa/ubuntu precise main

# install
sudo apt-get update && sudo apt-get install gnome-encfs-manager

# create the encrypted directory
encfs ~/Dropbox/Private/.logs ~/Private

# press p for paranoid mode
# then enter your password

# press y to create the ~/Dropbox/Private/.logs directory
# press y to create the ~/Private directory


# open the Gnome Encfs Manager application
# click import stash, select the ~/Dropbox/Private/.logs directory as the stash
# select the ~/Private directory as the mount point


# back up the ~/Dropbox/Private/.logs/.encfs6.xml file
cp ~/Dropbox/Private/.logs/.encfs6.xml ~/Documents/.encfs6.xml

# dropbox exclude the EncFS key .encfs6.xml file
# this will delete the .encfs6.xml file from the dropbox directory
dropbox exclude add ~/Dropbox/Private/.logs/.encfs6.xml

# cp the .encfs6.xml back to ~/Dropbox/Private/.logs/.encfs6.xml
cp ~/Documents/.encfs6.xml ~/Dropbox/Private/.logs/.encfs6.xml

# then keep move the ~/Documents/.encfs6.xml into a truecrypt container as a back up

# Open the Dropbox site and delete the .encrypted/.encfs6.xml file


#|------------------------------------------------------------------------------
#|	install clamav
#|------------------------------------------------------------------------------

# install clamav
sudo apt-get install clamav clamav-daemon clamav-freshclam clamtk

# update freshclam
sudo freshclam

# start clamav daemon
sudo /etc/init.d/clamav-daemon start

#|------------------------------------------------------------------------------
#|  oathtool install for google 2 factor codes
#|------------------------------------------------------------------------------

sudo apt-get install oathtool


#|------------------------------------------------------------------------------
#| install fonts in user directory
#|------------------------------------------------------------------------------


# in your home directory, create .fonts/
mkdir .fonts

# copy font files to the new location

# update your font cache
fc-cache -fv

#|------------------------------------------------------------------------------
#| bash set up
#|------------------------------------------------------------------------------

# copy thes system bash.bashrc to your home directory
sudo cp /etc/bash.bashrc ~/.bashrc

# change file permissions from root to your your username
sudo chown username:username .bashrc

# add .inputrc

# add .vim directory

# add .vimrc

# add .git-prompt

#|------------------------------------------------------------------------------
#| install conky
#|------------------------------------------------------------------------------

sudo apt-get install conky-all

# create ~/.conkyrc
vim ~/.conkyrc

# paste in the following code and save

background no
cpu_avg_samples 2
net_avg_samples 2
out_to_console no
use_xft yes
xftfont Bitstream Vera Sans:size=12
xftalpha 1
on_bottom yes
update_interval 3

own_window_class Conky
own_window yes
own_window_type conky
own_window_transparent yes
own_window_hints undecorated,below,sticky,skip_taskbar,skip_pager
double_buffer yes
draw_shades no
draw_outline no
draw_borders no
draw_graph_borders yes
stippled_borders no
border_margin 4
border_width 1

default_color green
default_shade_color white
default_outline_color black

gap_x 30
gap_y 0
alignment bottom_left
minimum_size 200 5
maximum_width 900

use_spacer no
no_buffers yes
uppercase no
text_buffer_size 2048

TEXT
${color green}RAM Usage:$color $mem/$memmax - $memperc% ${membar 4}
${color green}Swap Usage:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color green}CPU Usage:$color $cpu% ${cpubar 4}
${color green}Processes:$color $processes  ${color green}Running:$color $running_processes
$hr
${color green}File systems:
 / $color${fs_used /}/${fs_size /} ${fs_bar 6 /}


#|------------------------------------------------------------------------------
#| conky autostart file
#|------------------------------------------------------------------------------


# create an autostart file to start conky at login, then paste in the code below
vim .config/autostart/conky.desktop

[Desktop Entry]
Type=Application
Exec=conky
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Conky
Name=Conky
Comment[en_US]=Auto run conky
Comment=Auto run conky.


#|------------------------------------------------------------------------------
#| dotfiles
#|------------------------------------------------------------------------------

# create .dotfiles in home directory if it doesnt already exist
mkdir -p ~/.dotfiles

# files to move to .dotfiles
mv ~/.bashrc ~/.dotfiles
mv ~/.gitconfig ~/.dotfiles
mv ~/.git-prompt.sh ~/.dotfiles
mv ~/.inputrc ~/.dotfiles
mv ~/.profile ~/.dotfiles
mv ~/.vimrc ~/.dotfiles
mv ~/.vim ~/.dotfiles
mv ~/.fonts ~/.dotfiles
mv ~/.conkyrc ~/.dotfiles


# create the symlinks
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.git-prompt.sh ~/.git-prompt.sh
ln -s ~/.dotfiles/.inputrc ~/.inputrc
ln -s ~/.dotfiles/.profile ~/.profile
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.fonts ~/.fonts
ln -s ~/.dotfiles/.conkyrc ~/.conkyrc

# create the git repo in dotfiles
cd ~/.dotfiles

# login to github and create a new git dotfiles repo

# git init repo
git init

# add all the dotfiles
git add .

# add the remote origin
git remote add origin git@github.com:username/dotfiles.git

# push origin master
git push -u origin master


#|------------------------------------------------------------------------------
#|	xbmc install
#|------------------------------------------------------------------------------

#  add xbmc repository
sudo add-apt-repository ppa:team-xbmc/ppa

# apt-get update
sudo apt-get update

# install xbmc
sudo apt-get install xbmc


#|------------------------------------------------------------------------------
#| shairport install
#|------------------------------------------------------------------------------

sudo apt-get install git libao-dev libssl-dev libcrypt-openssl-rsa-perl libio-socket-inet6-perl libwww-perl avahi-utils libmodule-build-perl

# Let this process run for a little while. When it's complete, we need to install an update so Shairport will work with iOS 6 (you can skip this step if you're not on or plan to upgrade iOS 6):

git clone https://github.com/njh/perl-net-sdp.git perl-net-sdp
cd perl-net-sdp
perl Build.PL
sudo ./Build
sudo ./Build test
sudo ./Build install
cd ..

# Once the iOS 6 module is installed (give it a little while), it's finally time to get Shairport installed. from your home directory type:

git clone https://github.com/hendrikw82/shairport.git
cd shairport
sudo make install

# Now, let's run Shairport:

./shairport.pl -a AirPi

# This command starts Shairport with your Raspberry Pi named "AirPi" (you can change it to whatever you want). Grab your iOS device, pick the music app of your choice, and tap the AirPlay button. You should see "AirPi" listed as an output device. Tap that, and the music should start streaming out of your USB sound card within a couple seconds.

# But we're not done yet. Shairport doesn't automatically load when you start your Raspberry Pi, and since we want to make our AirPlay device work without any peripherals we need to do one more step. From your home directory, type:

cd shairport
sudo make install
sudo cp shairport.init.sample /etc/init.d/shairport
cd /etc/init.d
sudo chmod a+x shairport
sudo update-rc.d shairport defaults


# Finally, we need to add Shairport as a launch item. Type:

sudo nano /etc/init.d/shairport

# This loads up Shairport file we need to edit. Look through the file for the # "DAEMON_ARGS" line, and change it so it looks like this:

# DAEMON_ARGS="-w $PIDFILE -a Mint -ao_devicename=plughw:1,0"

DAEMON_ARGS="-w $PIDFILE -a Mint -ao_devicename=plughw:1,0"

# plughw:1,0 is your usb dac



#|------------------------------------------------------------------------------
#| /etc/avahi/avahi-daemon.conf hardening
#|------------------------------------------------------------------------------

# avahi daemon hardening

# edit /etc/avahi/avahi-daemon.conf and add the following options

use-ipv4=yes
use-ipv6=no
check-response-ttl=yes
disallow-other-stacks=yes

# use-ipv6=no dont use ipv6
# Check Responses’ TTL Field, Avahi can be set to ignore IP packets unless their TTL field is 255

# To make Avahi ignore packets unless the TTL field is 255, edit /etc/avahi/avahi-daemon.conf and ensure the following line appears in the [server] section: check-response-ttl=yes

# Avahi can stop other mDNS stacks from running on the host by preventing other processes from binding to port 5353.
# To prevent other mDNS stacks from running, edit /etc/avahi/avahi-daemon.conf and ensure the following line appears in the [server] section: disallow-other-stacks=yes


#|------------------------------------------------------------------------------
#| clementine bit perfect audio with usb dac
#|------------------------------------------------------------------------------

# install Clementine
sudo apt-get install clementine

# open clementine preferences

# select the playback section in the left sidebar and scroll down

# under the GStreamer audio engine change the output plugin and output device

# change the Output plugin to Audio sink (ALSA)

# change the Output device to hw:1,0


# location of mounted network shares
/run/user/username/gvfs

#|------------------------------------------------------------------------------
#|	turn on emacs keyboard bindings for themes
#|------------------------------------------------------------------------------

# open cinnamon settings / themes / other settings

# change keybinding theme to Emacs


#|------------------------------------------------------------------------------
#|	Show location bar in nemo file browser
#|------------------------------------------------------------------------------


# Preferences->Cinnamon Settings->Themes->Other Settings tab

# Check: Always Location Entry in Nemo

# Restart Nemo

#|------------------------------------------------------------------------------
#| chkrootkit and rkhunter to check for rootkits
#|------------------------------------------------------------------------------

# chkrootkit

# install chkrootkit
sudo apt-get install chkrootkit

# run chkrootkit
sudo chkrootkit


# rkhunter

# rkhunter install for finding rootkits
sudo apt-get install rkhunter

# update rkhunter
sudo rkhunter --update

# check for rootkits
sudo rkhunter --check

# update and create dat file for rkhunter
sudo rkhunter --propupd

#|------------------------------------------------------------------------------
#|	tor browser install
#|------------------------------------------------------------------------------

# add tor repository
sudo add-apt-repository ppa:upubuntu-com/tor64

# apt-get update
sudo apt-get update

# install tor
sudo apt-get install tor-browser

# change file permissions on ~/.tor-browser/
sudo chown $USER -R ~/.tor-browser/


#|------------------------------------------------------------------------------
#| truecrypt install
#|------------------------------------------------------------------------------

# truecrypt install
# download the 64 bit tar.gz file from truecrypt
# untar the file and run the script

#|------------------------------------------------------------------------------
#|	applications to install
#|------------------------------------------------------------------------------


# ngrep install to kill tcp connections
sudo apt-get install ngrep

# install keepassx pasword manager
sudo apt-get install keepassx

# install vim
sudo apt-get install vim

# install meld
sudo apt-get install meld

# gparted
sudo apt-get install gparted

# filezilla
sudo apt-get install filezilla

# putty
sudo apt-get install putty

# nmap
sudo apt-get install nmap

# curl 
sudo apt-get install curl

# lynx
sudo apt-get install lynx

# ffmpeg
sudo apt-get install ffmpeg

# mplayer
sudo apt-get install mplayer

# mencoder
sudo apt-get install mencoder

# chromium-browser
sudo apt-get install chromium-browser

# ffmpeg codecs
sudo apt-get install chromium-codecs-ffmpeg-extra

# enviornment to compile c programs
apt-get install glibc-doc manpages-dev libc6-dev gcc build-essential


#|------------------------------------------------------------------------------
#| set up the terminal in linux mint
#|------------------------------------------------------------------------------

# edit the keyboard shortcut for full screen and press cmd + enter
#
# the key combo will show up as super + return


#|------------------------------------------------------------------------------
#| sublime text 2 linux mint install
#|------------------------------------------------------------------------------

# download the 64bit tar.gz sublime text 2

# untar the file
cd Downloads
tar xf Sublime\ Text\ 2.0.1\ x64.tar.bz2


# You’ll get a “Sublime Text 2″ folder after extraction. 
# This folder contains all the files that Sublime Text will need. 
# So we have to move that folder somewhere more appropriate. Like the “/opt/” folder :
sudo mv Sublime\ Text\ 2 /opt/


# Create a symbolic link in “/usr/bin”
sudo ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/bin/sublime

# copy the system applcation defaults.list to "~/.local/share/applications/defaults.list"
sudo cp /usr/share/applications/defaults.list ~/.local/share/applications/defaults.list

# now open "~/.local/share/applications/defaults.list" and find and relace gedit.desktop with sublime.desktop


# Create a desktop launcher. 
# To do this, we’re going to create a .desktop file in “~/.local/share/applications”:
sudo sublime ~/.local/share/applications/sublime.desktop

# paste in the following content
# you need "Exec=sublime %u" for sublime text to show up in the properties window

[Desktop Entry]
Encoding=UTF-8
Name=Sublime Text
Comment=Sublime Text 2
Exec=sublime %u
Icon=/opt/Sublime Text 2/Icon/48x48/sublime_text.png
Terminal=false
Type=Application
Categories=GNOME;GTK;Utility;TextEditor;
StartupNotify=true


# Now you would probably want to open all text files with Sublime Text 2. 
# control click on a file type you want to open with sublime text
# then select properties and the open with tab
# then select sublime text and set as the default app for that file type

# install package control from - http://wbond.net/sublime_packages/package_control

# then install emmet which used to be called zen coding

# install sublime linter 


#|------------------------------------------------------------------------------
#| install google command line tools
#|------------------------------------------------------------------------------

sudo apt-get install googlecl


# conect the google command line tool to your google account

# run google and try to list one of your contacts ( replace name with a name in your contacts )
google contact list name

# you will be prompted to enter you gmail address
# enter your gmail address and press enter
# your web browser will open and you have to log into your gmail account

# you will then be asked to grant access for googlecl 
# you will then be given a verification code you need to paste into the terminal

# paste in the verification code and press return

# this will create a config file in "/home/username/.config/googlecl/config"

# edit the config file and add phone to the fields under contacts
# so you can list phone numbers 

# change from this 

# [CONTACTS]
# fields = name,email

# to this

# [CONTACTS]
# fields = name,email,phone



