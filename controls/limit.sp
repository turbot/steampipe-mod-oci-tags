variable "tag_limit" {
  type        = number
  description = "Number of tags allowed on a resource."
}

locals {
  limit_sql = <<EOT
    with analysis as (
      select
        id,
        cardinality(array(select jsonb_object_keys(tags))) as num_tag_keys,
        __DIMENSIONS__
      from
        __TABLE_NAME__
    )
    select
      id as resource,
      case
        when num_tag_keys > $1::integer then 'alarm'
        else 'ok'
      end as status,
      id || ' has ' || num_tag_keys || ' tag(s).' as reason,
      __DIMENSIONS__
    from
      analysis
  EOT
}

locals {
  limit_sql_tenant   = replace(local.limit_sql, "__DIMENSIONS__", "tenant_id")
  limit_sql_compartment   = replace(local.limit_sql, "__DIMENSIONS__", "compartment_id")
}

benchmark "mandatory" {
  title       = "Mandatory"
  description = "Resources should all have a standard set of tags applied for functions like resource organization, automation, cost control, and access control."
  children = [
    control.analytics_instance_mandatory,
    control.apigateway_api_mandatory,
    control.autoscaling_auto_scaling_configuration_mandatory,
    control.budget_alert_rule_mandatory,
    control.budget_budget_mandatory,
    control.cloud_guard_detector_recipe_mandatory,
    control.cloud_guard_target_mandatory,
    control.core_block_volume_replica_mandatory,
    control.core_boot_volume_mandatory,
    control.core_boot_volume_backup_mandatory,
    control.core_boot_volume_replica_mandatory,
    control.core_dhcp_options_mandatory,
    control.core_drg_mandatory,
    control.core_image_mandatory,
    control.core_image_custom_mandatory,
    control.core_instance_mandatory,
    control.core_internet_gateway_mandatory,
    control.core_load_balancer_mandatory,
    control.core_local_peering_gateway_mandatory,
    control.core_nat_gateway_mandatory,
    control.core_network_load_balancer_mandatory,
    control.core_network_security_group_mandatory,
    control.core_public_ip_mandatory,
    control.core_public_ip_pool_mandatory,
    control.core_route_table_mandatory,
    control.core_security_list_mandatory,
    control.core_service_gateway_mandatory,
    control.core_subnet_mandatory,
    control.core_vcn_mandatory,
    control.core_volume_mandatory,
    control.core_volume_backup_mandatory,
    control.core_volume_backup_policy_mandatory,
    control.database_autonomous_database_mandatory,
    control.database_db_mandatory,
    control.database_db_home_mandatory,
    control.database_db_system_mandatory,
    control.database_software_image_mandatory,
    control.dns_tsig_key_mandatory,
    control.dns_zone_mandatory,
    control.events_rule_mandatory,
    control.file_storage_file_system_mandatory,
    control.file_storage_mount_target_mandatory,
    control.file_storage_snapshot_mandatory,
    control.functions_application_mandatory,
    control.identity_compartment_mandatory,
    control.identity_dynamic_group_mandatory,
    control.identity_group_mandatory,
    control.identity_network_source_mandatory,
    control.identity_policy_mandatory,
    control.identity_tag_namespace_mandatory,
    control.identity_tenancy_mandatory,
    control.identity_user_mandatory,
    control.kms_key_mandatory,
    control.kms_vault_mandatory,
    control.logging_log_mandatory,
    control.logging_log_group_mandatory,
    control.mysql_backup_mandatory,
    control.mysql_channel_mandatory,
    control.mysql_configuration_mandatory,
    control.mysql_configuration_custom_mandatory,
    control.mysql_db_system_mandatory,
    control.nosql_table_mandatory,
    control.objectstorage_bucket_mandatory,
    control.ons_subscription_mandatory
  ]
}


