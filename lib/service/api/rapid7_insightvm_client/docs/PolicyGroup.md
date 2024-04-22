# SwaggerClient::PolicyGroup

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**assets** | [**AssetPolicyAssessment**](AssetPolicyAssessment.md) |  | [optional] 
**benchmark** | [**PolicyBenchmark**](PolicyBenchmark.md) |  | [optional] 
**description** | **String** | A description of the policy group. | [optional] 
**id** | **String** | The textual representation of the policy group identifier. | [optional] 
**links** | [**Array&lt;Link&gt;**](Link.md) | Hypermedia links to corresponding or related resources. | [optional] 
**name** | **String** | The name of the policy group. | [optional] 
**policy** | [**PolicyMetadataResource**](PolicyMetadataResource.md) |  | [optional] 
**scope** | **String** | The textual representation of the policy group scope. Policy groups that are automatically available have &#x60;\&quot;Built-in\&quot;&#x60; scope, whereas policy groups created by users have scope as &#x60;\&quot;Custom\&quot;&#x60;. | [optional] 
**status** | **String** | The overall compliance status of the policy group. | [optional] 
**surrogate_id** | **Integer** | The identifier of the policy group. | [optional] 
**title** | **String** | The title of the policy group as visible to the user. | [optional] 

