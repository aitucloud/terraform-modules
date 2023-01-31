module "lb" {
  env_vars    = local.env_vars
  source     = "git::https://github.com/aitucloud/terraform-modules.git//loadbalancer?ref=dev"
  name        = "test-http"
  subnet      = "lb"
  floating_ip = true
  ext_net     = "qshyosdemodevtenant"

  listener_protocol      = "TERMINATED_HTTPS"
  listener_protocol_port = "443"
  certificate            = "my.pem"
  private_key            = "mykey.pem"

  members = {
    app_0 = { ip = module.app_0.instance_ip, port = 80 }
    app_1 = { ip = module.app_1.instance_ip, port = 80 }
  }
}
