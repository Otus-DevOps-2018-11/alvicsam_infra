#!/bin/bash

gcloud compute instances create reddit-app --boot-disk-size=10GB --image-family reddit-full --tags puma-server --restart-on-failure
