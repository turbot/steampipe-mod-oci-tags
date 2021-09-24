locals {
  tenant_resource_untagged_sql = <<EOT
    select
      a.title as resource,
      case
        when a.tags is not null and a.tags != '{}' then 'ok'
        else 'alarm'
      end as status,
      case
        when a.tags is not null and a.tags != '{}' then a.title || ' has tags.'
        else a.title || ' has no tags.'
      end as reason,
      t.title as tenant
    from
      __TABLE_NAME__ as a,
      oci_identity_tenancy as t;
  EOT
}

locals {
  compartment_resource_untagged_sql = <<EOT
    select
      a.title as resource,
      case
        when a.tags is not null and a.tags != '{}' then 'ok'
        else 'alarm'
      end as status,
      case
        when a.tags is not null and a.tags != '{}' then a.title || ' has tags.'
        else a.title || ' has no tags.'
      end as reason,
      coalesce(c.name, 'root') as compartment
    from
      __TABLE_NAME__ a
      left join oci_identity_compartment c on c.id = a.compartment_id
  EOT
}


benchmark "untagged" {
  title       = "Untagged"
  description = "Untagged resources are difficult to monitor and should be identified and remediated."
  children = [
    control.analytics_instance_untagged,
    control.apigateway_api_untagged,
    control.autoscaling_auto_scaling_configuration_untagged,
    control.budget_alert_rule_untagged,
    control.budget_budget_untagged,
    control.cloud_guard_detector_recipe_untagged,
    control.cloud_guard_target_untagged,
    control.core_block_volume_replica_untagged,
    control.core_boot_volume_untagged,
    control.core_boot_volume_backup_untagged,
    control.core_boot_volume_replica_untagged,
    control.core_dhcp_options_untagged,
    control.core_drg_untagged,
    control.core_image_untagged,
    control.core_image_custom_untagged,
    control.core_instance_untagged,
    control.core_internet_gateway_untagged,
    control.core_load_balancer_untagged,
    control.core_local_peering_gateway_untagged,
    control.core_nat_gateway_untagged,
    control.core_network_load_balancer_untagged,
    control.core_network_security_group_untagged,
    control.core_public_ip_untagged,
    control.core_public_ip_pool_untagged,
    control.core_route_table_untagged,
    control.core_security_list_untagged,
    control.core_service_gateway_untagged,
    control.core_subnet_untagged,
    control.core_vcn_untagged,
    control.core_volume_untagged,
    control.core_volume_backup_untagged,
    control.core_volume_backup_policy_untagged,
    control.database_autonomous_database_untagged,
    control.database_db_untagged,
    control.database_db_home_untagged,
    control.database_db_system_untagged,
    control.database_software_image_untagged,
    control.dns_tsig_key_untagged,
    control.dns_zone_untagged,
    control.events_rule_untagged,
    control.file_storage_file_system_untagged,
    control.file_storage_mount_target_untagged,
    control.file_storage_snapshot_untagged,
    control.functions_application_untagged,
    control.identity_compartment_untagged,
    control.identity_dynamic_group_untagged,
    control.identity_group_untagged,
    control.identity_network_source_untagged,
    control.identity_policy_untagged,
    control.identity_tag_namespace_untagged,
    control.identity_tenancy_untagged,
    control.identity_user_untagged,
    control.kms_key_untagged,
    control.kms_vault_untagged,
    control.logging_log_untagged,
    control.logging_log_group_untagged,
    control.mysql_backup_untagged,
    control.mysql_channel_untagged,
    control.mysql_configuration_untagged,
    control.mysql_configuration_custom_untagged,
    control.mysql_db_system_untagged,
    control.nosql_table_untagged,
    control.objectstorage_bucket_untagged,
    control.ons_subscription_untagged
  ]
}

control "analytics_instance_untagged" {
  title       = "Analytics instances should be tagged"
  description = "Check if Analytics instances have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_analytics_instance")
}

control "apigateway_api_untagged" {
  title       = "Apigateway apis should be tagged"
  description = "Check if Apigateway apis have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_apigateway_api")
}

control "autoscaling_auto_scaling_configuration_untagged" {
  title       = "Autoscaling auto scaling configurations should be tagged"
  description = "Check if Autoscaling auto scaling configurations have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_autoscaling_auto_scaling_configuration")
}

control "budget_alert_rule_untagged" {
  title       = "Budget alert rules should be tagged"
  description = "Check if Budget alert rules have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_budget_alert_rule")
}

control "budget_budget_untagged" {
  title       = "Budget budgets should be tagged"
  description = "Check if Budget budgets have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_budget_budget")
}

control "cloud_guard_detector_recipe_untagged" {
  title       = "Cloud guard detector recipes should be tagged"
  description = "Check if Cloud guard detector recipes have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_cloud_guard_detector_recipe")
}

