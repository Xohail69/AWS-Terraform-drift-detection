# AWS Terraform Drift Detection & Import Demo

This project is a hands-on demonstration of managing Infrastructure as Code (IaC) with Terraform, specifically focusing on **Drift Detection**, **Manual Changes**, and **Terraform Import strategies**.

## 🚀 Project Overview

The goal of this project is to simulate real-world DevOps scenarios where:
1.  Infrastructure is deployed via Terraform.
2.  Manual changes (Drift) occur in the AWS Console.
3.  Drift is detected and resolved using recovery strategies.
4.  Existing unmanaged resources are imported into Terraform control.

## 📂 Key Resources

*   **[Hands-on Tutorial](terraform_drift_tutorial.md)**: A step-by-step guide to running this demo, simulating drift, and fixing it.
*   **[Interview Prep Notes](interview_notes.md)**: A summary of key concepts, interview questions, and cheat sheets regarding Terraform state management.

## 🛠 Prerequisites

*   **Terraform**: v1.5.0+ (Recommended for config-driven import)
*   **AWS CLI**: Configured with valid credentials (`aws configure`)
*   **Git**: For version control

## 🏗 Project Structure

```text
.
├── main.tf                    # Main resource definitions (S3 Bucket)
├── provider.tf                # AWS Provider configuration
├── variables.tf               # Project variables (Region, Bucket Name)
├── outputs.tf                 # Output values (Bucket ARN/ID)
├── import.tf                  # Bulk import configuration (Config-Driven Import demo)
├── generated.tf               # Automatically generated code (from import demo)
├── terraform_drift_tutorial.md # Comprehensive Guide
└── interview_notes.md         # Quick reference & Interview Q&A
```

## ⚡ Quick Start

1.  **Initialize Terraform**:
    ```bash
    terraform init
    ```

2.  **Apply Infrastructure**:
    ```bash
    terraform apply
    ```

3.  **Simulate Drift**:
    Go to AWS Console -> S3 -> Add a tag manually.

4.  **Detect Drift**:
    ```bash
    terraform plan
    ```

5.  **Fix Drift**:
    Follow the [Tutorial](terraform_drift_tutorial.md) for detailed recovery steps.

## Licensed
MIT