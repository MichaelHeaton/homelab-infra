# Runbook: &lt;short title&gt;

## Purpose
What operational task this covers.

## Preconditions
- Auth to the UniFi controller
- Correct `../secrets/*.auto.tfvars` in place

## Steps
1. Checkout a new branch
2. Edit the relevant env root under `terraform/envs/<env>/unifi`
3. `terraform -chdir=terraform/envs/<env>/unifi plan -var-file=../secrets/<env>.auto.tfvars`
4. Open a PR; ensure CI passes and required checks are green
5. Merge; apply if not done in CI

## Rollback
Revert the PR and re‑apply the previous state.
