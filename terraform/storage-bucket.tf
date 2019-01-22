provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name = ["alvic-73902-bucket-prod", "alvic-73902-bucket-stage"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}