control "cloud_guard_managed_list_untagged" {
  title       = "Cloud guard managed lists should be tagged"
  description = "Check if Cloud guard managed lists have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_cloud_guard_managed_list")
}

control "cloud_guard_responder_recipe_untagged" {
  title       = "Cloud guard responder recipes should be tagged"
  description = "Check if Cloud guard responder recipes have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_cloud_guard_responder_recipe")
}

control "cloud_guard_target_untagged" {
  title       = "Cloud guard targets should be tagged"
  description = "Check if Cloud guard targets have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_cloud_guard_target")
}

control "core_block_volume_replica_untagged" {
  title       = "Core block volume replicas should be tagged"
  description = "Check if Core block volume replicas have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_block_volume_replica")
}

control "core_boot_volume_untagged" {
  title       = "Core boot volumes should be tagged"
  description = "Check if Core boot volumes have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_boot_volume")
}

control "core_boot_volume_backup_untagged" {
  title       = "Core boot volume backups should be tagged"
  description = "Check if Core boot volume backups have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_boot_volume_backup")
}

control "core_boot_volume_replica_untagged" {
  title       = "Core boot volume replicas should be tagged"
  description = "Check if Core boot volume replicas have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_boot_volume_replica")
}

control "core_dhcp_options_untagged" {
  title       = "Core dhcp options should be tagged"
  description = "Check if Core dhcp options have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_dhcp_options")
}

control "core_drg_untagged" {
  title       = "Core drgs should be tagged"
  description = "Check if Core drgs have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_drg")
}

control "core_image_untagged" {
  title       = "Core images should be tagged"
  description = "Check if Core images have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_image")
}

control "core_image_custom_untagged" {
  title       = "Core image customs should be tagged"
  description = "Check if Core image customs have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_image_custom")
}

control "core_instance_untagged" {
  title       = "Core instances should be tagged"
  description = "Check if Core instances have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_instance")
}

control "core_internet_gateway_untagged" {
  title       = "Core internet gateways should be tagged"
  description = "Check if Core internet gateways have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_internet_gateway")
}

control "core_load_balancer_untagged" {
  title       = "Core load balancers should be tagged"
  description = "Check if Core load balancers have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_load_balancer")
}

control "core_local_peering_gateway_untagged" {
  title       = "Core local peering gateways should be tagged"
  description = "Check if Core local peering gateways have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_local_peering_gateway")
}

control "core_nat_gateway_untagged" {
  title       = "Core nat gateways should be tagged"
  description = "Check if Core nat gateways have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_nat_gateway")
}

control "core_network_load_balancer_untagged" {
  title       = "Core network load balancers should be tagged"
  description = "Check if Core network load balancers have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_network_load_balancer")
}

control "core_network_security_group_untagged" {
  title       = "Core network security groups should be tagged"
  description = "Check if Core network security groups have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_network_security_group")
}

control "core_public_ip_untagged" {
  title       = "Core public ips should be tagged"
  description = "Check if Core public ips have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_public_ip")
}

control "core_public_ip_pool_untagged" {
  title       = "Core public ip pools should be tagged"
  description = "Check if Core public ip pools have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_public_ip_pool")
}

control "core_route_table_untagged" {
  title       = "Core route tables should be tagged"
  description = "Check if Core route tables have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_route_table")
}

control "core_security_list_untagged" {
  title       = "Core security lists should be tagged"
  description = "Check if Core security lists have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_security_list")
}

control "core_service_gateway_untagged" {
  title       = "Core service gateways should be tagged"
  description = "Check if Core service gateways have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_service_gateway")
}

control "core_subnet_untagged" {
  title       = "Core subnets should be tagged"
  description = "Check if Core subnets have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_subnet")
}

control "core_vcn_untagged" {
  title       = "Core vcns should be tagged"
  description = "Check if Core vcns have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_vcn")
}

control "core_volume_untagged" {
  title       = "Core volumes should be tagged"
  description = "Check if Core volumes have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_volume")
}

control "core_volume_backup_untagged" {
  title       = "Core volume backups should be tagged"
  description = "Check if Core volume backups have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_volume_backup")
}

control "core_volume_backup_policy_untagged" {
  title       = "Core volume backup policies should be tagged"
  description = "Check if Core volume backup policies have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_core_volume_backup_policy")
}

control "database_autonomous_database_untagged" {
  title       = "Database autonomous databases should be tagged"
  description = "Check if Database autonomous databases have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_database_autonomous_database")
}

control "database_db_untagged" {
  title       = "Database dbs should be tagged"
  description = "Check if Database dbs have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_database_db")
}

control "database_db_home_untagged" {
  title       = "Database db homes should be tagged"
  description = "Check if Database db homes have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_database_db_home")
}

control "database_db_system_untagged" {
  title       = "Database db systems should be tagged"
  description = "Check if Database db systems have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_database_db_system")
}

control "database_software_image_untagged" {
  title       = "Database software images should be tagged"
  description = "Check if Database software images have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_database_software_image")
}

