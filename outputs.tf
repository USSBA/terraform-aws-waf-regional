output "waf_id" {
  value = try(aws_wafregional_web_acl.waf_acl[0].id, null)
}
