variable "name" {}
variable "description" { default = "" }
variable "assume_role_policy" {}
variable "policies" { 
    type = list(string) 
    default = [] 
}
variable "inline_policies" { 
    type = map(any) 
    default = {} 
}
