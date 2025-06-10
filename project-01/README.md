# Project Docker Containers and Monitoring - Internship Report

## 1. Introduction

### 1.1. Project Overview
<!-- Brief description of the project, objectives and importance -->
Docker Containers and Monitoring project is implemented to gain basic knowledge of Container monitoring and logging. This is part of DevOps internship program, focusing on deploying containerized web application (app-glitchbox) on Linux VM with monitoring and alerting.

### 1.2. Scope of Work
- **Timeline:** week 01 
- **Environment:** Production
- **Main Technologies:** Docker, Prometheus, Grafana, Alertmanager

### 1.3. Team Members
- **Intern:** Tai Le
- **Mentor:** Khoi Nguyen
- **Reviewer:** Khoi Nguyen

## 2. Requirements

### 2.1. Requirements Description

#### Primary Requirements:
<!-- Detailed description of the problem to be solved -->
- "Create git repository"
- "Create a Google Cloud account that includes a sub-account (IAM) with full permissions for Mentor"
- "Automatically deploy Glitch Box App, monitoring and alerting (grafana) to containers"
- "Automatically send alert to Discord"
  
### 2.2. Technical Requirements

#### Environment:
- **OS:** Ubuntu 22.04
- **Cloud Provider:** GCP
- **Containerization:** Docker
- **Monitoring:** Prometheus, Grafana, Alertmanager

## 3. Solution Architecture

### 3.1. Solution Overview
The system uses Prometheus, Alertmanager and Grafana to ensure Monitoring, Alerting and Visualization.

#### Architecture Diagram:
<!-- Use Mermaid diagrams for better visualization -->
```mermaid
flowchart TD
    subgraph GCP["GCP VM"]
        subgraph Docker["Docker Environment"]
            GB[Glitch Box App\nChaosBlade] -->|Metrics| CA[cAdvisor]
            CA -->|Container Metrics| P[Prometheus]
            P -->|Alerts| AM[Alertmanager]
            AM -->|Webhook| AWA[Alert-webhook-adapter]
            AWA -->|Formatted Alert| Discord[(Discord)]
            P -->|Metrics| G[Grafana]
            G -.->|Query| P
        end
        DC[docker-compose.yml] -->|Deploys| Docker
    end
    
    GitHub[(GitHub)] -->|Pull| DC
```

### 3.2. Main Components

#### Monitoring & Alerting:
- **Monitoring:** Prometheus, Grafana
- **Alerting:** AlertManager

## 4. Implementation Guide

### 4.1. Related Files/Scripts

#### Repository Structure:
```
project-01/
├── glitchbox-app/           # App deployment
│   ├── Dockerfile
│   ├── docker-compose.yml
|   └── entrypoint.sh
├── monitoring/              # Monitoring tool deployment
│   ├── .env
|   ├── alert-template.tmpl   
│   ├── alertmanager.yml
│   ├── alerts.yml
|   ├── docker-compose.yml
|   └── prometheus.yml
```

#### Key Files:
- **Dockerfile:** Install ChaosBlade app
- **glitchbox-app/docker-compose.yml:** Build Glitchbox App from Dockerfile with "healthcheck" enabled
- **monitoring/docker-compose.yml:** Build necessary tool from available images

### 4.2. Initial Setup

#### Cloud Deployment Steps
1. **Create a GCP VM instance:**
- First, access the link below: https://console.cloud.google.com/
- Go to Computer Engine => VM instances => Create instances.
- Then you just need to configure the VM according to your usage needs, then click create and you're done.

2. **Configure Firewall:**
- Go to Google Cloud Console: https://console.cloud.google.com/
- Go to “VPC network” → “Firewall rules”
- Click “Create Firewall Rule”:
- Name: Give the rule a name (e.g. allow-prometheus-grafana)
- Network: Select the VPC network that contains your instance
- Targets: Select “All instances in the network” or “Specified target tags” if you want to apply only to instances with certain tags.
- Source IP ranges: Leave the default at 0.0.0.0/0 to allow from everywhere, or limit it to your liking.
- Protocols and ports: Select “Specified protocols and ports”, tick TCP and enter: 9090,4000
- Click “Create” to save the rule.

3. **Connect to VM with SSH:**
- On your PC, type ssh-keygen -t rsa -f <LOCATION> -C <USERNAME>
- In the Google Cloud console, go to the Metadata page.
- Click the SSH keys tab.
- Click Edit.
- Click Add item.
- In the SSH key field that opens, add your public SSH key.
- Click Save.
- Back to your PC and open terminal, then type ssh =i <LOCATION> <USERNAME>@<VM-EXTERNAL-IP>

#### Prerequisites:
```bash
# Set up Docker's apt repository

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

#Install the Docker packages.
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

#### Configuration Steps:
1. **Clone repository:**
   ```bash
   #You will need to create a token on github and enter it in the password field when cloning the repository.
   git clone https://github.com/Qu11et/Yoong-DevOps-Project-01.git

   #save the token so you don't have to re-enter it every time you execute git command
   git config --global credential.helper cache
   
   cd Yoong-DevOps-Intern-Projects/project-01
   ```

2. **Run docker compose**
   ```bash
   #Added user into docker group
   sudo usermod -aG docker $USER
   
   cd glitchbox-app
   docker compose build
   docker compose up -d
   cd ../
   
   cd monitoring
   docker compose build
   docker compose up -d
   cd ../

   #Check containers status
   docker ps
   docker logs glitchbox
   ```

3. **Access the Grafana dashboard**
  Finally, go to your browser, enter [vm's external IP]:4000
   

### 4.3. Configuration Variables

#### Environment Variables:
| Variable | Description | Example | Required |
|----------|-------------|---------|----------|
| `DISCORD_WEBHOOK_URL` | Discord Webhook URL | `https://discord.com/api/webhooks/0000/xxxxxxxxx` | Yes |
| `GRAFANA_PORT` | Grafana's exposed port | `xxxx` | Yes |
| `PROMETHEUS_PORT` | Prometheus's exposed port | `xxxx` | Yes |

#### Metrics Dashboard:
![image](https://github.com/user-attachments/assets/d2f4f2b1-0c97-4d6e-b147-8858ac695faa)


## 5. Appendix

### 5.1. Tools Used
| Tool | Version | Purpose | Documentation |
|------|---------|---------|---------------|
| Docker       | 24.0+ | Containerization | https://docs.docker.com                         |
| Prometheus   | 2.55+ | Monitoring       | https://prometheus.io                           |
| cAdvisor     | 0.51+ | Monitoring       | https://github.com/google/cadvisor              |
| Grafana      | 11.3+ | Visualization    | https://grafana.com                             |
| AlertManager | 0.27+ | Alerting         | https://github.com/prometheus/alertmanager      |
| AlertManager-Discord | - | Alerting     | https://github.com/benjojo/alertmanager-discord |

### 5.2. References
- https://aakibkhan1.medium.com/project-10-deployment-of-application-using-github-actions-c56dd92c3779
- https://viblo.asia/p/giam-sat-ung-dung-docker-voi-cadvisor-prometheus-va-grafana-RQqKLevMZ7z
- https://cloud.google.com/compute/docs/
