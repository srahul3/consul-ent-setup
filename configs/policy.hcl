partition "billing" {
  service "consul-esm" {
    policy = "write"
  }
  service_prefix "" {
    policy = "write"
    intentions = "read"
  }
  node_prefix "" {
    policy = "write"
  }
  key_prefix "consul-esm/" {
    policy = "write"
  }
  agent_prefix "" {
    policy = "read"
  }
  session_prefix "" {
    policy = "write"
  }
}
