# SwaggerClient::SnmpAlert

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**community** | **String** | The SNMP community name. | 
**enabled** | **BOOLEAN** | Flag indicating the alert is enabled. | 
**enabled_scan_events** | [**ScanEvents**](ScanEvents.md) |  | [optional] 
**enabled_vulnerability_events** | [**VulnerabilityEvents**](VulnerabilityEvents.md) |  | [optional] 
**id** | **Integer** | The identifier of the alert. | [optional] 
**links** | [**Array&lt;Link&gt;**](Link.md) |  | [optional] 
**maximum_alerts** | **Integer** | The maximum number of alerts that will be issued. To disable maximum alerts, omit the property in the request or specify the property with a value of &#x60;null&#x60;. | [optional] 
**name** | **String** | The name of the alert. | 
**notification** | **String** | The type of alert. | 
**server** | **String** | The SNMP management server. | 

