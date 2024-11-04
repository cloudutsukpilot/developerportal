# Developer Portal Deployment

## Azure

### Azure Kubernetes Services

1. **Multi-Tenancy**
- Cluster Isolation
    + Multi-Tenancy Core Components
    + Logical Isolation with Namespaces
- Scheduler Features
    + Resource Quotas
    + Pod Disruption Budgets
- Advanced Scheduler Features
    + Taints and Tolerations
    + Node Selectors and Affinity
    + Inter-Pod Affinity and Anti-Affinity
- Authentication and Authorization
    + Integration with Microsoft Entra ID 
    + Kubernetes Role-Based Access Control(K8 RBAC) using Azure RBAC, and pod identities

2. **Security**
- Cluster Security and Upgrades
    + Securing Access to the API server
    + Limiting Container Access
    + Managing Upgrades and Node Reboots
    + Network Policy Implementation
- Container Image Management and Security
    + Securing the Image and Runtimes 
    + Automated Builds on Base Image Updates
- Pod Security
    + Securing Access to Resources
    + Limiting Credential Exposure 
    + Using Pod Identities and Digital Key Vaults

3. **Network and Storage**
- Network Connectivity
    + Different Network Models
    + Ingress and Web Application Firewalls (WAF)
    + Securing Node SSH access
- Storage and Backups
    + Choose the Appropriate Storage Type and Node Size
    + Dynamically Provisioning Volumes
    + Data Backups

4. **Running Enterprise-Ready Workloads**
- Business Continuity and Disaster Recovery
    + Using Region Pairs
    + Multiple Clusters with Azure Traffic Manager 
    + Geo-Replication of Container Images
    + AKS Deployment across Multilpe Availability Zones

5. **Developer Best Practices**
- Application Developers to Manage Resources
    + Defining Pod Resource Requests and Limits
    + Configuring Development Tools 
    + Checking for Application Issues
- Deployment and Cluster Reliability
    + Includes deployment, cluster, and node pool level best practices.


## Terrafrom

## Terragrunt

## Kubernetes