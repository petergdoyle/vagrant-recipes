
virtualbox_machine_name='CentOS-7-x86_64-Minimal-1511'
vagrant_box_name=$virtualbox_machine_name

mkdir $vagrant_box_name
cd $vagrant_box_name

vagrant box remove $vagrant_box_name \
&& vagrant package --base $virtualbox_machine_name \
&& vagrant box add $vagrant_box_name package.box \
&& vagrant init  $vagrant_box_name

cd -
