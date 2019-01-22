terraform {
  backend "gcs" {
    bucket  = "alvic-73902-bucket-stage"
    prefix  = "terraform/state"
  }
}
