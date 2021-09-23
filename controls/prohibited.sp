variable "prohibited_tags" {
  type        = list(string)
  description = "A list of prohibited tags to check for."
}

locals {
  prohibited_sql = <<EOT
    with analysis as (
      select
        id,
        array_agg(k) as prohibited_tags
      from
        __TABLE_NAME__,
        jsonb_object_keys(tags) as k,
        unnest($1::text[]) as prohibited_key
      where
        k = prohibited_key
      group by
        id
    )
    select
      r.id as resource,
      case
        when a.prohibited_tags <> array[]::text[] then 'alarm'
        else 'ok'
      end as status,
      case
        when a.prohibited_tags <> array[]::text[] then r.id || ' has prohibited tags: ' || array_to_string(a.prohibited_tags, ', ') || '.'
        else r.id || ' has no prohibited tags.'
      end as reason,
      __DIMENSIONS__
    from
      __TABLE_NAME__ as r
    full outer join
      analysis as a on a.id = r.id
  EOT
}

locals {
  prohibited_sql_tenant   = replace(local.prohibited_sql, "__DIMENSIONS__", "tenant_id")
  prohibited_sql_compartment   = replace(local.prohibited_sql, "__DIMENSIONS__", "compartment_id")
}

benchmark "prohibited" {
  title       = "Prohibited"
  description = "Prohibited tags may contain sensitive, confidential, or otherwise unwanted data and should be removed."
  children = [
    control.analytics_instance_prohibited,
    control.apigateway_api_prohibited,
    control.autoscaling_auto_scaling_configuration_prohibited,
    control.budget_alert_rule_prohibited,
    control.budget_budget_prohibited,
    control.cloud_guard_detector_recipe_prohibited,
    control.cloud_guard_target_prohibited,
    control.core_block_volume_replica_prohibited,
    control.core_boot_volume_prohibited,
    control.core_boot_volume_backup_prohibited,
    control.core_boot_volume_replica_prohibited,
    control.core_dhcp_options_prohibited,
    control.core_drg_prohibited,
    control.core_image_prohibited,
    control.core_image_custom_prohibited,
    control.core_instance_prohibited,
    control.core_internet_gateway_prohibited,
    control.core_load_balancer_prohibited,
    control.core_local_peering_gateway_prohibited,
    control.core_nat_gateway_prohibited,
    control.core_network_load_balancer_prohibited,
    control.core_network_security_group_prohibited,
    control.core_public_ip_prohibited,
    control.core_public_ip_pool_prohibited,
    control.core_route_table_prohibited,
    control.core_security_list_prohibited,
    control.core_service_gateway_prohibited,
    control.core_subnet_prohibited,
    control.core_vcn_prohibited,
    control.core_volume_prohibited,
    control.core_volume_backup_prohibited,
    control.core_volume_backup_policy_prohibited,
    control.database_autonomous_database_prohibited,
    control.database_db_prohibited,
    control.database_db_home_prohibited,
    control.database_db_system_prohibited,
    control.database_software_image_prohibited,
    control.dns_tsig_key_prohibited,
    control.dns_zone_prohibited,
    control.events_rule_prohibited,
    control.file_storage_file_system_prohibited,
    control.file_storage_mount_target_prohibited,
    control.file_storage_snapshot_prohibited,
    control.functions_application_prohibited,
    control.identity_compartment_prohibited,
    control.identity_dynamic_group_prohibited,
    control.identity_group_prohibited,
    control.identity_network_source_prohibited,
    control.identity_policy_prohibited,
    control.identity_tag_namespace_prohibited,
    control.identity_tenancy_prohibited,
    control.identity_user_prohibited,
    control.kms_key_prohibited,
    control.kms_vault_prohibited,
    control.logging_log_prohibited,
    control.logging_log_group_prohibited,
    control.mysql_backup_prohibited,
    control.mysql_channel_prohibited,
    control.mysql_configuration_prohibited,
    control.mysql_configuration_custom_prohibited,
    control.mysql_db_system_prohibited,
    control.nosql_table_prohibited,
    control.objectstorage_bucket_prohibited,
    control.ons_subscription_prohibited
  ]
}

