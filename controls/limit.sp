variable "tag_limit" {
  type        = number
  description = "Number of tags allowed on a resource."
}

locals {
  tenant_resource_limit_sql = <<EOT
    with analysis as (
      select
        a.id,
        a.title,
        cardinality(array(select jsonb_object_keys(a.tags))) as num_tag_keys,
        t.title as tenant
      from
        __TABLE_NAME__ as a,
        oci_identity_tenancy as t
    )
    select
      title as resource,
      case
        when num_tag_keys > $1::integer then 'alarm'
        else 'ok'
      end as status,
      title || ' has ' || num_tag_keys || ' tag(s).' as reason,
      tenant
    from
      analysis
  EOT

  compartment_resource_limit_sql = <<EOT
    with analysis as (
      select
        a.id,
        a.title,
        cardinality(array(select jsonb_object_keys(a.tags))) as num_tag_keys,
        coalesce(c.name, 'root') as compartment
      from
        __TABLE_NAME__ a
        left join oci_identity_compartment c on c.id = a.compartment_id
    )
    select
      title as resource,
      case
        when num_tag_keys > $1::integer then 'alarm'
        else 'ok'
      end as status,
      title || ' has ' || num_tag_keys || ' tag(s).' as reason,
      compartment
    from
      analysis
  EOT
}

benchmark "limit" {
  title       = "Limit"
  description = "The number of tags on each resource should be monitored to avoid hitting the limit unexpectedly."
  children = [
    control.analytics_instance_tag_limit,
    control.apigateway_api_tag_limit,
    control.autoscaling_auto_scaling_configuration_tag_limit,
    control.budget_alert_rule_tag_limit,
    control.budget_budget_tag_limit,
    control.cloud_guard_detector_recipe_tag_limit,
    control.cloud_guard_target_tag_limit,
    control.core_block_volume_replica_tag_limit,
    control.core_boot_volume_tag_limit,
    control.core_boot_volume_backup_tag_limit,
    control.core_boot_volume_replica_tag_limit,
    control.core_dhcp_options_tag_limit,
    control.core_drg_tag_limit,
    control.core_image_tag_limit,
    control.core_image_custom_tag_limit,
    control.core_instance_tag_limit,
    control.core_internet_gateway_tag_limit,
    control.core_load_balancer_tag_limit,
    control.core_local_peering_gateway_tag_limit,
    control.core_nat_gateway_tag_limit,
    control.core_network_load_balancer_tag_limit,
    control.core_network_security_group_tag_limit,
    control.core_public_ip_tag_limit,
    control.core_public_ip_pool_tag_limit,
    control.core_route_table_tag_limit,
    control.core_security_list_tag_limit,
    control.core_service_gateway_tag_limit,
    control.core_subnet_tag_limit,
    control.core_vcn_tag_limit,
    control.core_volume_tag_limit,
    control.core_volume_backup_tag_limit,
    control.core_volume_backup_policy_tag_limit,
    control.database_autonomous_database_tag_limit,
    control.database_db_tag_limit,
    control.database_db_home_tag_limit,
    control.database_db_system_tag_limit,
    control.database_software_image_tag_limit,
    control.dns_tsig_key_tag_limit,
    control.dns_zone_tag_limit,
    control.events_rule_tag_limit,
    control.file_storage_file_system_tag_limit,
    control.file_storage_mount_target_tag_limit,
    control.file_storage_snapshot_tag_limit,
    control.functions_application_tag_limit,
    control.identity_compartment_tag_limit,
    control.identity_dynamic_group_tag_limit,
    control.identity_group_tag_limit,
    control.identity_network_source_tag_limit,
    control.identity_policy_tag_limit,
    control.identity_tag_namespace_tag_limit,
    control.identity_tenancy_tag_limit,
    control.identity_user_tag_limit,
    control.kms_key_tag_limit,
    control.kms_vault_tag_limit,
    control.logging_log_tag_limit,
    control.logging_log_group_tag_limit,
    control.mysql_backup_tag_limit,
    control.mysql_channel_tag_limit,
    control.mysql_configuration_tag_limit,
    control.mysql_configuration_custom_tag_limit,
    control.mysql_db_system_tag_limit,
    control.nosql_table_tag_limit,
    control.objectstorage_bucket_tag_limit
  ]
}


