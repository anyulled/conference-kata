# 2. Use Auto-scaling

Date: 2024-01-15

## Status

Accepted

## Context

The system faces 'burst' traffic during conferences, requiring dynamic scaling to maintain performance.

## Decision

The web application component will be deployed within an AWS Auto Scaling Group.

## Consequences

* **Positive**: The system can automatically scale its resources to match the load, ensuring high availability and performance during peak traffic.
* **Negative**: Additional complexity in monitoring and managing scaling policies; potential cost implications due to scaling.