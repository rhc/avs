# SwaggerClient::MatchedSolution

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**additional_information** | [**AdditionalInformation**](AdditionalInformation.md) |  | [optional] 
**applies_to** | **String** | The systems or software the solution applies to. | [optional] 
**confidence** | **String** | The confidence of the matching process for the solution. | [optional] 
**estimate** | **String** | The estimated duration to apply the solution, in ISO 8601 format. For example: &#x60;\&quot;PT5M\&quot;&#x60;. | [optional] 
**id** | **String** | The identifier of the solution. | [optional] 
**links** | [**Array&lt;Link&gt;**](Link.md) | Hypermedia links to corresponding or related resources. | [optional] 
**matches** | [**Array&lt;SolutionMatch&gt;**](SolutionMatch.md) | The raw matches that were performed in order to select the best solution(s). | [optional] 
**steps** | [**Steps**](Steps.md) |  | [optional] 
**summary** | [**Summary**](Summary.md) |  | [optional] 
**type** | **String** | The type of the solution. One of: &#x60;\&quot;Configuration\&quot;&#x60;, &#x60;\&quot;Rollup patch\&quot;&#x60;, &#x60;\&quot;Patch\&quot;&#x60; | [optional] 

