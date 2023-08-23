variable "prefix" {
  default     = "CPGTest"
  description = "The prefix which should be used for all resources in this example"
}

variable "region" {
  description = "The Azure Region in which all resources in this example should be created"
}


variable "subscriptionId" {}
variable "clientId" {}
variable "clientSecret" {}
variable "resourceGroup" {
  default     = "ComplexVarTestRG"
}
variable "tenantId" {}
variable "diskSizeInGB" {

description = "Disk size of the managed Disk."
  default     = "1"
}

variable "imageset" {
	type = set(string)
	default = [
	"image 1",
	"image 2", "image 3"]
}

variable "listType" {
 type        = list
  default     = ["t2.micro", #comment
 					"m1.small" // comment ..,
           ]
 description = "Instance types for the EC2 instance"
 /*
	multiline
	* comment
 */
}

variable "environment" {
 type = tuple([bool, bool, object({
   name = string
   env  = string,
   isAvailable = bool
 })
 ])
 /***
 comment
 commment
 */
 default = [false, true,{
   name : "vpc-0163eb001426736ac"
   //commment .......,
   env  : "Dev",
   isAvailable : true
 }]
 description = "Subnet ID for network interface"
}

variable "vmSize" {
  description = "Specifies the size of the virtual machine."
  default = [true, {
    type1 = "m1.small"
    "type2"   = "Standard_D1_v2",
    type3 : "m1.medium"
  }]
}


variable "admin_username" {
  description = "administrator user name"
  default     = "vmadmin"
}

variable "admin_password" {
  description = "administrator password (recommended to disable password auth)"
  default = "admin01!"
}
variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}
variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}
variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default = {
    "image1" = "16.04-LTS"
    "image2" = "17.04-LTS"
  }
  type    = map
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "hostname" {
  description = "VM name referenced also in storage-related names."
  default="tf"
}

variable "mapvar" {
    default =                         {
	  "name" : "cpgip"
	  duration = 958,
	  count = 45
  }
  type = map  (string)
  description = "mapppp type"
}

variable "objectVar" {
 default = {
   name = "My Vm disk"
   //commment .......,
   env  = "Dev",
   isAvailable = true
 }
 type = object({
   name = string
   env  = string,
   isAvailable = bool
 })
 description = "Tags for the EC2 instance"
}