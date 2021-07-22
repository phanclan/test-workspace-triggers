on:
  push:
    branches:
      - main
    paths:
      - '${path}'
  pull_request:
    paths:
      - '${path}'

defaults:
  run:
    shell: bash

jobs:
  hello_world_job:
    runs-on: ubuntu-latest
    name: Terraform Plan Apply
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
      - name: Install and Setup Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 0.14.0
          cli_config_credentials_token: $${{ secrets.TF_API_TOKEN }}
      - name: Terraform Format Init Validate
        id: foo
        uses: ./.github/actions/terraform-workflow # actions/hello-world-composite-run-steps-action@v1
#        uses: actions/hello-world-composite-run-steps-action@v1
        with:
          working-directory: '${working_directory}'
          who-to-greet: 'Mona the Octocats'
      - run: echo random-number $${{ steps.foo.outputs.random-number }}
      - name: Terraform Plan
        id: plan
        if: github.event_name == 'pull_request'
        run: terraform plan -no-color -input=false
        working-directory: '${working_directory}'
        continue-on-error: true
      - uses: actions/github-script@0.9.0
        if: github.event_name == 'pull_request'
        env:
          PLAN: "terraform\n$${{ steps.plan.outputs.stdout }}"
        with:
          github-token: $${{ secrets.GITHUB_TOKEN }}
          script: |
            const output = `#### Terraform Format and Style 🖌\`$${{ steps.foo.outputs.fmt }}\`
            #### Terraform Initialization ⚙️\`$${{ steps.init.outcome }}\`
            #### Terraform Validation 🤖\`$${{ steps.validate.outcome }}\`
            #### Terraform Plan 📖\`$${{ steps.plan.outcome }}\`

            <details><summary>Show Plan</summary>

            \`\`\`\n
            $${process.env.PLAN}
            \`\`\`

            </details>

            *Pusher: @$${{ github.actor }}, Action: \`$${{ github.event_name }}\`*`;

            github.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: output
            })
      - name: Terraform Plan Status
        if: steps.plan.outcome == 'failure'
        run: exit 1
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: terraform apply -auto-approve -input=false
        working-directory: '${working_directory}'