control "analytics_instance_prohibited" {
  title       = "Analytics instances should not have prohibited tags"
  description = "Check if Analytics instances have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_analytics_instance")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "apigateway_api_prohibited" {
  title       = "Apigateway apis should not have prohibited tags"
  description = "Check if Apigateway apis have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_apigateway_api")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "autoscaling_auto_scaling_configuration_prohibited" {
  title       = "Autoscaling auto scaling configurations should not have prohibited tags"
  description = "Check if Autoscaling auto scaling configurations have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_autoscaling_auto_scaling_configuration")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "budget_alert_rule_prohibited" {
  title       = "Budget alert rules should not have prohibited tags"
  description = "Check if Budget alert rules have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_budget_alert_rule")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "budget_budget_prohibited" {
  title       = "Budget budgets should not have prohibited tags"
  description = "Check if Budget budgets have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_budget_budget")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cloud_guard_detector_recipe_prohibited" {
  title       = "Cloud guard detector recipes should not have prohibited tags"
  description = "Check if Cloud guard detector recipes have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_cloud_guard_detector_recipe")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cloud_guard_managed_list_prohibited" {
  title       = "Cloud guard managed lists should not have prohibited tags"
  description = "Check if Cloud guard managed lists have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_cloud_guard_managed_list")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cloud_guard_responder_recipe_prohibited" {
  title       = "Cloud guard responder recipes should not have prohibited tags"
  description = "Check if Cloud guard responder recipes have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_cloud_guard_responder_recipe")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cloud_guard_target_prohibited" {
  title       = "Cloud guard targets should not have prohibited tags"
  description = "Check if Cloud guard targets have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_cloud_guard_target")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_block_volume_replica_prohibited" {
  title       = "Core block volume replicas should not have prohibited tags"
  description = "Check if Core block volume replicas have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_block_volume_replica")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_boot_volume_prohibited" {
  title       = "Core boot volumes should not have prohibited tags"
  description = "Check if Core boot volumes have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_boot_volume")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_boot_volume_backup_prohibited" {
  title       = "Core boot volume backups should not have prohibited tags"
  description = "Check if Core boot volume backups have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_boot_volume_backup")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_boot_volume_replica_prohibited" {
  title       = "Core boot volume replicas should not have prohibited tags"
  description = "Check if Core boot volume replicas have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_boot_volume_replica")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_dhcp_options_prohibited" {
  title       = "Core dhcp options should not have prohibited tags"
  description = "Check if Core dhcp options have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_dhcp_options")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_drg_prohibited" {
  title       = "Core drgs should not have prohibited tags"
  description = "Check if Core drgs have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_drg")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_image_prohibited" {
  title       = "Core images should not have prohibited tags"
  description = "Check if Core images have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_image")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_image_custom_prohibited" {
  title       = "Core image customs should not have prohibited tags"
  description = "Check if Core image customs have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_image_custom")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_instance_prohibited" {
  title       = "Core instances should not have prohibited tags"
  description = "Check if Core instances have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_instance")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_internet_gateway_prohibited" {
  title       = "Core internet gateways should not have prohibited tags"
  description = "Check if Core internet gateways have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_internet_gateway")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_load_balancer_prohibited" {
  title       = "Core load balancers should not have prohibited tags"
  description = "Check if Core load balancers have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_load_balancer")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_local_peering_gateway_prohibited" {
  title       = "Core local peering gateways should not have prohibited tags"
  description = "Check if Core local peering gateways have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_local_peering_gateway")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_nat_gateway_prohibited" {
  title       = "Core nat gateways should not have prohibited tags"
  description = "Check if Core nat gateways have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_nat_gateway")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_network_load_balancer_prohibited" {
  title       = "Core network load balancers should not have prohibited tags"
  description = "Check if Core network load balancers have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_network_load_balancer")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_network_security_group_prohibited" {
  title       = "Core network security groups should not have prohibited tags"
  description = "Check if Core network security groups have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_network_security_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_public_ip_prohibited" {
  title       = "Core public ips should not have prohibited tags"
  description = "Check if Core public ips have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_public_ip")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_public_ip_pool_prohibited" {
  title       = "Core public ip pools should not have prohibited tags"
  description = "Check if Core public ip pools have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_public_ip_pool")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_route_table_prohibited" {
  title       = "Core route tables should not have prohibited tags"
  description = "Check if Core route tables have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_route_table")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_security_list_prohibited" {
  title       = "Core security lists should not have prohibited tags"
  description = "Check if Core security lists have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_security_list")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_service_gateway_prohibited" {
  title       = "Core service gateways should not have prohibited tags"
  description = "Check if Core service gateways have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_service_gateway")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_subnet_prohibited" {
  title       = "Core subnets should not have prohibited tags"
  description = "Check if Core subnets have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_subnet")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_vcn_prohibited" {
  title       = "Core vcns should not have prohibited tags"
  description = "Check if Core vcns have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_vcn")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_volume_prohibited" {
  title       = "Core volumes should not have prohibited tags"
  description = "Check if Core volumes have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_volume")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_volume_backup_prohibited" {
  title       = "Core volume backups should not have prohibited tags"
  description = "Check if Core volume backups have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_volume_backup")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "core_volume_backup_policy_prohibited" {
  title       = "Core volume backup policies should not have prohibited tags"
  description = "Check if Core volume backup policies have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_core_volume_backup_policy")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "database_autonomous_database_prohibited" {
  title       = "Database autonomous databases should not have prohibited tags"
  description = "Check if Database autonomous databases have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_database_autonomous_database")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "database_db_prohibited" {
  title       = "Database dbs should not have prohibited tags"
  description = "Check if Database dbs have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_database_db")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "database_db_home_prohibited" {
  title       = "Database db homes should not have prohibited tags"
  description = "Check if Database db homes have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_database_db_home")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "database_db_system_prohibited" {
  title       = "Database db systems should not have prohibited tags"
  description = "Check if Database db systems have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_database_db_system")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "database_software_image_prohibited" {
  title       = "Database software images should not have prohibited tags"
  description = "Check if Database software images have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_database_software_image")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "dns_tsig_key_prohibited" {
  title       = "Dns tsig keys should not have prohibited tags"
  description = "Check if Dns tsig keys have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_dns_tsig_key")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "dns_zone_prohibited" {
  title       = "Dns zones should not have prohibited tags"
  description = "Check if Dns zones have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_dns_zone")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "events_rule_prohibited" {
  title       = "Events rules should not have prohibited tags"
  description = "Check if Events rules have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_events_rule")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "file_storage_file_system_prohibited" {
  title       = "File storage file systems should not have prohibited tags"
  description = "Check if File storage file systems have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_file_storage_file_system")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "file_storage_mount_target_prohibited" {
  title       = "File storage mount targets should not have prohibited tags"
  description = "Check if File storage mount targets have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_file_storage_mount_target")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "file_storage_snapshot_prohibited" {
  title       = "File storage snapshots should not have prohibited tags"
  description = "Check if File storage snapshots have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_file_storage_snapshot")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "functions_application_prohibited" {
  title       = "Functions applications should not have prohibited tags"
  description = "Check if Functions applications have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_functions_application")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "identity_compartment_prohibited" {
  title       = "Identity compartments should not have prohibited tags"
  description = "Check if Identity compartments have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_identity_compartment")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "identity_dynamic_group_prohibited" {
  title       = "Identity dynamic groups should not have prohibited tags"
  description = "Check if Identity dynamic groups have any prohibited tags."
  sql         = replace(local.prohibited_sql_tenant, "__TABLE_NAME__", "oci_identity_dynamic_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "identity_group_prohibited" {
  title       = "Identity groups should not have prohibited tags"
  description = "Check if Identity groups have any prohibited tags."
  sql         = replace(local.prohibited_sql_tenant, "__TABLE_NAME__", "oci_identity_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "identity_network_source_prohibited" {
  title       = "Identity network sources should not have prohibited tags"
  description = "Check if Identity network sources have any prohibited tags."
  sql         = replace(local.prohibited_sql_tenant, "__TABLE_NAME__", "oci_identity_network_source")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "identity_policy_prohibited" {
  title       = "Identity policies should not have prohibited tags"
  description = "Check if Identity policies have any prohibited tags."
  sql         = replace(local.prohibited_sql_tenant, "__TABLE_NAME__", "oci_identity_policy")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "identity_tag_namespace_prohibited" {
  title       = "Identity tag namespaces should not have prohibited tags"
  description = "Check if Identity tag namespaces have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_identity_tag_namespace")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "identity_tenancy_prohibited" {
  title       = "Identity tenancies should not have prohibited tags"
  description = "Check if Identity tenancies have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_identity_tenancy")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "identity_user_prohibited" {
  title       = "Identity users should not have prohibited tags"
  description = "Check if Identity users have any prohibited tags."
  sql         = replace(local.prohibited_sql_tenant, "__TABLE_NAME__", "oci_identity_user")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "kms_key_prohibited" {
  title       = "Kms keys should not have prohibited tags"
  description = "Check if Kms keys have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_kms_key")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "kms_vault_prohibited" {
  title       = "Kms vaults should not have prohibited tags"
  description = "Check if Kms vaults have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_kms_vault")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "logging_log_prohibited" {
  title       = "Logging logs should not have prohibited tags"
  description = "Check if Logging logs have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_logging_log")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "logging_log_group_prohibited" {
  title       = "Logging log groups should not have prohibited tags"
  description = "Check if Logging log groups have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_logging_log_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "mysql_backup_prohibited" {
  title       = "Mysql backups should not have prohibited tags"
  description = "Check if Mysql backups have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_mysql_backup")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "mysql_channel_prohibited" {
  title       = "Mysql channels should not have prohibited tags"
  description = "Check if Mysql channels have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_mysql_channel")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "mysql_configuration_prohibited" {
  title       = "Mysql configurations should not have prohibited tags"
  description = "Check if Mysql configurations have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_mysql_configuration")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "mysql_configuration_custom_prohibited" {
  title       = "Mysql configuration customs should not have prohibited tags"
  description = "Check if Mysql configuration customs have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_mysql_configuration_custom")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "mysql_db_system_prohibited" {
  title       = "Mysql db systems should not have prohibited tags"
  description = "Check if Mysql db systems have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_mysql_db_system")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "nosql_table_prohibited" {
  title       = "Nosql tables should not have prohibited tags"
  description = "Check if Nosql tables have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_nosql_table")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "objectstorage_bucket_prohibited" {
  title       = "Objectstorage buckets should not have prohibited tags"
  description = "Check if Objectstorage buckets have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_objectstorage_bucket")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ons_subscription_prohibited" {
  title       = "Ons subscriptions should not have prohibited tags"
  description = "Check if Ons subscriptions have any prohibited tags."
  sql         = replace(local.prohibited_sql_compartment, "__TABLE_NAME__", "oci_ons_subscription")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}
