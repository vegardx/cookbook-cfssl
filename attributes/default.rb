default['cfssl']['download_url']      = "https://pkg.cfssl.org"
default['cfssl']['version']           = "R1.2"
default['cfssl']['arch']              = "amd64"
default['cfssl']['install_path']      = "/opt/cfssl"
default['cfssl']['config_path']       = "/etc/cfssl"
default['cfssl']['service']['user']   = "cfssl"
default['cfssl']['service']['group']  = "cfssl"
default['cfssl']['server']['bind']    = "0.0.0.0"
default['cfssl']['server']['port']    = "8887"
default['cfssl']['client']['bind']    = "127.0.0.1"
default['cfssl']['client']['port']    = "8888"
default['cfssl']['ssm']['path']       = "cfssl"

# Multiroot remote
default['cfssl']['remote']['address'] = "test-pki.test.speedygonzales.io"
default['cfssl']['remote']['port']    = "8887"


default['cfssl']['packages'] = {
  "amd64" => {
    "cfssl" => "eb34ab2179e0b67c29fd55f52422a94fe751527b06a403a79325fed7cf0145bd",
    "cfssljson" => "1c9e628c3b86c3f2f8af56415d474c9ed4c8f9246630bd21c3418dbe5bf6401e",
    "multirootca" => "7b7884ae113eb7693591194399d424bd39902252c3198d6dea075ac98b3f275d"
  },

  "386" => {
    "cfssl" => "b968f3c2aedff9557f80102293f34fea262c7d7b53bec057b3f138ca456c6ed5",
    "cfssljson" => "5ad9be85ea5e4371fcfedb5abbf31302de0860ed4b53adc6251227c6792a1a9a",
    "multirootca" => "a1cf390ac42006fe659e25587c7ba74ea63c7d27a557d733efecdd7e4fd7f25f"
  },

  "arm" => {
    "cfssl" => "11c708acaf48a69abf6f896f5c6158f7547a3c1bf44e14ca3b3ab440c1f808f1",
    "cfssljson" => "e138102329d96f5a67aa168034a256a8376febf4ecde7b8e837c3f2e08b1cd19",
    "multirootca" => "d53bbc0d2ac2d57c089d4f730d9e7b2d365701adc1bb417153a5f70a16bd10d6"
  }
}

# Default profile, everyone in Chef is assumed to have access to this auth_key.
default['cfssl']['server']['profiles'] = {
  "netwerk" => {
    "signing" => {
      "profiles" => {
        "netwerk" => {
          "auth_key" => "netwerk",
          "expiry" => "4h",
          "usages" => ["any"]
        }
      }
    },
    "auth_keys" => {
      "netwerk" => {
        "key" => "841C395BF335E3A165EBA00C4B12EDA3",
        "type" => "standard"
      }
    }
  }
}

default['cfssl']['client']['profiles'] = {
  "netwerk" => {
    "signing" => {
      "profiles" => {
        "netwerk" => {
          "auth_remote" => {
            "auth_key" => "netwerk"
          },
          "expiry" => "4h",
          "usages" => ["any"]
        }
      }
    },
    "auth_keys" => {
      "netwerk" => {
        "key" => "841C395BF335E3A165EBA00C4B12EDA3",
        "type" => "standard"
      }
    }
  }
}

# Intermediate certificates are signed manually with Root CA.
default['cfssl']['ca'] = {
  "netwerk" => {
    "cn"                => "Netwerk Intermediate CA ECDSA-256 X1",
    "key_algorithm"     => "ecdsa",
    "key_size"          => "256",
    "country"           => "NO",
    "state"             => "Oslo",
    "city"              => "Oslo",
    "organization"      => "Acme Ltd.",
    "organization_unit" => "Department of Silly Walks",
    "ca_expire"         => "43800h"
  }
}

# Default certificate, installed on all hosts
default['cfssl']['cert'] = {
  "#{node['hostname']}-ecdsa-default" => {
    "label"             => "netwerk", # Which CA to use
    "profile"           => "netwerk", # What certificate to request
    "hosts"             => [""],
    "key_algorithm"     => "ecdsa",
    "key_size"          => "256",
    "country"           => "NO",
    "state"             => "Oslo",
    "city"              => "Oslo",
    "organization"      => "Acme Ltd.",
    "organization_unit" => "Department of Silly Walks"
  }
}
