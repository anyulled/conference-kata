# 3. Use microservices

Date: 2024-01-15

## Status

Accepted

## Context

The system requires flexibility, scalability, and ease of maintenance. Microservices architecture allows individual components to be developed, deployed, and scaled independently.

## Decision

The system will be structured as a collection of loosely coupled services (microservices), such as the web application, attendee system, voting system, branding system, etc.

## Consequences

* **Positive**: Improved scalability and maintainability; each service can be deployed independently; easier to implement different technologies per service as needed.
* **Negative**: Increased complexity in service coordination and communication; potential challenges in distributed data management.