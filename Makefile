dry_run ?= true

ansible_args = $(if $(dry_run) == true, --check) --diff --verbose 
ansible_args += --extra-vars @ansible/secrets.yaml

apply-site:
	ansible-playbook $(ansible_args) ansible/site.yaml

apply-wheatley:
	ansible-playbook $(ansible_args) ansible/playbooks/bootstrap-wheatley/main.yaml

apply-glados:
	ansible-playbook $(ansible_args) ansible/playbooks/bootstrap-glados/main.yaml

apply-gman:
	ansible-playbook $(ansible_args) ansible/playbooks/bootstrap-gman/main.yaml
