# CI/CD Pipeline with DevSecOps

This repository demonstrates a complete **CI/CD pipeline** integrated with **DevSecOps** practices using GitHub Actions. It covers Infrastructure as Code (IaC), SAST, DAST, container security scanning, and automated deployment.

---

## Pipeline Overview

The workflow is split into two parts:

1. **CI Pipeline** – triggered on push to `dev` branch or pull requests  
2. **CD Pipeline** – triggered on push to main branch or pull requests 

---

## CI Pipeline

The CI workflow handles:

- **Terraform deployments**  
- **Docker image build and push to AWS ECR**  
- **Security scans**:
  - **SAST**: SonarCloud  
  - **IaC scan**: Checkov  
  - **Container scan**: Trivy  
  - **DAST**: OWASP ZAP  

### Workflow Steps

1. **Checkout Repository** – fetches full history  
2. **Set Up Build Tools** – Docker Buildx, Terraform CLI  
3. **Configure AWS Credentials** – assumes IAM role for deployments  
4. **Terraform** – `init` and `apply` to provision resources  
5. **Build and Push Docker Image** – tags and pushes to ECR  
6. **SAST: SonarCloud Scan** – analyzes code quality and vulnerabilities  
7. **IaC Scan: Checkov** – checks Terraform for misconfigurations  
8. **Container Scan: Trivy** – scans Docker image for vulnerabilities  
9. **DAST: OWASP ZAP** – scans the running app for runtime security issues  
10. **Upload Reports** – Trivy and ZAP reports are uploaded as artifacts  

---

## CD Pipeline

The CD workflow runs **only if the CI pipeline completes successfully**. It performs:

- Pulling the Docker image from **AWS ECR**  
- Running the container on a target host  
- Verifying that the container is running  

### Workflow Steps

1. **Checkout Repository** – ensures local context for deployment scripts  
2. **Configure AWS Credentials** – for ECR access and container deployment  
3. **Login to Amazon ECR** – required for `docker pull`  
4. **Pull Docker Image** – fetches the CI-built image from ECR  
5. **Run Docker Container** – launches the application on port `8080`  
6. **Verify Container** – confirms the container is running  

---

## Security Scans Included

| Scan Type | Tool | Purpose |
|-----------|------|---------|
| SAST | SonarCloud | Detect code-level vulnerabilities and quality issues |
| IaC Scan | Checkov | Ensure Terraform infrastructure is secure |
| Container Scan | Trivy | Scan Docker images for vulnerabilities |
| DAST | OWASP ZAP | Detect runtime application security issues |

---

## Folder Structure

.
├── .github/workflows/ci-cd-devsecops.yml # CI pipeline
├── .github/workflows/cd-pipeline.yml # CD pipeline
├── Dockerfile
├── terraform/
├── src/
├── zap_reports/ # OWASP ZAP scan reports
└── trivy-report.json # Trivy scan report

---

## How to Use

1. Push changes to the `main` branch or open a pull request.  
2. CI pipeline runs automatically, performing builds, deployments, and security scans.  
3. If CI succeeds, the CD pipeline triggers to deploy the container.  
4. Security reports are available in the **Artifacts** section of the workflow run.  

---

## Notes

- Ensure your app listens on port `8080` for DAST scans and container deployment.  
- ZAP and Trivy reports are uploaded to GitHub Actions as artifacts for auditing.  
- IAM roles must allow Terraform, ECR, and container deployment actions.  
- `IMAGE_TAG` can be set to `latest` or a commit SHA for immutable deployments.  

---

## References

- [OWASP ZAP Baseline Scan](https://www.zaproxy.org/docs/docker/baseline-scan/)  
- [Trivy Container Scanning](https://github.com/aquasecurity/trivy)  
- [Checkov Terraform Security](https://www.checkov.io/)  
- [SonarCloud GitHub Action](https://github.com/SonarSource/sonarqube-scan-action)  
- [AWS ECR GitHub Action](https://github.com/aws-actions/amazon-ecr-login)

Author - Kwabena Boakye