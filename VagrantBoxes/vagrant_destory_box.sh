
virtualbox_machine_name='CentOS-7-x86_64-Minimal-1511'

vagrant box remove $vagrant_box_name -f

cd $virtualbox_machine_name

vagrant destroy -f
rm -fr .vagrant/ Vagrantfile package.box

cd -

rm -fr $virtualbox_machine_name
