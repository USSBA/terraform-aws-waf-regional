resource "aws_wafregional_rule" "mitigate_xss" {
  count       = local.is_xss_enabled
  name        = "${var.waf_prefix}-generic-mitigate-xss"
  metric_name = "${var.waf_prefix}genericmitigatexss"

  predicate {
    data_id = aws_wafregional_xss_match_set.xss_match_set[0].id
    negated = false
    type    = "XssMatch"

  }
}
resource "aws_wafregional_xss_match_set" "xss_match_set" {
  count = local.is_xss_enabled
  name  = "${var.waf_prefix}-generic-detect-xss"

  dynamic "xss_match_tuple" {
    iterator = x
    for_each = var.rule_xss_request_fields
    content {
      text_transformation = "HTML_ENTITY_DECODE"
      field_to_match {
        type = x.value
      }
    }
  }
  dynamic "xss_match_tuple" {
    iterator = x
    for_each = var.rule_xss_request_fields
    content {
      text_transformation = "URL_DECODE"
      field_to_match {
        type = x.value
      }
    }
  }
  dynamic "xss_match_tuple" {
    iterator = x
    for_each = var.rule_xss_request_headers
    content {
      text_transformation = "HTML_ENTITY_DECODE"
      field_to_match {
        type = "HEADER"
        data = x.value
      }
    }
  }
  dynamic "xss_match_tuple" {
    iterator = x
    for_each = var.rule_xss_request_headers
    content {
      text_transformation = "URL_DECODE"
      field_to_match {
        type = "HEADER"
        data = x.value
      }
    }
  }
}
