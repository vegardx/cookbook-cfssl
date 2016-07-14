default['cfssl']['download_url']      = "https://pkg.cfssl.org"
default['cfssl']['version']           = "R1.2"
default['cfssl']['arch']              = "amd64"
default['cfssl']['install_path']      = "/opt/cfssl"
default['cfssl']['config_path']       = "/etc/cfssl"
default['cfssl']['auth_key']          = "841C395BF335E3A165EBA00C4B12EDA3"
default['cfssl']['service']['user']   = "root"
default['cfssl']['service']['group']  = "root"
default['cfssl']['service']['bind']   = "0.0.0.0"
default['cfssl']['service']['port']   = "8888"
default['cfssl']['remote']['address'] = "127.0.0.1"
default['cfssl']['remote']['port']    = "8888"


default['cfssl']['packages']     = [ "cfssl", "cfssljson" ]
default['cfssl']['checksums']    = {
  "amd64" => {
    "cfssl"     => "eb34ab2179e0b67c29fd55f52422a94fe751527b06a403a79325fed7cf0145bd",
    "cfssljson" => "1c9e628c3b86c3f2f8af56415d474c9ed4c8f9246630bd21c3418dbe5bf6401e"
  }
}

default['cfssl']['ca'] = {
  "example.com" => {
    "key_algorithm"     => "rsa",
    "key_size"          => "2048",
    "country"           => "Norway",
    "state"             => "Oslo",
    "city"              => "Oslo",
    "organization"      => "Foo",
    "organization_unit" => "Bar",
    "ca_expire"         => "262800h"
  }
}

default['cfssl']['cert'] = {
  "#{node['hostname']}" => {
    "key_algorithm"     => "rsa",
    "key_size"          => "2048",
    "country"           => "Norway",
    "state"             => "Oslo",
    "city"              => "Oslo",
    "organization"      => "Foo",
    "organization_unit" => "Bar"
  }
}
