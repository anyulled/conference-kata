# 6. Use gRPC for microservice communication

Date: 2024-01-16

## Status

Proposed

## Context

The "Conference Kata" system is composed of multiple microservices (e.g., web application, attendee system, voting system, branding system). Efficient and reliable communication between these services is crucial for the overall performance and reliability of the system. gRPC, a high-performance, open-source universal RPC framework, is chosen for this purpose.

## Decision

The system will utilize gRPC for communication between microservices.

## Consequences

### Positive:
* **Efficiency:** gRPC uses HTTP/2, which is more efficient than HTTP/1.1 used in typical REST APIs. It allows for lower latency and better resource utilization.
* **Contract-First API Development:** Using Protocol Buffers (protobuf), gRPC ensures strong API contracts, which can enhance the maintainability and clarity of service interfaces.
* **Language Agnostic:** gRPC supports multiple programming languages, allowing flexibility in microservices development.
* **Streaming Capabilities:** gRPC supports bidirectional streaming, which can be beneficial for real-time data exchange scenarios.

### Negative:
* **Complexity:** Implementing gRPC can be more complex compared to RESTful services, especially for developers unfamiliar with RPC frameworks.
* **Limited Browser Support:** Direct browser-to-service communication is not as straightforward as with traditional REST APIs, potentially requiring additional components like a gRPC-Web proxy.
* **Operational Overhead:** Monitoring and debugging gRPC services may require additional tooling compared to REST APIs.
* **Less Human-Readable:** Unlike JSON over REST, protobuf is not human-readable, which can make manual testing and debugging more challenging.
