
from azure.common.credentials import ServicePrincipalCredentials, UserPassCredentials
from azure.monitor import MonitorClient
from azure.mgmt.monitor import  MonitorManagementClient
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.monitor.models import RuleMetricDataSource, rule_email_action,rule_condition, rule_action, rule_data_source
from azure.mgmt.monitor.models import ThresholdRuleCondition
from azure.mgmt.monitor.models import RuleEmailAction
from azure.common.client_factory import get_client_from_cli_profile
from json import  load
from pprint import  pprint
from datetime import datetime
from azure.mgmt.resource.resources import ResourceManagementClient

print("Azure - Get active alerts sample")

monitor_client = get_client_from_cli_profile(MonitorManagementClient)
alert_rules = monitor_client.alert_rules

# Get all resource groups
resource_client = get_client_from_cli_profile(ResourceManagementClient)
rgs = resource_client.resource_groups.list()

for rg in rgs:
    # Get alerts by resource_group
    alerts = alert_rules.list_by_resource_group(rg.name)
    # Get incidents by alert
    for aa in alerts:
        # we only care about the enabled alerts
        if(aa.is_enabled):
            incidents = monitor_client.alert_rule_incidents.list_by_alert_rule(rg.name, aa.name)
            # get the incidents for each alert
            for i in incidents:
                # only the active incidents
                if(i.is_active):
                    print(i)
