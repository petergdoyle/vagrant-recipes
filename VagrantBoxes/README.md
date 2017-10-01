
#Create CentOS-7 Vagrant VirtualBox box

####Using Virtualbox Install CentOS-7 minimal iso and run the install from VirtualBox
#####Download the CentOS-7-x86_64-Minimal-1511.iso from https://www.centos.org/download/ or from a mirror site http://mirrors.oit.uci.edu/centos/7.2.1511/ 
#####Install VirtualBox and Download the Virtualbox Guest-Additions http://download.virtualbox.org/virtualbox/5.1.8/ 
or locate them on your system and link the iso to a symlink in this directory```/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso```


```bash
Peters-MBP:VagrantBoxes peter$ ll
total 1472\

drwxr-xr-x  3 peter  staff   102B Oct 30 03:16 CentOS-7-x86_64-Minimal-1511
drwxr-xr-x  5 peter  staff   170B Aug 23 21:52 CentOS-7-x86_64-Minimal-1511.1
drwxr-xr-x  3 peter  staff   102B Oct 27 06:33 CentOS-7-x86_64-Minimal-1511.2
-rw-r--r--  1 peter  staff   8.2K Oct 30 03:39 README.md
lrwxr-xr-x  1 peter  staff    66B Oct 11 10:07 VBoxGuestAdditions.iso -> /Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso
-rw-r--r--@ 1 peter  staff   332K Oct 30 03:37 create_vm_virtualbox.png
-rw-r--r--@ 1 peter  staff    56K Oct 27 06:12 mount_device_run_guest_additions.png
drwxr-xr-x  4 peter  staff   136B Aug 23 23:28 test
drwxr-xr-x  4 peter  staff   136B Oct 27 08:46 test.latest
-rwxr-xr-x  1 peter  staff   329B Aug 23 21:48 vagrant_create_box.sh
-rwxr-xr-x  1 peter  staff   226B Aug 23 21:42 vagrant_destroy_box.sh
-rw-r--r--@ 1 peter  staff    51K Oct 27 06:15 view_device_list.png
-rw-r--r--@ 1 peter  staff   263K Oct 27 06:13 view_devices_attached_to_vm.png
```

##### Create the VM using VirtualBox
![create_vm_virtualbox](create_vm_virtualbox.png)
- Take defualts for System, Display, Network
- Disable Audio, USB, Bluetooth
- ***Note: be sure to click network and set it to turn on automatically during the setup or you won't be able to run yum***

#####Mount the GuestAdditions iso
![mount_guest_addition](mount_guest_additions.png)

**Note:** when you need to mount and run the GuestAdditions (later) from within the vm, these devices will usually show up as devices under ```/dev``` as ```/dev/sr*```. So if there are three devices here then there would be a ```/dev/sr0```, ```/dev/sr1```, and ```/dev/sr2```. If you remove or add devices, then this ```/dev/sr*``` assignment will vary. 


####Install the VM using the CentOS Installation GUI run from Virtialbox 
While you are walking through the installation you need to do the following:
- set up the root password as 'vagrant'
- set up the vagrant user as 'administrator' and set password to vagrant
- ####turn on networking!


####Once the VM is created and rebooted then log in and make the following changes:

***change the vagrant user's .bash_profile to cd into the /vagrant mount to save the inconvenience of doing that manually after each shell login***
```bash
cat >>/home/vagrant/.bash_profile <<-EOF
cd /vagrant
EOF
```


***run all this as root (see step on clearing history below or you will have to clear root and vagrant history)***


```bash
[vagrant@localhost ~]#$ su - 
[root@localhost ~]# yum install -y epel-release dkms
[root@localhost ~]# yum groupinstall -y "Development Tools"
[root@localhost ~]# yum install -y kernel-devel
[root@localhost ~]# yum install -y vim net-tools htop wget tree unzip bash-completion telnet apg #plus any others
[root@localhost ~]# yum -y update
[root@localhost ~]# yum clean all
```

