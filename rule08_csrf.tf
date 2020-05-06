resource "aws_wafregional_rule" "enforce_csrf" {
  count       = local.is_csrf_enabled
  name        = "${var.waf_prefix}-generic-enforce-csrf"
  metric_name = "${var.waf_prefix}genericenforcecsrf"

  predicate {
    data_id = aws_wafregional_byte_match_set.match_csrf_method[0].id
    negated = false
    type    = "ByteMatch"
  }

  predicate {
    data_id = aws_wafregional_size_constraint_set.csrf_token_set[0].id
    negated = true
    type    = "SizeConstraint"
  }
}

# Apply only to POST
resource "aws_wafregional_byte_match_set" "match_csrf_method" {
  count = local.is_csrf_enabled
  name  = "${var.waf_prefix}-generic-match-csrf-method"
  byte_match_tuples {
    text_transformation   = "LOWERCASE"
    target_string         = "post"
    positional_constraint = "EXACTLY"

    field_to_match {
      type = "METHOD"
    }
  }
}

# Confirm the CSRF Header matches the size expected
resource "aws_wafregional_size_constraint_set" "csrf_token_set" {
  count = local.is_csrf_enabled
  name  = "${var.waf_prefix}-generic-match-csrf-token"

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "EQ"
    size                = var.rule_csrf_size

    field_to_match {
      type = "HEADER"
      data = var.rule_csrf_header
    }
  }
}