control "analytics_instance_tag_limit" {
  title       = "Analytics Cloud instances should not exceed tag limit"
  description = "Check if the number of tags on Analytics Cloud instances do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_analytics_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "apigateway_api_tag_limit" {
  title       = "API Gateway APIs should not exceed tag limit"
  description = "Check if the number of tags on API Gateway APIs do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_apigateway_api")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "autoscaling_auto_scaling_configuration_tag_limit" {
  title       = "Autoscaling auto scaling configurations should not exceed tag limit"
  description = "Check if the number of tags on Autoscaling auto scaling configurations do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_autoscaling_auto_scaling_configuration")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "budget_alert_rule_tag_limit" {
  title       = "Budgets alert rules should not exceed tag limit"
  description = "Check if the number of tags on Budgets alert rules do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_budget_alert_rule")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "budget_budget_tag_limit" {
  title       = "Budgets should not exceed tag limit"
  description = "Check if the number of tags on Budgets do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_budget_budget")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloud_guard_detector_recipe_tag_limit" {
  title       = "Cloud Guard detector recipes should not exceed tag limit"
  description = "Check if the number of tags on Cloud Guard detector recipes do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_cloud_guard_detector_recipe")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloud_guard_managed_list_tag_limit" {
  title       = "Cloud Guard managed lists should not exceed tag limit"
  description = "Check if the number of tags on Cloud Guard managed lists do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_cloud_guard_managed_list")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloud_guard_responder_recipe_tag_limit" {
  title       = "Cloud Guard responder recipes should not exceed tag limit"
  description = "Check if the number of tags on Cloud Guard responder recipes do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_cloud_guard_responder_recipe")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloud_guard_target_tag_limit" {
  title       = "Cloud Guard targets should not exceed tag limit"
  description = "Check if the number of tags on Cloud Guard targets do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_cloud_guard_target")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_block_volume_replica_tag_limit" {
  title       = "Core block volume replicas should not exceed tag limit"
  description = "Check if the number of tags on Core block volume replicas do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_block_volume_replica")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_boot_volume_tag_limit" {
  title       = "Core boot volumes should not exceed tag limit"
  description = "Check if the number of tags on Core boot volumes do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_boot_volume")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_boot_volume_backup_tag_limit" {
  title       = "Core boot volume backups should not exceed tag limit"
  description = "Check if the number of tags on Core boot volume backups do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_boot_volume_backup")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_boot_volume_replica_tag_limit" {
  title       = "Core boot volume replicas should not exceed tag limit"
  description = "Check if the number of tags on Core boot volume replicas do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_boot_volume_replica")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_dhcp_options_tag_limit" {
  title       = "Core DHCP options should not exceed tag limit"
  description = "Check if the number of tags on Core DHCP options do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_dhcp_options")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_drg_tag_limit" {
  title       = "Core DRGs should not exceed tag limit"
  description = "Check if the number of tags on Core DRGs do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_drg")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_image_tag_limit" {
  title       = "Core images should not exceed tag limit"
  description = "Check if the number of tags on Core images do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_image")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_image_custom_tag_limit" {
  title       = "Core image customs should not exceed tag limit"
  description = "Check if the number of tags on Core image customs do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_image_custom")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_instance_tag_limit" {
  title       = "Core instances should not exceed tag limit"
  description = "Check if the number of tags on Core instances do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_internet_gateway_tag_limit" {
  title       = "Core internet gateways should not exceed tag limit"
  description = "Check if the number of tags on Core internet gateways do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_internet_gateway")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_load_balancer_tag_limit" {
  title       = "Core load balancers should not exceed tag limit"
  description = "Check if the number of tags on Core load balancers do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_load_balancer")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_local_peering_gateway_tag_limit" {
  title       = "Core local peering gateways should not exceed tag limit"
  description = "Check if the number of tags on Core local peering gateways do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_local_peering_gateway")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_nat_gateway_tag_limit" {
  title       = "Core nat gateways should not exceed tag limit"
  description = "Check if the number of tags on Core nat gateways do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_nat_gateway")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_network_load_balancer_tag_limit" {
  title       = "Core network load balancers should not exceed tag limit"
  description = "Check if the number of tags on Core network load balancers do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_network_load_balancer")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_network_security_group_tag_limit" {
  title       = "Core network security groups should not exceed tag limit"
  description = "Check if the number of tags on Core network security groups do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_network_security_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_public_ip_tag_limit" {
  title       = "Core public IPs should not exceed tag limit"
  description = "Check if the number of tags on Core public IPs do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_public_ip")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_public_ip_pool_tag_limit" {
  title       = "Core public IP pools should not exceed tag limit"
  description = "Check if the number of tags on Core public IP pools do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_public_ip_pool")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_route_table_tag_limit" {
  title       = "Core route tables should not exceed tag limit"
  description = "Check if the number of tags on Core route tables do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_route_table")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_security_list_tag_limit" {
  title       = "Core security lists should not exceed tag limit"
  description = "Check if the number of tags on Core security lists do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_security_list")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_service_gateway_tag_limit" {
  title       = "Core service gateways should not exceed tag limit"
  description = "Check if the number of tags on Core service gateways do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_service_gateway")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_subnet_tag_limit" {
  title       = "Core subnets should not exceed tag limit"
  description = "Check if the number of tags on Core subnets do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_subnet")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_vcn_tag_limit" {
  title       = "Core VCNs should not exceed tag limit"
  description = "Check if the number of tags on Core VCNs do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_vcn")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_volume_tag_limit" {
  title       = "Core volumes should not exceed tag limit"
  description = "Check if the number of tags on Core volumes do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_volume")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_volume_backup_tag_limit" {
  title       = "Core volume backups should not exceed tag limit"
  description = "Check if the number of tags on Core volume backups do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_volume_backup")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "core_volume_backup_policy_tag_limit" {
  title       = "Core volume backup policies should not exceed tag limit"
  description = "Check if the number of tags on Core volume backup policies do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_core_volume_backup_policy")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "database_autonomous_database_tag_limit" {
  title       = "Database autonomous databases should not exceed tag limit"
  description = "Check if the number of tags on Database autonomous databases do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_database_autonomous_database")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "database_db_tag_limit" {
  title       = "Database DBs should not exceed tag limit"
  description = "Check if the number of tags on Database DBs do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_database_db")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "database_db_home_tag_limit" {
  title       = "Database DB homes should not exceed tag limit"
  description = "Check if the number of tags on Database DB homes do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_database_db_home")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "database_db_system_tag_limit" {
  title       = "Database DB systems should not exceed tag limit"
  description = "Check if the number of tags on Database DB systems do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_database_db_system")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "database_software_image_tag_limit" {
  title       = "Database software images should not exceed tag limit"
  description = "Check if the number of tags on Database software images do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_database_software_image")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "dns_tsig_key_tag_limit" {
  title       = "DNS TSIG keys should not exceed tag limit"
  description = "Check if the number of tags on DNS TSIG keys do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_dns_tsig_key")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "dns_zone_tag_limit" {
  title       = "DNS zones should not exceed tag limit"
  description = "Check if the number of tags on DNS zones do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_dns_zone")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "events_rule_tag_limit" {
  title       = "Events rules should not exceed tag limit"
  description = "Check if the number of tags on Events rules do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_events_rule")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "file_storage_file_system_tag_limit" {
  title       = "File Storage file systems should not exceed tag limit"
  description = "Check if the number of tags on File Storage file systems do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_file_storage_file_system")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "file_storage_mount_target_tag_limit" {
  title       = "File Storage mount targets should not exceed tag limit"
  description = "Check if the number of tags on File Storage mount targets do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_file_storage_mount_target")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "file_storage_snapshot_tag_limit" {
  title       = "File Storage snapshots should not exceed tag limit"
  description = "Check if the number of tags on File Storage snapshots do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_file_storage_snapshot")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "functions_application_tag_limit" {
  title       = "Functions applications should not exceed tag limit"
  description = "Check if the number of tags on Functions applications do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_functions_application")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_compartment_tag_limit" {
  title       = "Identity compartments should not exceed tag limit"
  description = "Check if the number of tags on Identity compartments do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_identity_compartment")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_dynamic_group_tag_limit" {
  title       = "Identity dynamic groups should not exceed tag limit"
  description = "Check if the number of tags on Identity dynamic groups do not exceed the limit."
  sql         = replace(local.tenant_resource_limit_sql, "__TABLE_NAME__", "oci_identity_dynamic_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_group_tag_limit" {
  title       = "Identity groups should not exceed tag limit"
  description = "Check if the number of tags on Identity groups do not exceed the limit."
  sql         = replace(local.tenant_resource_limit_sql, "__TABLE_NAME__", "oci_identity_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_network_source_tag_limit" {
  title       = "Identity network sources should not exceed tag limit"
  description = "Check if the number of tags on Identity network sources do not exceed the limit."
  sql         = replace(local.tenant_resource_limit_sql, "__TABLE_NAME__", "oci_identity_network_source")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_policy_tag_limit" {
  title       = "Identity policies should not exceed tag limit"
  description = "Check if the number of tags on Identity policies do not exceed the limit."
  sql         = replace(local.tenant_resource_limit_sql, "__TABLE_NAME__", "oci_identity_policy")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_tag_namespace_tag_limit" {
  title       = "Identity tag namespaces should not exceed tag limit"
  description = "Check if the number of tags on Identity tag namespaces do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_identity_tag_namespace")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_tenancy_tag_limit" {
  title       = "Identity tenancies should not exceed tag limit"
  description = "Check if the number of tags on Identity tenancies do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_identity_tenancy")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "identity_user_tag_limit" {
  title       = "Identity users should not exceed tag limit"
  description = "Check if the number of tags on Identity users do not exceed the limit."
  sql         = replace(local.tenant_resource_limit_sql, "__TABLE_NAME__", "oci_identity_user")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "kms_key_tag_limit" {
  title       = "Kms keys should not exceed tag limit"
  description = "Check if the number of tags on Kms keys do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_kms_key")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "kms_vault_tag_limit" {
  title       = "Kms vaults should not exceed tag limit"
  description = "Check if the number of tags on Kms vaults do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_kms_vault")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "logging_log_tag_limit" {
  title       = "Logging logs should not exceed tag limit"
  description = "Check if the number of tags on Logging logs do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_logging_log")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "logging_log_group_tag_limit" {
  title       = "Logging log groups should not exceed tag limit"
  description = "Check if the number of tags on Logging log groups do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_logging_log_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_backup_tag_limit" {
  title       = "MySQL backups should not exceed tag limit"
  description = "Check if the number of tags on MySQL backups do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_mysql_backup")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_channel_tag_limit" {
  title       = "MySQL channels should not exceed tag limit"
  description = "Check if the number of tags on MySQL channels do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_mysql_channel")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_configuration_tag_limit" {
  title       = "MySQL configurations should not exceed tag limit"
  description = "Check if the number of tags on MySQL configurations do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_mysql_configuration")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_configuration_custom_tag_limit" {
  title       = "MySQL configuration customs should not exceed tag limit"
  description = "Check if the number of tags on MySQL configuration customs do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_mysql_configuration_custom")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_db_system_tag_limit" {
  title       = "MySQL DB systems should not exceed tag limit"
  description = "Check if the number of tags on MySQL DB systems do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_mysql_db_system")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "nosql_table_tag_limit" {
  title       = "NoSQL tables should not exceed tag limit"
  description = "Check if the number of tags on NoSQL tables do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_nosql_table")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "objectstorage_bucket_tag_limit" {
  title       = "Objectstorage buckets should not exceed tag limit"
  description = "Check if the number of tags on Objectstorage buckets do not exceed the limit."
  sql         = replace(local.compartment_resource_limit_sql, "__TABLE_NAME__", "oci_objectstorage_bucket")
  param "tag_limit" {
    default = var.tag_limit
  }
}
