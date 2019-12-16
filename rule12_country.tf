resource "aws_wafregional_rule" "country_of_origin_filter" {
  count       = local.is_country_of_origin_enabled
  name        = "${var.waf_prefix}-generic-country-of-origin-filter"
  metric_name = "${var.waf_prefix}genericcountryoforiginfilter"

  predicate {
    data_id = aws_wafregional_geo_match_set.geo_match_set[0].id
    negated = false
    type    = "GeoMatch"
  }
}

resource "aws_wafregional_geo_match_set" "geo_match_set" {
  count = local.is_country_of_origin_enabled
  name  = "${var.waf_prefix}-geo-match-set"

  dynamic "geo_match_constraint" {
    iterator = x
    for_each = var.rule_country_of_origin_blacklist
    content {
      type  = "Country"
      value = x.value
    }
  }
}