### Set up the vagrant default keys for auto ssh login
```bash
[root@localhost ~]# mkdir -p /home/vagrant/.ssh
[root@localhost ~]# chmod 0700 /home/vagrant/.ssh
[root@localhost ~]# curl --insecure -L -o /home/vagrant/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
[root@localhost ~]# chmod 0600 /home/vagrant/.ssh/authorized_keys
[root@localhost ~]# chown -R vagrant /home/vagrant/.ssh
```

#####Disable selinux - ***caution***, disabling SELinux makes your system vulnerable to security attacks. Disabling SELinux will resolve many frustrating problems that occur when SELinux is enabled.

Modify the /etc/selinux/config file for permanent disablement
```bash
[root@localhost ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```
#####Modify the /etc/sudoers file
Replace Defaults requiretty by Defaults !requiretty in your /etc/sudoers. This will impact your global  configuration.
```bash
[root@localhost ~]# sed -i 's/Defaults requiretty/Defaults !requiretty/g' /etc/sudoers
```
Use visudo and add the following to the end of the file ```%wheel  ALL=(ALL)       NOPASSWD: ALL```. This gives members of the wheel group non-password access to the sudo commands 
```bash
[root@localhost ~]# visudo #...
```
If that doesn't work, make sure the vagrant user is part of the wheel group

```bash
[root@localhost ~]# usermod -aG wheeel vagrant
```

####Install VirtualBox Guest Additions manually (since this is a non-gui based minimal CentOS-7 installation)

You have to mount the VirtualBox Guest Additions using Vagrant. These can be located in the appropropriate VirtualBox location depending on the host OS or can be downloaded from [here](). Once device is mounted, then you can see the order - these usually end up being associated with an sr* device on the host. So in this case the VirtualBox Guest Additions end up being mounted second -so the associated device on the CentOS vm will be sr1.

![view_devices_attached_to_vm](view_devices_attached_to_vm.png)

![install_vb_guest_additions](install_vb_guest_additions.png)
```bash
[root@localhost ~]# mkdir -p /media/cdrom
[root@localhost ~]# mount /dev/sr1 (or /dev/sr0,sr2,etc whichever order the devices were listed where the iso was mounted on the host) /media/cdrom
[root@localhost ~]# cd /media/cdrom
[root@localhost ~]# ./VBoxLinuxAdditions.run
```

 #####“zero out” the drive
**make sure the sync commands get run** Reference comments: https://blog.engineyard.com/2014/building-a-vagrant-box to avoid issues regarding out of volume space. 
```bash
[root@localhost ~]# dd if=/dev/zero of=/EMPTY bs=1M && sync && rm -f /EMPTY && sync
```

#####Remove history root (and vagrant if you used vagrant and  commands)
```bash
[root@localhost ~]# cat /dev/null > ~/.bash_history && history -c && shutdown -h now
```

###Package the box
Refernece: https://blog.engineyard.com/2014/building-a-vagrant-box 
```bash
Peters-MBP:VagrantBoxes peter$ virtualbox_machine_name='CentOS-7-x86_64-Minimal-1511'
Peters-MBP:VagrantBoxes peter$ vagrant_box_name=$virtualbox_machine_name
Peters-MBP:VagrantBoxes peter$ mkdir $vagrant_box_name
Peters-MBP:VagrantBoxes peter$ cd $vagrant_box_name
Peters-MBP:CentOS-7-x86_64-Minimal-1511 peter$ vagrant package --base $virtualbox_machine_name
```
###Add the box (locally)
```bash
Peters-MBP:CentOS-7-x86_64-Minimal-1511 peter$ vagrant box add $vagrant_box_name package.box
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'CentOS-7-x86_64-Minimal-1511' (v0) for provider: 
    box: Unpacking necessary files from: file:///Users/peter/vagrant/vagrant-recipes/VagrantBoxes/CentOS-7-x86_64-Minimal-1511/package.box
==> box: Successfully added box 'CentOS-7-x86_64-Minimal-1511' (v0) for 'virtualbox'!
```

