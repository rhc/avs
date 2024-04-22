# SwaggerClient::Report

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**baseline** | **Object** | If the template is &#x60;baseline-comparison&#x60; or &#x60;executive-overview&#x60; the baseline scan to compare against. This can be the &#x60;first&#x60; scan, the &#x60;previous&#x60; scan, or a scan as of a specified date. Defaults to &#x60;previous&#x60;. | [optional] 
**bureau** | **String** | The name of the bureau for a CyberScope report. Only used when the format is &#x60;\&quot;cyberscope-xml\&quot;&#x60;. | [optional] 
**component** | **String** | The name of the component for a CyberScope report. Only used when the format is &#x60;\&quot;cyberscope-xml\&quot;&#x60;. | [optional] 
**email** | [**ReportEmail**](ReportEmail.md) |  | [optional] 
**enclave** | **String** | The name of the enclave for a CyberScope report. Only used when the format is &#x60;\&quot;cyberscope-xml\&quot;&#x60;. | [optional] 
**filters** | [**ReportConfigFiltersResource**](ReportConfigFiltersResource.md) |  | [optional] 
**format** | **String** | The output format of the report. The format will restrict the available templates and parameters that can be specified. | [optional] 
**frequency** | [**ReportFrequency**](ReportFrequency.md) |  | [optional] 
**id** | **Integer** | The identifier of the report. | [optional] 
**language** | **String** | The locale (language) in which the report is generated | [optional] 
**links** | [**Array&lt;Link&gt;**](Link.md) | Hypermedia links to corresponding or related resources. | [optional] 
**name** | **String** | The name of the report. | [optional] 
**organization** | **String** | The organization used for a XCCDF XML report. Only used when the format is &#x60;\&quot;xccdf-xml\&quot;&#x60;. | [optional] 
**owner** | **Integer** | The identifier of the report owner. | [optional] 
**policies** | **Array&lt;Integer&gt;** | If the template is &#x60;rule-breakdown-summary&#x60;, &#x60;top-policy-remediations&#x60;, or &#x60;top-policy-remediations-with-details&#x60; the identifiers of the policies to report against. | [optional] 
**policy** | **Integer** | The policy to report on. Only used when the format is &#x60;\&quot;oval-xml\&quot;&#x60;, &#x60;\&quot;\&quot;xccdf-csv\&quot;&#x60;, or &#x60;\&quot;xccdf-xml\&quot;&#x60;. | [optional] 
**query** | **String** | SQL query to run against the Reporting Data Model. Only used when the format is &#x60;\&quot;sql-query\&quot;&#x60;. | [optional] 
**range** | [**RangeResource**](RangeResource.md) |  | [optional] 
**remediation** | [**RemediationResource**](RemediationResource.md) |  | [optional] 
**risk_trend** | [**RiskTrendResource**](RiskTrendResource.md) |  | [optional] 
**scope** | [**ReportConfigScopeResource**](ReportConfigScopeResource.md) |  | [optional] 
**storage** | [**ReportStorage**](ReportStorage.md) |  | [optional] 
**template** | **String** | The template for the report (only required if the format is templatized). | [optional] 
**timezone** | **String** | The timezone the report generates in, such as &#x60;\&quot;America/Los_Angeles\&quot;&#x60;. | [optional] 
**users** | **Array&lt;Integer&gt;** | The identifiers of the users granted explicit access to the report. | [optional] 
**version** | **String** | The version of the report Data Model to report against. Only used when the format is &#x60;\&quot;sql-query\&quot;&#x60;. | [optional] 

