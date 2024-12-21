playbook ?= ""
task     ?= ""

args := --diff --verbose --extra-vars @secrets.yaml
args += $(if $(task) != "",--start-at-task=$(task))

prepare:
	ansible-galaxy collection install --requirements-file=./requirements.yaml

check: 
	ansible-playbook --check $(args) $(playbook)

apply: 
	ansible-playbook $(args) $(playbook)
