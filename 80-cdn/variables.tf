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

variable "cdn_tags" {
    default = {
        Component = "cdn"
    }
}

variable "zone_name" {
    default = "nhari.online"
}

