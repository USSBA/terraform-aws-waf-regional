resource "aws_wafregional_rule" "detect_blacklisted_ips" {
  count       = local.is_ip_blacklist_enabled
  name        = "${var.waf_prefix}-generic-detect-blacklisted-ips"
  metric_name = "${var.waf_prefix}genericdetectblacklistedips"
  predicate {
    data_id = aws_wafregional_ipset.blacklisted_ips[0].id
    negated = false
    type    = "IPMatch"
  }
}
resource "aws_wafregional_ipset" "blacklisted_ips" {
  count = local.is_ip_blacklist_enabled
  name  = "${var.waf_prefix}-generic-match-blacklisted-ips"
  dynamic "ip_set_descriptor" {
    iterator = x
    for_each = var.rule_ip_blacklist_ipv4
    content {
      type  = "IPV4"
      value = x.value
    }
  }
  dynamic "ip_set_descriptor" {
    iterator = x
    for_each = var.rule_ip_blacklist_ipv6
    content {
      type  = "IPV6"
      value = x.value
    }
  }
}