control "dns_tsig_key_untagged" {
  title       = "Dns tsig keys should be tagged"
  description = "Check if Dns tsig keys have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_dns_tsig_key")
}

control "dns_zone_untagged" {
  title       = "Dns zones should be tagged"
  description = "Check if Dns zones have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_dns_zone")
}

control "events_rule_untagged" {
  title       = "Events rules should be tagged"
  description = "Check if Events rules have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_events_rule")
}

control "file_storage_file_system_untagged" {
  title       = "File storage file systems should be tagged"
  description = "Check if File storage file systems have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_file_storage_file_system")
}

control "file_storage_mount_target_untagged" {
  title       = "File storage mount targets should be tagged"
  description = "Check if File storage mount targets have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_file_storage_mount_target")
}

control "file_storage_snapshot_untagged" {
  title       = "File storage snapshots should be tagged"
  description = "Check if File storage snapshots have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_file_storage_snapshot")
}

control "functions_application_untagged" {
  title       = "Functions applications should be tagged"
  description = "Check if Functions applications have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_functions_application")
}

control "identity_compartment_untagged" {
  title       = "Identity compartments should be tagged"
  description = "Check if Identity compartments have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_identity_compartment")
}

control "identity_dynamic_group_untagged" {
  title       = "Identity dynamic groups should be tagged"
  description = "Check if Identity dynamic groups have at least 1 tag."
  sql         = replace(local.tenant_resource_untagged_sql, "__TABLE_NAME__", "oci_identity_dynamic_group")
}

control "identity_group_untagged" {
  title       = "Identity groups should be tagged"
  description = "Check if Identity groups have at least 1 tag."
  sql         = replace(local.tenant_resource_untagged_sql, "__TABLE_NAME__", "oci_identity_group")
}

control "identity_network_source_untagged" {
  title       = "Identity network sources should be tagged"
  description = "Check if Identity network sources have at least 1 tag."
  sql         = replace(local.tenant_resource_untagged_sql, "__TABLE_NAME__", "oci_identity_network_source")
}

control "identity_policy_untagged" {
  title       = "Identity policies should be tagged"
  description = "Check if Identity policies have at least 1 tag."
  sql         = replace(local.tenant_resource_untagged_sql, "__TABLE_NAME__", "oci_identity_policy")
}

control "identity_tag_namespace_untagged" {
  title       = "Identity tag namespaces should be tagged"
  description = "Check if Identity tag namespaces have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_identity_tag_namespace")
}

control "identity_tenancy_untagged" {
  title       = "Identity tenancies should be tagged"
  description = "Check if Identity tenancies have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_identity_tenancy")
}

control "identity_user_untagged" {
  title       = "Identity users should be tagged"
  description = "Check if Identity users have at least 1 tag."
  sql         = replace(local.tenant_resource_untagged_sql, "__TABLE_NAME__", "oci_identity_user")
}

control "kms_key_untagged" {
  title       = "Kms keys should be tagged"
  description = "Check if Kms keys have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_kms_key")
}

control "kms_vault_untagged" {
  title       = "Kms vaults should be tagged"
  description = "Check if Kms vaults have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_kms_vault")
}

control "logging_log_untagged" {
  title       = "Logging logs should be tagged"
  description = "Check if Logging logs have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_logging_log")
}

control "logging_log_group_untagged" {
  title       = "Logging log groups should be tagged"
  description = "Check if Logging log groups have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_logging_log_group")
}

control "mysql_backup_untagged" {
  title       = "Mysql backups should be tagged"
  description = "Check if Mysql backups have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_mysql_backup")
}

control "mysql_channel_untagged" {
  title       = "Mysql channels should be tagged"
  description = "Check if Mysql channels have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_mysql_channel")
}

control "mysql_configuration_untagged" {
  title       = "Mysql configurations should be tagged"
  description = "Check if Mysql configurations have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_mysql_configuration")
}

control "mysql_configuration_custom_untagged" {
  title       = "Mysql configuration customs should be tagged"
  description = "Check if Mysql configuration customs have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_mysql_configuration_custom")
}

control "mysql_db_system_untagged" {
  title       = "Mysql db systems should be tagged"
  description = "Check if Mysql db systems have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_mysql_db_system")
}

control "nosql_table_untagged" {
  title       = "Nosql tables should be tagged"
  description = "Check if Nosql tables have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_nosql_table")
}

control "objectstorage_bucket_untagged" {
  title       = "Objectstorage buckets should be tagged"
  description = "Check if Objectstorage buckets have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_objectstorage_bucket")
}

control "ons_subscription_untagged" {
  title       = "Ons subscriptions should be tagged"
  description = "Check if Ons subscriptions have at least 1 tag."
  sql         = replace(local.compartment_resource_untagged_sql, "__TABLE_NAME__", "oci_ons_subscription")
}
