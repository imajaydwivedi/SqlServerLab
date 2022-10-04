# SQL Server Lab Setup

## Summary
- 1 Domain Controller
- 1 Monitoring Server
- 1 End User machine
- 3 POC Servers
- 1 Host with All Versions of SQL Servers
- 4 Hosts in complex availability Setup
  - 4 active-active Sql Clusters divided in 2 logical partitions
  - 4 AlwaysOn Availability Groups with each having 2 pair of replicas.
  - 3 AGs on single pair of replicas. 1 AG on another pair of replicas.
  - Each replica in AGs is a SqlClustered Instance
## Network
- Adapter 01 - Internal Network - Subnet 192.168.56.*
- Adapter 02 - Internal Network - Subnet 192.168.57.*
- Adapter 03 - Bridged Adapter - Local LAN - Internet

## Host - Hypervisor host
- 32 vCPU & 128 Gb RAM
## DC - Domain controller cum SAN
- 4 vCPU & 5 GB RAM

## SQLMonitor - Monitoring Server running Grafana & SQLMonitor tool
- 8 vCPU & 16 GB RAM
## Workstation - End user laptop/desktop
- 8 vCPU & 16 GB RAM
## SqlPractice - High End server for POC
- 4 vCPU & 32 GB RAM
## Experiment - A server for POC
- 4 vCPU & 16 GB RAM
## Demo - A server for POC
- 8 vCPU & 5 GB RAM
## AllVersion - A server with all versions of SQL Server installed
- 16 vCPU & 16 GB RAM

## Distributor
- 8 vCPU & 8 GB RAM

