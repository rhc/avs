# SwaggerClient::ScanTemplateServiceDiscoveryTcp

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**additional_ports** | **Array&lt;Object&gt;** | Additional TCP ports to scan. Individual ports can be specified as numbers or a string, but port ranges must be strings (e.g. &#x60;\&quot;7892-7898\&quot;&#x60;). Defaults to empty. | [optional] 
**excluded_ports** | **Array&lt;Object&gt;** | TCP ports to exclude from scanning. Individual ports can be specified as numbers or a string, but port ranges must be strings (e.g. &#x60;\&quot;7892-7898\&quot;&#x60;). Defaults to empty. | [optional] 
**links** | [**Array&lt;Link&gt;**](Link.md) | Hypermedia links to corresponding or related resources. | [optional] 
**method** | **String** | The method of TCP discovery. Defaults to &#x60;SYN&#x60;. | [optional] 
**ports** | **String** | The TCP ports to scan. Defaults to &#x60;well-known&#x60;. | [optional] 

