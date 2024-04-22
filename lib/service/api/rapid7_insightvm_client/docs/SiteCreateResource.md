# SwaggerClient::SiteCreateResource

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**description** | **String** | The site&#x27;s description. | [optional] 
**engine_id** | **Integer** | The identifier of a scan engine. Default scan engine is selected when not specified. | [optional] 
**importance** | **String** | The site importance. Defaults to &#x60;\&quot;normal\&quot;&#x60; if not specified. | [optional] 
**links** | [**Array&lt;Link&gt;**](Link.md) |  | [optional] 
**name** | **String** | The site name. Name must be unique. | 
**scan** | [**ScanScope**](ScanScope.md) |  | [optional] 
**scan_template_id** | **String** | The identifier of a scan template. Default scan template is selected when not specified. | [optional] 

