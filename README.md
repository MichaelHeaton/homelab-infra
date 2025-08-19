# homelab-infra

Infrastructure‑as‑Code for a UniFi‑based homelab. Organized around **environments** (core/dev/prod/rv) and **reusable modules**.

## Quick start

```bash
# preferred: Makefile wrappers
make -C terraform/envs/&lt;env&gt;/unifi plan  VARS=../secrets/&lt;env&gt;.auto.tfvars
make -C terraform/envs/&lt;env&gt;/unifi apply VARS=../secrets/&lt;env&gt;.auto.tfvars

# fallback: raw Terraform
terraform -chdir=terraform/envs/&lt;env&gt;/unifi init
terraform -chdir=terraform/envs/&lt;env&gt;/unifi plan  -var-file=../secrets/&lt;env&gt;.auto.tfvars
terraform -chdir=terraform/envs/&lt;env&gt;/unifi apply -var-file=../secrets/&lt;env&gt;.auto.tfvars
```

## Docs

- **Runbooks:** see [docs/runbooks](docs/runbooks)

Regenerate the docs index: `./patch.sh docs:index`

## Conventions

- All commits are **SSH‑signed** and verified in CI.
- PRs must pass Terraform formatting and validation checks.
- Secrets live in `terraform/envs/*/secrets/` (git‑ignored). Only `.gitkeep` is tracked.

## License

See [LICENSE](LICENSE).
