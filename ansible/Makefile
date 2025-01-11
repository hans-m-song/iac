playbook ?=
task     ?=
debug    ?=

args :=--diff --verbose --extra-vars @secrets.yaml

ifneq ($(task),)
args +=--start-at-task="$(task)"
endif

ifneq ($(debug),) # an extra level
args +=--verbose
endif

prepare:
	ansible-galaxy collection install --requirements-file=./requirements.yaml

check: 
	ansible-playbook --check $(args) $(playbook)

apply: 
	ansible-playbook $(args) $(playbook)
