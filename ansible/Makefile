playbook ?=
task     ?=
debug    ?=
vars     ?=

args :=--diff --verbose --extra-vars @secrets.yaml

ifneq ($(task),)
args +=--start-at-task="$(task)"
endif

ifneq ($(vars),) # e.g. vars='supabase_clone_confirm=true'
args +=--extra-vars "$(vars)"
endif

ifneq ($(debug),) # an extra level
args +=-vvvvv
endif

prepare:
	ansible-galaxy collection install --requirements-file=./requirements.yaml

check: 
	ansible-playbook --check $(args) $(playbook)

apply: 
	ansible-playbook $(args) $(playbook)
