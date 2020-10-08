variable "firewall_rule_name" {
    type = string
}

variable "network" {
    type = string
}

variable "protocol_type" {
    type = string
}

variable "ports" {
    type = list
}

variable "source_ranges" {
    type = list
}

variable "target_tags" {
    type = list
}