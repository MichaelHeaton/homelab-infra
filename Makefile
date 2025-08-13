ENV ?= core
TF  = terraform
TFDIR = terraform/envs/$(ENV)

.PHONY: init plan apply fmt validate clean

init:
	$(TF) -chdir=$(TFDIR) init -upgrade

plan: fmt validate
	$(TF) -chdir=$(TFDIR) plan

apply:
	$(TF) -chdir=$(TFDIR) apply -auto-approve

fmt:
	$(TF) fmt -recursive

validate:
	$(TF) -chdir=$(TFDIR) validate

clean:
	rm -rf $(TFDIR)/.terraform $(TFDIR)/.terraform.lock.hcl
