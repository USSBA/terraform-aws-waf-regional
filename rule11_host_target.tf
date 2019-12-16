resource "aws_wafregional_rule" "detect_ipaddress_targeting" {
  count       = local.is_host_target_enabled
  name        = "${var.waf_prefix}-generic-detect-ipaddress-targeting"
  metric_name = "${var.waf_prefix}genericdetectipaddresstargeting"

  predicate {
    data_id = aws_wafregional_regex_match_set.match_ipaddress_targeting[0].id
    negated = false
    type    = "RegexMatch"
  }
}
resource "aws_wafregional_regex_match_set" "match_ipaddress_targeting" {
  count = local.is_host_target_enabled
  name  = "${var.waf_prefix}-generic-match-ipaddress-targeting"

  regex_match_tuple {
    field_to_match {
      type = "HEADER"
      data = "Host"
    }

    regex_pattern_set_id = aws_wafregional_regex_pattern_set.match_ipaddress_targeting[0].id
    text_transformation  = "NONE"
  }
}
resource "aws_wafregional_regex_pattern_set" "match_ipaddress_targeting" {
  count                 = local.is_host_target_enabled
  name                  = "${var.waf_prefix}-generic-match-ipaddress-targeting"
  regex_pattern_strings = var.rule_host_target_regex_patterns
}

