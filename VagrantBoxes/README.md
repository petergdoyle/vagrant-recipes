
#Create CentOS-7 Vagrant VirtualBox box

install CentOS-7 minimal iso and run the install from VirtualBox
pic pic pic

***be sure to click network and set it to turn on automatically during the setup or you won't be able to run yum***
- set up the root password as 'vagrant'
- set up the vagrant user as 'administrator' and set password to vagrant
- set up sudoers file by running visudo and make sure you add this to the last line of the file

***run all this as root (see step on clearing history below or you will have to clear root and vagrant history)***

```bash
$ yum install -y epel-release dkms
$ yum groupinstall -y "Development Tools"
$ yum install -y kernel-devel
$ yum install -y vim net-tools htop wget tree unzip bash-completion telnet #plus any others
$ yum -y update
```

### Set up the vagrant default keys for auto ssh login
```bash
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
curl --insecure -L -o /home/vagrant/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
```

Disable selinux - ***caution***, disabling SELinux makes your system vulnerable to security attacks. Disabling SELinux will resolve many frustrating problems that occur when SELinux is enabled.

Modify the /etc/selinux/config file for permanent disablement
```bash
$ sed -i 's/SELINUX=enforcing/SELINUX=disabled/g'
```
While you are in the /etc/sudoers file, you need to turn another security feature off...
Replace Defaults requiretty by Defaults !requiretty in your /etc/sudoers. This will impact your global sudo configuration.
```bash
$ sed -i 's/Defaults requiretty/Defaults !requiretty/g'
```

Install VirtualBox Guest Additions manually (since this is a non-gui based minimal CentOS-7 installation)
Use the VirtualBox Settings for the new vm and go into the Controller IDE and add a cd rom drive
pic pic
and map it to /Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso (for Mac OSX)
you may have to create a symlink to this file for access
then
```bash
$ mkdir -p /media/cdrom
$ mount /dev/sr0 (or /dev/sr1,sr2,etc whichever order the devices were listed where the iso was mounted on the host) /media/cdrom
$ cd /media/cdrom
$ ./VBoxLinuxAdditions.run
```

 “zero out” the drive
```bash
$ sudo dd if=/dev/zero of=/EMPTY bs=1M
$ sudo rm -f /EMPTY
```

###Remove history root (and vagrant if you used vagrant and sudo commands)
```bash
cat /dev/null > ~/.bash_history && history -c && shutdown -h now
```

###Package the box
```bash
$ virtualbox_machine_name='CentOS-7-x86_64-Minimal-1511'
$ vagrant_box_name=$virtualbox_machine_name
$ vagrant package --base $virtualbox_machine_name
$ mkdir $vagrant_box_name
$ cd $vagrant_box_name
```
###Add the box (locally)
```bash
$ vagrant box add $vagrant_box_name package.box
```

###Initialize the box
```bash
$ vagrant init $vagrant_box_name
```

###Workarounds to known bugs
maybe add this to the generated Vagrantfile if you are having problems with the old ```default: Warning: Authentication failure. Retrying...``` loop error

Modify Vagrantfile skip ```ssh.insert.key```
```ruby
  ...
  config.vm.box = "CentOS-7-x86_64-Minimal-1511" #(auto-generated)
  config.ssh.insert_key = false #(add this line)
  ...
```

###Bring up the machine
```bash
$ cd $vagrant_box_name
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'CentOS-7-x86_64-Minimal-1511'...
==> default: Matching MAC address for NAT networking...
==> default: Setting the name of the VM: CentOS-7-x86_64-Minimal-1511_default_1472010828962_70844
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Remote connection disconnect. Retrying...
==> default: Machine booted and ready!
GuestAdditions 5.0.26 running --- OK.
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => /Users/peter/VagrantBoxes/CentOS-7-x86_64-Minimal-1511
```
###ssh into the machine
```bash
$ vagrant ssh
Last login: Tue Aug 23 17:50:31 2016
[vagrant@localhost ~]$
```