###Test the box
```bash
Peters-MBP:CentOS-7-x86_64-Minimal-1511 peter$ cd ..
Peters-MBP:VagrantBoxes peter$ mkdir test && cd test
Peters-MBP:test peter$ vagrant init $vagrant_box_name
```

###Workarounds to known bugs
If there are issues related to not being able to Authenticate during startup, add this to the generated Vagrantfile if you are having problems with the old ```default: Warning: Authentication failure. Retrying...``` loop error. See issues and frustrations outlined [here](https://github.com/mitchellh/vagrant/issues/5186)

Modify Vagrantfile skip ```ssh.insert.key```
```ruby
  ...
  config.vm.box = "CentOS-7-x86_64-Minimal-1511" #(auto-generated)
  config.ssh.insert_key = false #(add this line)
  ...
```

###Bring up the machine
```bash
Peters-MBP:test peter$ vagrant up
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
###ssh into the machine and change passwords for vagrant and root
```bash
Peters-MBP:test peter$ vagrant ssh
Last login: Tue Aug 23 17:50:31 2016
[vagrant@localhost ~]$ apg -m 15
```

##Upload the Box
If you are uploading the box to Vagrant Cloud (formerly Atlas), then create a new box there or add a new release. It doesn't have to be uploaded there but if you plan on uploading and sharing the box then you need to change the ```config.vm.box``` to specify the uploaded on there with the correct namespaced version. This would change depending on local or namespaced versions (pulled from Vagrant Cloud).
```ruby
  ...
  config.vm.box = "CentOS-7-x86_64-Minimal-1511" # (local)
  config.vm.box = "petergdoyle/CentOS-7-x86_64-Minimal-1511" # (from Cloud)
  ...
```

```bash
$ vagrant ssh
Last login: Tue Aug 23 17:50:31 2016
[vagrant@localhost ~]$ apg -m 15
```

##General Usage of the Box
If you have the box pulled locally (you would unless you removed it before you uploaded), then you need to update it. When you create a new vm and the local box hasn't been updated yet you will see the following when you bring the box up ```A newer version of the box 'petergdoyle/CentOS-7-x86_64-Minimal-1511' is available! You currently
==> default: have version '0.0.1'. The latest is version '0.0.2'. Run `vagrant box update` to update.```

```bash
Peters-MBP:test peter$ vagrant init petergdoyle/CentOS-7-x86_64-Minimal-1511; vagrant up --provider virtualbox
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'petergdoyle/CentOS-7-x86_64-Minimal-1511'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'petergdoyle/CentOS-7-x86_64-Minimal-1511' is up to date...
==> default: A newer version of the box 'petergdoyle/CentOS-7-x86_64-Minimal-1511' is available! You currently
==> default: have version '0.0.1'. The latest is version '0.0.2'. Run
==> default: `vagrant box update` to update.
==> default: Setting the name of the VM: testlatest_default_1477579584986_67383
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
```

##Update the box
If you create multiple versions of the box then you will need to update local copies of the box. 
```bash
Peters-MBP:test peter$ vagrant box update
==> default: Checking for updates to 'petergdoyle/CentOS-7-x86_64-Minimal-1511'
    default: Latest installed version: 0.0.1
    default: Version constraints: 
    default: Provider: virtualbox
==> default: Updating 'petergdoyle/CentOS-7-x86_64-Minimal-1511' with provider 'virtualbox' from version
==> default: '0.0.1' to '0.0.2'...
==> default: Loading metadata for box 'https://atlas.hashicorp.com/petergdoyle/CentOS-7-x86_64-Minimal-1511?access_token=fYyD3dDKBJTFuw.atlasv1.dkuebkpL0uQtvft9tFLbKxakMz0Mj5thh2A9fNhmvOTheJNtbb2Vnb1H2NRonIhPAAo'
==> default: Adding box 'petergdoyle/CentOS-7-x86_64-Minimal-1511' (v0.0.2) for provider: virtualbox
    default: Downloading: https://atlas.hashicorp.com/petergdoyle/boxes/CentOS-7-x86_64-Minimal-1511/versions/0.0.2/providers/virtualbox.box
==> default: Box download is resuming from prior download progress
 
```


