#defie region and project as variables
variable "gcp_region" {
  type        =string
  description ="Region to use for GCP project"
  default     = "europe-north1"
}
variable "project_id" {
  type        =string
  description ="Project to use for GCP PlayPen"
  default     = "playpen-cwukhm"
}

