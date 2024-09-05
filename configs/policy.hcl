partition "billing" {
  namespace_prefix "" {
    # grants permission to create and edit all namespaces
    policy = "write"
    # grant service:read for all services in all namespaces
    service_prefix "" {
      policy = "write"
    }
    # grant node:read for all nodes in all namespaces
    node_prefix "" {
      policy = "write"
    }
    # Provide KV visibility to all agents.
    agent_prefix "" {
      policy = "write"
    }
    # Enable the agent to initialize a new session.
    session_prefix "" {
      policy = "write"
    }
  }
}
