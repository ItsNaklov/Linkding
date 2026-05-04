# 🔖 Linkding — Self-Hosted Bookmark Manager on Kubernetes

A production-style deployment of [Linkding](https://github.com/sissbruecker/linkding) on a self-hosted K3s Kubernetes cluster, managed with Terraform and automated via a secure CI/CD pipeline using GitHub Actions and Tailscale VPN.

---

## 📐 Architecture

```
┌─────────────────────────────────────────────────────┐
│                   GitHub Actions                     │
│                                                      │
│  push to main                                        │
│       │                                              │
│       ▼                                              │
│  ┌─────────┐    ┌─────────┐    ┌──────────────────┐ │
│  │ Trivy   │───▶│Terraform│───▶│  K3s Homelab     │ │
│  │  Scan   │    │  Apply  │    │  Cluster         │ │
│  └─────────┘    └─────────┘    └──────────────────┘ │
│                      │                               │
│              Tailscale VPN Tunnel                    │
└─────────────────────────────────────────────────────┘
```

---

## 🛠️ Stack

| Layer                  | Tool             | Purpose                                    |
| ---------------------- | ---------------- | ------------------------------------------ |
| Container Runtime      | Docker           | Runs the Linkding container                |
| Orchestration          | Kubernetes (K3s) | Manages deployment, scaling, networking    |
| Infrastructure as Code | Terraform        | Provisions K8s resources declaratively     |
| CI/CD                  | GitHub Actions   | Automates build, scan, and deploy on push  |
| Security Scanning      | Trivy            | Scans Docker image for CVE vulnerabilities |
| Private Networking     | Tailscale        | Securely connects GitHub runner to homelab |

---

## 🔒 Security

- **Trivy** scans the Linkding Docker image for known CVEs on every pipeline run
- **Tailscale OAuth** provides secure, ephemeral access from GitHub Actions to the private homelab cluster — no open ports exposed to the internet
- **Kubernetes Secrets** manage sensitive configuration
- **`.gitignore`** ensures Terraform state and provider binaries are never committed

---

## 🚀 CI/CD Pipeline

Every push to `main` triggers the following pipeline:

```
1. Checkout code
2. Trivy security scan — scans sissbruecker/linkding:latest for vulnerabilities
3. Connect to Tailscale — ephemeral OAuth node joins private network
4. Setup kubeconfig — authenticates with K3s cluster
5. Terraform Init — downloads providers
6. Terraform Plan — shows infrastructure diff
7. Terraform Apply — applies changes to cluster
```

---

## 📁 Project Structure

```
linkding/
├── .github/
│   └── workflows/
│       └── deploy.yml       # GitHub Actions CI/CD pipeline
├── k8s/
│   ├── deployment.yaml      # Kubernetes Deployment manifest
│   └── service.yaml         # Kubernetes Service (NodePort)
├── terraform/
│   └── main.tf              # Terraform — manages namespace, deployment, service
├── .gitignore
└── README.md
```

---

## ⚙️ Deployment

### Prerequisites

- K3s cluster running
- Terraform installed
- kubectl configured

### Manual Deploy

```bash
# Via kubectl
kubectl apply -f k8s/

# Via Terraform
cd terraform/
terraform init
terraform plan
terraform apply
```

### Automated Deploy

Push to `main` branch — GitHub Actions handles the rest.

---

## 🔑 Required GitHub Secrets

| Secret               | Description                               |
| -------------------- | ----------------------------------------- |
| `TS_OAUTH_CLIENT_ID` | Tailscale OAuth client ID                 |
| `TS_OAUTH_SECRET`    | Tailscale OAuth client secret             |
| `KUBECONFIG`         | Kubeconfig file with cluster Tailscale IP |

---

## 📊 Access

| Service     | Port     |
| ----------- | -------- |
| Linkding UI | `:30900` |

---

## 💡 Key Learnings

- Deployed a containerised application to a self-hosted Kubernetes cluster
- Managed Kubernetes infrastructure declaratively with Terraform
- Built a secure CI/CD pipeline with automated security scanning
- Connected a private homelab to GitHub Actions via Tailscale VPN without exposing any ports to the internet
