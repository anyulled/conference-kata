# 1. Use Amazon Web Services

Date: 2024-01-15

## Status

Accepted

## Context

The system requires a robust, scalable, 
and secure cloud environment to handle varying loads, especially during peak conference times.
AWS offers a comprehensive set of services that can fulfill these needs.

## Decision

We will use AWS

## Consequences

* **Positive**: Scalability with services like EC2 Auto Scaling and Elastic Load Balancer; high availability and reliability; wide range of services for different needs (e.g., S3 for storage, RDS for databases).
* **Negative**: Potential vendor lock-in; requires AWS-specific knowledge for maintenance and operation.