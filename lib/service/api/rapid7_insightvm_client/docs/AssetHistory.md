# SwaggerClient::AssetHistory

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**date** | **String** | The date the asset information was collected or changed. | [optional] 
**description** | **String** | Additional information describing the change. | [optional] 
**scan_id** | **Integer** | If a scan-oriented change, the identifier of the corresponding scan the asset was scanned in. | [optional] 
**type** | **String** | The type of change. May be one of:  | Type                                | Source of Data                                              |  | ----------------------------------- | ----------------------------------------------------------- |  | &#x60;ASSET-IMPORT&#x60;, &#x60;EXTERNAL-IMPORT&#x60;   | External source such as the API                             |  | &#x60;EXTERNAL-IMPORT-APPSPIDER&#x60;         | Rapid7 InsightAppSec (previously known as AppSpider)        |  | &#x60;SCAN&#x60;                              | Scan engine scan                                            |  | &#x60;AGENT-IMPORT&#x60;                      | Rapid7 Insight Agent                                        |  | &#x60;ACTIVE-SYNC&#x60;                       | ActiveSync                                                  |  | &#x60;SCAN-LOG-IMPORT&#x60;                   | Manual import of a scan log                                 |  | &#x60;VULNERABILITY_EXCEPTION_APPLIED&#x60;   | Vulnerability exception applied                             |  | &#x60;VULNERABILITY_EXCEPTION_UNAPPLIED&#x60; | Vulnerability exception unapplied                           | | [optional] 
**user** | **String** | If a vulnerability exception change, the login name of the user that performed the operation. | [optional] 
**version** | **Integer** | The version number of the change (a chronological incrementing number starting from 1).  | [optional] 
**vulnerability_exception_id** | **Integer** | If a vulnerability exception change, the identifier of the vulnerability exception that caused the change. | [optional] 

