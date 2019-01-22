terraform {
  backend "gcs" {
    bucket  = "alvic-73902-bucket-prod"
    prefix  = "terraform/state"
  }
}
