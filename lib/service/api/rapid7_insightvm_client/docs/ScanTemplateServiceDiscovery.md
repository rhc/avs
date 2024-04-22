# SwaggerClient::ScanTemplateServiceDiscovery

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**service_name_file** | **String** | An optional file that lists each port and the service that commonly resides on it. If scans cannot identify actual services on ports, service names will be derived from this file in scan results. Defaults to empty. | [optional] 
**tcp** | [**ScanTemplateServiceDiscoveryTcp**](ScanTemplateServiceDiscoveryTcp.md) |  | [optional] 
**udp** | [**ScanTemplateServiceDiscoveryUdp**](ScanTemplateServiceDiscoveryUdp.md) |  | [optional] 

