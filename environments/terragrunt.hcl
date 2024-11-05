terraform {
  before_hook "tflint" {
    commands = ["init", "plan"]
    execute  = ["echo"]
  }
}

retryable_errors = [
  "(?s).*in use by.*and cannot be deleted.*all the resources.*",
  "(?s).*ssh_exchange_identification.*Connection closed by remote host.*"
]

retry_max_attempts       = 5
retry_sleep_interval_sec = 60