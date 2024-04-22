# SwaggerClient::ScanEngine

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**address** | **String** | The address the scan engine is hosted. | 
**content_version** | **String** | The content version of the scan engine. | [optional] 
**id** | **Integer** | The identifier of the scan engine. | [optional] 
**is_aws_pre_auth_engine** | **BOOLEAN** | A boolean of whether the Engine is of type AWS Pre Authorized | [optional] 
**last_refreshed_date** | **String** | The date the engine was last refreshed. Date format is in ISO 8601. | [optional] 
**last_updated_date** | **String** | The date the engine was last updated. Date format is in ISO 8601. | [optional] 
**links** | [**Array&lt;Link&gt;**](Link.md) | Hypermedia links to corresponding or related resources. | [optional] 
**name** | **String** | The name of the scan engine. | 
**port** | **Integer** | The port used by the scan engine to communicate with the Security Console. | 
**product_version** | **String** | The product version of the scan engine. | [optional] 
**serial_number** | **String** | ${scan.engine.serial.number | [optional] 
**sites** | **Array&lt;Integer&gt;** | A list of identifiers of each site the scan engine is assigned to. | [optional] 
**status** | **String** | The scan engine status. Can be one of the following values:  | Value                     | Description                                                                                |  | ------------------------- | ------------------------------------------------------------------------------------------ |  | &#x60;\&quot;active\&quot;&#x60;                | The scan engine is active.                                                                 |  | &#x60;\&quot;incompatible-version\&quot;&#x60;  | The product version of the remote scan engine is not compatible with the Security Console. |  | &#x60;\&quot;not-responding\&quot;&#x60;        | The scan engine is not responding to the Security Console.                                 |  | &#x60;\&quot;pending-authorization\&quot;&#x60; | The Security Console is not yet authorized to connect to the scan engine.                  |  | &#x60;\&quot;unknown\&quot;&#x60;               | The status of the scan engine is unknown.                                                  |   | [optional] 

