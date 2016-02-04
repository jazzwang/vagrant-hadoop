all:	up halt clean box import destroy
up:
	vagrant up
halt:
	vagrant halt
box:
	vagrant package --base cm5-base --output cm5-base.box
import:
	vagrant box add -f --name jazzwang/cm5-base cm5-base.box
destroy:
	vagrant destroy -f
status:
	vagrant status
clean:
	rm -f cm5-base.box cm5-base.log
purge:
	vagrant box remove jazzwang/cm5-base