control "analytics_instance_tag_limit" {
  title       = "Analytics instances should not exceed tag limit"
  description = "Check if the number of tags on Analytics instances do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_analytics_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "apigateway_api_tag_limit" {
  title       = "Apigateway apis should not exceed tag limit"
  description = "Check if the number of tags on Apigateway apis do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_apigateway_api")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "autoscaling_auto_scaling_configuration_tag_limit" {
  title       = "Autoscaling auto scaling configurations should not exceed tag limit"
  description = "Check if the number of tags on Autoscaling auto scaling configurations do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_autoscaling_auto_scaling_configuration")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "budget_alert_rule_tag_limit" {
  title       = "Budget alert rules should not exceed tag limit"
  description = "Check if the number of tags on Budget alert rules do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_budget_alert_rule")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "budget_budget_tag_limit" {
  title       = "Budget budgets should not exceed tag limit"
  description = "Check if the number of tags on Budget budgets do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_budget_budget")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloud_guard_detector_recipe_tag_limit" {
  title       = "Cloud guard detector recipes should not exceed tag limit"
  description = "Check if the number of tags on Cloud guard detector recipes do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_cloud_guard_detector_recipe")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloud_guard_managed_list_tag_limit" {
  title       = "Cloud guard managed lists should not exceed tag limit"
  description = "Check if the number of tags on Cloud guard managed lists do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_cloud_guard_managed_list")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloud_guard_responder_recipe_tag_limit" {
  title       = "Cloud guard responder recipes should not exceed tag limit"
  description = "Check if the number of tags on Cloud guard responder recipes do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_cloud_guard_responder_recipe")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloud_guard_target_tag_limit" {
  title       = "Cloud guard targets should not exceed tag limit"
  description = "Check if the number of tags on Cloud guard targets do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_cloud_guard_target")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_block_volume_replica_tag_limit" {
  title       = "Core block volume replicas should not exceed tag limit"
  description = "Check if the number of tags on Core block volume replicas do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_block_volume_replica")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_boot_volume_tag_limit" {
  title       = "Core boot volumes should not exceed tag limit"
  description = "Check if the number of tags on Core boot volumes do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_boot_volume")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_boot_volume_backup_tag_limit" {
  title       = "Core boot volume backups should not exceed tag limit"
  description = "Check if the number of tags on Core boot volume backups do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_boot_volume_backup")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_boot_volume_replica_tag_limit" {
  title       = "Core boot volume replicas should not exceed tag limit"
  description = "Check if the number of tags on Core boot volume replicas do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_boot_volume_replica")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_dhcp_options_tag_limit" {
  title       = "Core dhcp options should not exceed tag limit"
  description = "Check if the number of tags on Core dhcp options do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_dhcp_options")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_drg_tag_limit" {
  title       = "Core drgs should not exceed tag limit"
  description = "Check if the number of tags on Core drgs do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_drg")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_image_tag_limit" {
  title       = "Core images should not exceed tag limit"
  description = "Check if the number of tags on Core images do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_image")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_image_custom_tag_limit" {
  title       = "Core image customs should not exceed tag limit"
  description = "Check if the number of tags on Core image customs do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_image_custom")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_instance_tag_limit" {
  title       = "Core instances should not exceed tag limit"
  description = "Check if the number of tags on Core instances do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_internet_gateway_tag_limit" {
  title       = "Core internet gateways should not exceed tag limit"
  description = "Check if the number of tags on Core internet gateways do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_internet_gateway")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_load_balancer_tag_limit" {
  title       = "Core load balancers should not exceed tag limit"
  description = "Check if the number of tags on Core load balancers do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_load_balancer")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_local_peering_gateway_tag_limit" {
  title       = "Core local peering gateways should not exceed tag limit"
  description = "Check if the number of tags on Core local peering gateways do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_local_peering_gateway")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_nat_gateway_tag_limit" {
  title       = "Core nat gateways should not exceed tag limit"
  description = "Check if the number of tags on Core nat gateways do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_nat_gateway")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_network_load_balancer_tag_limit" {
  title       = "Core network load balancers should not exceed tag limit"
  description = "Check if the number of tags on Core network load balancers do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_network_load_balancer")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_network_security_group_tag_limit" {
  title       = "Core network security groups should not exceed tag limit"
  description = "Check if the number of tags on Core network security groups do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_network_security_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_public_ip_tag_limit" {
  title       = "Core public ips should not exceed tag limit"
  description = "Check if the number of tags on Core public ips do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_public_ip")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_public_ip_pool_tag_limit" {
  title       = "Core public ip pools should not exceed tag limit"
  description = "Check if the number of tags on Core public ip pools do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_public_ip_pool")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_route_table_tag_limit" {
  title       = "Core route tables should not exceed tag limit"
  description = "Check if the number of tags on Core route tables do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_route_table")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_security_list_tag_limit" {
  title       = "Core security lists should not exceed tag limit"
  description = "Check if the number of tags on Core security lists do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_security_list")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_service_gateway_tag_limit" {
  title       = "Core service gateways should not exceed tag limit"
  description = "Check if the number of tags on Core service gateways do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_service_gateway")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_subnet_tag_limit" {
  title       = "Core subnets should not exceed tag limit"
  description = "Check if the number of tags on Core subnets do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_subnet")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_vcn_tag_limit" {
  title       = "Core vcns should not exceed tag limit"
  description = "Check if the number of tags on Core vcns do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_vcn")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_volume_tag_limit" {
  title       = "Core volumes should not exceed tag limit"
  description = "Check if the number of tags on Core volumes do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_volume")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_volume_backup_tag_limit" {
  title       = "Core volume backups should not exceed tag limit"
  description = "Check if the number of tags on Core volume backups do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_volume_backup")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_volume_backup_policy_tag_limit" {
  title       = "Core volume backup policies should not exceed tag limit"
  description = "Check if the number of tags on Core volume backup policies do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_core_volume_backup_policy")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "database_autonomous_database_tag_limit" {
  title       = "Database autonomous databases should not exceed tag limit"
  description = "Check if the number of tags on Database autonomous databases do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_database_autonomous_database")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "database_db_tag_limit" {
  title       = "Database dbs should not exceed tag limit"
  description = "Check if the number of tags on Database dbs do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_database_db")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "database_db_home_tag_limit" {
  title       = "Database db homes should not exceed tag limit"
  description = "Check if the number of tags on Database db homes do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_database_db_home")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "database_db_system_tag_limit" {
  title       = "Database db systems should not exceed tag limit"
  description = "Check if the number of tags on Database db systems do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_database_db_system")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "database_software_image_tag_limit" {
  title       = "Database software images should not exceed tag limit"
  description = "Check if the number of tags on Database software images do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_database_software_image")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "dns_tsig_key_tag_limit" {
  title       = "Dns tsig keys should not exceed tag limit"
  description = "Check if the number of tags on Dns tsig keys do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_dns_tsig_key")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "dns_zone_tag_limit" {
  title       = "Dns zones should not exceed tag limit"
  description = "Check if the number of tags on Dns zones do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_dns_zone")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "events_rule_tag_limit" {
  title       = "Events rules should not exceed tag limit"
  description = "Check if the number of tags on Events rules do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_events_rule")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "file_storage_file_system_tag_limit" {
  title       = "File storage file systems should not exceed tag limit"
  description = "Check if the number of tags on File storage file systems do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_file_storage_file_system")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "file_storage_mount_target_tag_limit" {
  title       = "File storage mount targets should not exceed tag limit"
  description = "Check if the number of tags on File storage mount targets do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_file_storage_mount_target")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "file_storage_snapshot_tag_limit" {
  title       = "File storage snapshots should not exceed tag limit"
  description = "Check if the number of tags on File storage snapshots do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_file_storage_snapshot")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "functions_application_tag_limit" {
  title       = "Functions applications should not exceed tag limit"
  description = "Check if the number of tags on Functions applications do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_functions_application")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_compartment_tag_limit" {
  title       = "Identity compartments should not exceed tag limit"
  description = "Check if the number of tags on Identity compartments do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_identity_compartment")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_dynamic_group_tag_limit" {
  title       = "Identity dynamic groups should not exceed tag limit"
  description = "Check if the number of tags on Identity dynamic groups do not exceed the limit."
  sql         = replace(local.limit_sql_tenant, "__TABLE_NAME__", "oci_identity_dynamic_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_group_tag_limit" {
  title       = "Identity groups should not exceed tag limit"
  description = "Check if the number of tags on Identity groups do not exceed the limit."
  sql         = replace(local.limit_sql_tenant, "__TABLE_NAME__", "oci_identity_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_network_source_tag_limit" {
  title       = "Identity network sources should not exceed tag limit"
  description = "Check if the number of tags on Identity network sources do not exceed the limit."
  sql         = replace(local.limit_sql_tenant, "__TABLE_NAME__", "oci_identity_network_source")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_policy_tag_limit" {
  title       = "Identity policies should not exceed tag limit"
  description = "Check if the number of tags on Identity policies do not exceed the limit."
  sql         = replace(local.limit_sql_tenant, "__TABLE_NAME__", "oci_identity_policy")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_tag_namespace_tag_limit" {
  title       = "Identity tag namespaces should not exceed tag limit"
  description = "Check if the number of tags on Identity tag namespaces do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_identity_tag_namespace")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_tenancy_tag_limit" {
  title       = "Identity tenancies should not exceed tag limit"
  description = "Check if the number of tags on Identity tenancies do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_identity_tenancy")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_user_tag_limit" {
  title       = "Identity users should not exceed tag limit"
  description = "Check if the number of tags on Identity users do not exceed the limit."
  sql         = replace(local.limit_sql_tenant, "__TABLE_NAME__", "oci_identity_user")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "kms_key_tag_limit" {
  title       = "Kms keys should not exceed tag limit"
  description = "Check if the number of tags on Kms keys do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_kms_key")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "kms_vault_tag_limit" {
  title       = "Kms vaults should not exceed tag limit"
  description = "Check if the number of tags on Kms vaults do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_kms_vault")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "logging_log_tag_limit" {
  title       = "Logging logs should not exceed tag limit"
  description = "Check if the number of tags on Logging logs do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_logging_log")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "logging_log_group_tag_limit" {
  title       = "Logging log groups should not exceed tag limit"
  description = "Check if the number of tags on Logging log groups do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_logging_log_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_backup_tag_limit" {
  title       = "Mysql backups should not exceed tag limit"
  description = "Check if the number of tags on Mysql backups do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_mysql_backup")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_channel_tag_limit" {
  title       = "Mysql channels should not exceed tag limit"
  description = "Check if the number of tags on Mysql channels do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_mysql_channel")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_configuration_tag_limit" {
  title       = "Mysql configurations should not exceed tag limit"
  description = "Check if the number of tags on Mysql configurations do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_mysql_configuration")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_configuration_custom_tag_limit" {
  title       = "Mysql configuration customs should not exceed tag limit"
  description = "Check if the number of tags on Mysql configuration customs do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_mysql_configuration_custom")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_db_system_tag_limit" {
  title       = "Mysql db systems should not exceed tag limit"
  description = "Check if the number of tags on Mysql db systems do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_mysql_db_system")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "nosql_table_tag_limit" {
  title       = "Nosql tables should not exceed tag limit"
  description = "Check if the number of tags on Nosql tables do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_nosql_table")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "objectstorage_bucket_tag_limit" {
  title       = "Objectstorage buckets should not exceed tag limit"
  description = "Check if the number of tags on Objectstorage buckets do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_objectstorage_bucket")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ons_subscription_tag_limit" {
  title       = "Ons subscriptions should not exceed tag limit"
  description = "Check if the number of tags on Ons subscriptions do not exceed the limit."
  sql         = replace(local.limit_sql_compartment, "__TABLE_NAME__", "oci_ons_subscription")
  param "tag_limit" {
    default = var.tag_limit
  }
}
