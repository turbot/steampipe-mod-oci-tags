variable "mandatory_tags" {
  type        = list(string)
  description = "A list of mandatory tags to check for."
}

locals {
  tenant_resource_mandatory_sql = <<EOT
    with analysis as (
      select
        a.id,
        a.title,
        a.tags ?& $1 as has_mandatory_tags,
        to_jsonb($1) - array(select jsonb_object_keys(a.tags)) as missing_tags,
        t.title as tenant
      from
        __TABLE_NAME__ as a,
        oci_identity_tenancy as t
    )
    select
      title as resource,
      case
        when has_mandatory_tags then 'ok'
        else 'alarm'
      end as status,
      case
        when has_mandatory_tags then title || ' has all mandatory tags.'
        else title || ' is missing tags: ' || array_to_string(array(select jsonb_array_elements_text(missing_tags)), ', ') || '.'
      end as reason,
      tenant
    from
      analysis
  EOT
}

locals {
  compartment_resource_mandatory_sql = <<EOT
    with analysis as (
      select
        a.id,
        a.title,
        a.tags ?& $1 as has_mandatory_tags,
        to_jsonb($1) - array(select jsonb_object_keys(a.tags)) as missing_tags,
        coalesce(c.name, 'root') as compartment
      from
        __TABLE_NAME__ as a
        left join oci_identity_compartment c on c.id = a.compartment_id
    )
    select
      title as resource,
      case
        when has_mandatory_tags then 'ok'
        else 'alarm'
      end as status,
      case
        when has_mandatory_tags then title || ' has all mandatory tags.'
        else title || ' is missing tags: ' || array_to_string(array(select jsonb_array_elements_text(missing_tags)), ', ') || '.'
      end as reason,
      compartment
    from
      analysis
  EOT
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


control "analytics_instance_mandatory" {
  title       = "Analytics Cloud instances should have mandatory tags"
  description = "Check if Analytics Cloud instances have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_analytics_instance")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "apigateway_api_mandatory" {
  title       = "API Gateway APIs should have mandatory tags"
  description = "Check if API Gateway APIs have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_apigateway_api")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "autoscaling_auto_scaling_configuration_mandatory" {
  title       = "Autoscaling auto scaling configurations should have mandatory tags"
  description = "Check if Autoscaling auto scaling configurations have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_autoscaling_auto_scaling_configuration")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "budget_alert_rule_mandatory" {
  title       = "Budgets alert rules should have mandatory tags"
  description = "Check if Budgets alert rules have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_budget_alert_rule")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "budget_budget_mandatory" {
  title       = "Budgets should have mandatory tags"
  description = "Check if Budgets have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_budget_budget")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cloud_guard_detector_recipe_mandatory" {
  title       = "Cloud Guard detector recipes should have mandatory tags"
  description = "Check if Cloud Guard detector recipes have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_cloud_guard_detector_recipe")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cloud_guard_managed_list_mandatory" {
  title       = "Cloud Guard managed lists should have mandatory tags"
  description = "Check if Cloud Guard managed lists have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_cloud_guard_managed_list")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cloud_guard_responder_recipe_mandatory" {
  title       = "Cloud Guard responder recipes should have mandatory tags"
  description = "Check if Cloud Guard responder recipes have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_cloud_guard_responder_recipe")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cloud_guard_target_mandatory" {
  title       = "Cloud Guard targets should have mandatory tags"
  description = "Check if Cloud Guard targets have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_cloud_guard_target")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_block_volume_replica_mandatory" {
  title       = "Core block volume replicas should have mandatory tags"
  description = "Check if Core block volume replicas have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_block_volume_replica")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_boot_volume_mandatory" {
  title       = "Core boot volumes should have mandatory tags"
  description = "Check if Core boot volumes have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_boot_volume")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_boot_volume_backup_mandatory" {
  title       = "Core boot volume backups should have mandatory tags"
  description = "Check if Core boot volume backups have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_boot_volume_backup")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_boot_volume_replica_mandatory" {
  title       = "Core boot volume replicas should have mandatory tags"
  description = "Check if Core boot volume replicas have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_boot_volume_replica")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_dhcp_options_mandatory" {
  title       = "Core DHCP options should have mandatory tags"
  description = "Check if Core DHCP options have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_dhcp_options")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_drg_mandatory" {
  title       = "Core DRGs should have mandatory tags"
  description = "Check if Core DRGs have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_drg")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_image_mandatory" {
  title       = "Core images should have mandatory tags"
  description = "Check if Core images have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_image")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_image_custom_mandatory" {
  title       = "Core image customs should have mandatory tags"
  description = "Check if Core image customs have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_image_custom")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_instance_mandatory" {
  title       = "Core instances should have mandatory tags"
  description = "Check if Core instances have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_instance")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_internet_gateway_mandatory" {
  title       = "Core internet gateways should have mandatory tags"
  description = "Check if Core internet gateways have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_internet_gateway")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_load_balancer_mandatory" {
  title       = "Core load balancers should have mandatory tags"
  description = "Check if Core load balancers have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_load_balancer")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_local_peering_gateway_mandatory" {
  title       = "Core local peering gateways should have mandatory tags"
  description = "Check if Core local peering gateways have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_local_peering_gateway")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_nat_gateway_mandatory" {
  title       = "Core nat gateways should have mandatory tags"
  description = "Check if Core nat gateways have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_nat_gateway")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_network_load_balancer_mandatory" {
  title       = "Core network load balancers should have mandatory tags"
  description = "Check if Core network load balancers have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_network_load_balancer")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_network_security_group_mandatory" {
  title       = "Core network security groups should have mandatory tags"
  description = "Check if Core network security groups have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_network_security_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_public_ip_mandatory" {
  title       = "Core public IPs should have mandatory tags"
  description = "Check if Core public IPs have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_public_ip")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_public_ip_pool_mandatory" {
  title       = "Core public IP pools should have mandatory tags"
  description = "Check if Core public IP pools have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_public_ip_pool")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_route_table_mandatory" {
  title       = "Core route tables should have mandatory tags"
  description = "Check if Core route tables have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_route_table")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_security_list_mandatory" {
  title       = "Core security lists should have mandatory tags"
  description = "Check if Core security lists have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_security_list")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_service_gateway_mandatory" {
  title       = "Core service gateways should have mandatory tags"
  description = "Check if Core service gateways have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_service_gateway")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_subnet_mandatory" {
  title       = "Core subnets should have mandatory tags"
  description = "Check if Core subnets have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_subnet")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_vcn_mandatory" {
  title       = "Core VCNs should have mandatory tags"
  description = "Check if Core VCNs have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_vcn")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_volume_mandatory" {
  title       = "Core volumes should have mandatory tags"
  description = "Check if Core volumes have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_volume")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_volume_backup_mandatory" {
  title       = "Core volume backups should have mandatory tags"
  description = "Check if Core volume backups have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_volume_backup")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "core_volume_backup_policy_mandatory" {
  title       = "Core volume backup policies should have mandatory tags"
  description = "Check if Core volume backup policies have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_core_volume_backup_policy")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "database_autonomous_database_mandatory" {
  title       = "Database autonomous databases should have mandatory tags"
  description = "Check if Database autonomous databases have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_database_autonomous_database")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "database_db_mandatory" {
  title       = "Database DBs should have mandatory tags"
  description = "Check if Database DBs have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_database_db")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "database_db_home_mandatory" {
  title       = "Database DB homes should have mandatory tags"
  description = "Check if Database DB homes have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_database_db_home")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "database_db_system_mandatory" {
  title       = "Database DB systems should have mandatory tags"
  description = "Check if Database DB systems have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_database_db_system")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "database_software_image_mandatory" {
  title       = "Database software images should have mandatory tags"
  description = "Check if Database software images have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_database_software_image")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "dns_tsig_key_mandatory" {
  title       = "DNS TSIG keys should have mandatory tags"
  description = "Check if DNS TSIG keys have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_dns_tsig_key")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "dns_zone_mandatory" {
  title       = "DNS zones should have mandatory tags"
  description = "Check if DNS zones have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_dns_zone")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "events_rule_mandatory" {
  title       = "Events rules should have mandatory tags"
  description = "Check if Events rules have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_events_rule")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "file_storage_file_system_mandatory" {
  title       = "File Storage file systems should have mandatory tags"
  description = "Check if File Storage file systems have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_file_storage_file_system")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "file_storage_mount_target_mandatory" {
  title       = "File Storage mount targets should have mandatory tags"
  description = "Check if File Storage mount targets have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_file_storage_mount_target")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "file_storage_snapshot_mandatory" {
  title       = "File Storage snapshots should have mandatory tags"
  description = "Check if File Storage snapshots have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_file_storage_snapshot")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "functions_application_mandatory" {
  title       = "Functions applications should have mandatory tags"
  description = "Check if Functions applications have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_functions_application")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "identity_compartment_mandatory" {
  title       = "Identity compartments should have mandatory tags"
  description = "Check if Identity compartments have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_identity_compartment")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "identity_dynamic_group_mandatory" {
  title       = "Identity dynamic groups should have mandatory tags"
  description = "Check if Identity dynamic groups have mandatory tags."
  sql         = replace(local.tenant_resource_mandatory_sql, "__TABLE_NAME__", "oci_identity_dynamic_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "identity_group_mandatory" {
  title       = "Identity groups should have mandatory tags"
  description = "Check if Identity groups have mandatory tags."
  sql         = replace(local.tenant_resource_mandatory_sql, "__TABLE_NAME__", "oci_identity_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "identity_network_source_mandatory" {
  title       = "Identity network sources should have mandatory tags"
  description = "Check if Identity network sources have mandatory tags."
  sql         = replace(local.tenant_resource_mandatory_sql, "__TABLE_NAME__", "oci_identity_network_source")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "identity_policy_mandatory" {
  title       = "Identity policies should have mandatory tags"
  description = "Check if Identity policies have mandatory tags."
  sql         = replace(local.tenant_resource_mandatory_sql, "__TABLE_NAME__", "oci_identity_policy")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "identity_tag_namespace_mandatory" {
  title       = "Identity tag namespaces should have mandatory tags"
  description = "Check if Identity tag namespaces have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_identity_tag_namespace")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "identity_tenancy_mandatory" {
  title       = "Identity tenancies should have mandatory tags"
  description = "Check if Identity tenancies have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_identity_tenancy")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "identity_user_mandatory" {
  title       = "Identity users should have mandatory tags"
  description = "Check if Identity users have mandatory tags."
  sql         = replace(local.tenant_resource_mandatory_sql, "__TABLE_NAME__", "oci_identity_user")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "kms_key_mandatory" {
  title       = "Kms keys should have mandatory tags"
  description = "Check if Kms keys have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_kms_key")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "kms_vault_mandatory" {
  title       = "Kms vaults should have mandatory tags"
  description = "Check if Kms vaults have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_kms_vault")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "logging_log_mandatory" {
  title       = "Logging logs should have mandatory tags"
  description = "Check if Logging logs have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_logging_log")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "logging_log_group_mandatory" {
  title       = "Logging log groups should have mandatory tags"
  description = "Check if Logging log groups have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_logging_log_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "mysql_backup_mandatory" {
  title       = "MySQL backups should have mandatory tags"
  description = "Check if MySQL backups have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_mysql_backup")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "mysql_channel_mandatory" {
  title       = "MySQL channels should have mandatory tags"
  description = "Check if MySQL channels have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_mysql_channel")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "mysql_configuration_mandatory" {
  title       = "MySQL configurations should have mandatory tags"
  description = "Check if MySQL configurations have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_mysql_configuration")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "mysql_configuration_custom_mandatory" {
  title       = "MySQL configuration customs should have mandatory tags"
  description = "Check if MySQL configuration customs have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_mysql_configuration_custom")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "mysql_db_system_mandatory" {
  title       = "MySQL DB systems should have mandatory tags"
  description = "Check if MySQL DB systems have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_mysql_db_system")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "nosql_table_mandatory" {
  title       = "NoSQL tables should have mandatory tags"
  description = "Check if NoSQL tables have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_nosql_table")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "objectstorage_bucket_mandatory" {
  title       = "Objectstorage buckets should have mandatory tags"
  description = "Check if Objectstorage buckets have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_objectstorage_bucket")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ons_subscription_mandatory" {
  title       = "ONS subscriptions should have mandatory tags"
  description = "Check if ONS subscriptions have mandatory tags."
  sql         = replace(local.compartment_resource_mandatory_sql, "__TABLE_NAME__", "oci_ons_subscription")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}
