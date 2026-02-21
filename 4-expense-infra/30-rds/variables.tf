variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Component = "mysql"
        Terraform = "true"
    }
}

variable "rds_tags" {
    default = {
        Component = "mysql"
    }
}

variable "zone_name" {
    default = "daws100s.online"
}

variable "zone_id" {
    default = "Z02305702LFJSCAA8YV7Q"
}

variable "route53_tags" {
    default = {}
} 