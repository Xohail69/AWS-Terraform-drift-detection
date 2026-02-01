# Hands-on Demo: Terraform Drift Detection and Import (AWS S3)

This tutorial guides you through understanding infrastructure drift and how to resolve it using Terraform. We will use a simple AWS S3 bucket example.

## 1. Project Structure

Ensure your project directory `AWS-Terraform-drift-detection` contains the following files:

*   **`main.tf`**: Defines the S3 bucket resource.
*   **`provider.tf`**: Configures the AWS provider.
*   **`variables.tf`**: Variables for region and bucket name.
*   **`outputs.tf`**: Outputs the bucket ID and ARN.
*   **`.gitignore`**: Standard Terraform ignore rules.

## 2. Initial Terraform Code

**`main.tf`**
```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
```

## 3. First Apply

Initialize and apply the Terraform configuration to create the bucket.

```bash
terraform init
terraform apply
```

**Output Snippet:**
```text
Terraform will perform the following actions:
  + resource "aws_s3_bucket" "my_bucket" { ... }
Plan: 1 to add, 0 to change, 0 to destroy.
```

## 4. Manual Change (Simulating Drift)

Now, let's simulate "drift" — when the real-world infrastructure diverges from your Terraform state.

1.  Go to the **AWS Console** > **S3**.
2.  Find your bucket (`drift-detection-demo-bucket-12345`).
3.  Go to **Properties** -> **Tags**.
4.  Add a new tag -> **Key**: `ManualChange`, **Value**: `True`.
5.  Save.

## 5. Drift Detection

Run `terraform plan` to see if Terraform detects the change.

```bash
terraform plan
```

**Output Snippet:**
```text
  ~ resource "aws_s3_bucket" "my_bucket" {
      ~ tags        = {
          - "ManualChange" = "True" -> null
            ...
        }
    }
```

**Explanation:** Terraform sees the extra tag in AWS but not in your code. It plans to **remove** it to make AWS match your code.

## 6. Recovery Approaches

### Approach A: Update Terraform Code (Recommended for valid changes)

If the manual change was intentional, update your `main.tf` to match:

```hcl
resource "aws_s3_bucket" "my_bucket" {
  # ... other args
  tags = {
    Name         = "My bucket"
    Environment  = "Dev"
    ManualChange = "True"  # <--- Add this line
  }
}
```

Now, `terraform plan` will show: `No changes. Your infrastructure matches the configuration.`

### Approach B: Classic Import (CLI Method)

**Best for**: Single, small resources.
**Command**: `terraform import [resource_address] [existing_id]`

**Scenario:** You have an existing bucket `my-manual-bucket` that you want to bring under Terraform control.

1.  **Create minimal block** in `main.tf`:
    ```hcl
    resource "aws_s3_bucket" "imported_bucket" {
      bucket = "my-manual-bucket" 
      # Missing tags/settings!
    }
    ```
2.  **Run Import**: `terraform import aws_s3_bucket.imported_bucket my-manual-bucket`
    *   **CRITICAL**: This *instantly* updates `terraform.tfstate`. Your state now knows about the full bucket, but your code is still empty.
3.  **Check Drift (DANGER)**: Run `terraform plan`.
    *   Terraform will plan to **destroy/replace** or **modify** the bucket to match your empty code block.
4.  **Fix Code**: Update `main.tf` with the missing details until `plan` shows "No changes".

### Approach C: Config-Driven Import (Terraform 1.5+) - Recommended for Bulk

**Best for**: Migrating many resources, safely.
**Command**: `terraform plan -generate-config-out=abc.tf`

**Scenario**: You have legacy buckets to import.

1.  **Create `import.tf`**:
    ```hcl
    import {
      to = aws_s3_bucket.legacy_bucket_1
      id = "my-legacy-bucket-01"
    }
    ```
2.  **Generate Config**:
    ```bash
    terraform plan -generate-config-out=generated.tf
    ```
    *   **Safety**: This does NOT update the state file yet. It reads AWS and writes the code for you into `generated.tf`.
3.  **Review**: Check the generated file.
4.  **Apply**: `terraform apply` to finalize the import and update the state.

## 7. Key Lessons

1.  **Drift** happens when manual changes are made outside of Terraform.
2.  **`terraform plan`** is your safety net—always read it carefully to see what Terraform intends to do (destroy/add/change).
3.  **Classic Import** updates state *immediately*, leaving code out of sync.
4.  **Config-Driven Import** generates code *before* updating state, making it safer and faster.
5.  **Best Practice**: Avoid manual changes. If unavoidable, Import/Sync immediately.
