variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = "true"
        Environment = "dev"
    }
}

variable "zone_name" {
    default = "nhari.online"
}

variable "zone_id" {
    default = "Z0599546OKNNCL3Q9607"
}