locals {
  tier          = "${lookup(var.network_configuration, "tier", "")}"
  vpc           = "${lookup(var.network_configuration, "vpc", "")}"
  subnets       = "${compact(split(" ", lookup(var.network_configuration, "subnets", "")))}"
  all_subnets   = "${distinct(concat(flatten(data.aws_subnet_ids.selected.*.ids), local.subnets))}"
}

## Network data sources

data "aws_vpc" "selected" {
  count = "${local.tier != "" ? 1 : 0}"

  tags {
    Name = "${local.vpc}"
  }
}

data "aws_subnet_ids" "selected" {
  count  = "${local.tier != "" ? 1 : 0}"
  vpc_id = "${data.aws_vpc.selected.id}"

  tags {
    Tier = "${local.tier}"
  }
}
