# Terraform Interview Prep Notes: Drift & Import

## 1. What is "Drift"?
**Definition**: Drift is when your **real-world infrastructure** (AWS/Azure) configuration differs from your **Terraform State** and **Configuration Code**.
*   **Cause**: Someone manually changed a setting (e.g., added a Security Group rule) in the AWS Console.
*   **Detection**: Run `terraform plan`.
    *   If Terraform says "Plan: 0 to add, 1 to change...", it has detected drift.
    *   It will usually try to **undo** the manual change to restore the state defined in code.

## 2. Handling Drift (The "Fix")
*   **Option A (Accept Change)**: If the manual change was good/intentional, **update your Terraform code** (`main.tf`) to match the console change.
*   **Option B (Reject Change)**: If the manual change was bad/accidental, run `terraform apply` to have Terraform **overwrite** (revert) the infrastructure back to the code's definition.

## 3. Terraform Import Strategies (CRITICAL)

### CLI Method (`terraform import`)
*   **Command**: `terraform import aws_s3_bucket.my_bucket existing-bucket-id`
*   **State impact**: Updates `terraform.tfstate` **IMMEDIATELY**.
*   **Code impact**: Does **NOT** generate code. You must write the HCL manually.
*   **Risk**: High. If you import into an empty block and run `apply`, Terraform might destroy/reset the resource because your code is empty.
*   **Workflow**: Import -> Plan (See Errors) -> Fix Code -> Plan -> Apply.

### Config-Driven Method (Terraform 1.5+)
*   **Block**: `import { to = ... id = ... }`
*   **Command**: `terraform plan -generate-config-out=generated.tf`
*   **State impact**: Does **NOT** update state immediately. Only updates on final `apply`.
*   **Code impact**: **Generates HCL code automatically** for you!
*   **Risk**: Low. You get to review the code before the state is locked in.
*   **Workflow**: Write Import Block -> Plan (Generate) -> Review Code -> Apply.

## 4. Important Interview Questions & Answers

**Q: "I ran terraform import but my plan says it will destroy the resource. Why?"**
**A:** Because `terraform import` only updated the state file. Your `main.tf` configuration is likely empty or minimal. Terraform sees the mismatch between "Full State" and "Empty Code" and thinks you want to remove those settings. You must update your code to match the state.

**Q: "How do I move 100 existing resources into Terraform quickly?"**
**A:** Do not use `terraform import` 100 times manually. Use **Config-Driven Import** (Terraform 1.5+). Define 100 `import` blocks (scriptable), then run `terraform plan -generate-config-out=all.tf` to automatically generate the code for all of them at once.

**Q: "What is the difference between terraform refresh and terraform plan?"**
**A:** 
*   `terraform plan` automatically does a refresh first (checks real world), compares it to state/code, and tells you what it *will* do.
*   Drift detection happens during the "refresh" phase of the plan.

## 5. Summary Cheat Sheet
| Action | Affects State? | Generates Code? |
| :--- | :--- | :--- |
| `terraform plan` | No | No |
| `terraform apply` | **Yes** | No |
| `terraform import` (CLI) | **Yes (Immediately)** | No |
| `terraform plan -generate...` | No | **Yes** |
