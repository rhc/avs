# SwaggerClient::SharedCredential

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**account** | [**SharedCredentialAccount**](SharedCredentialAccount.md) |  | 
**description** | **String** | The description of the credential. | [optional] 
**host_restriction** | **String** | The host name or IP address that you want to restrict the credentials to. | [optional] 
**id** | **Integer** | The identifier of the credential. | [optional] 
**name** | **String** | The name of the credential. | 
**port_restriction** | **Integer** | Further restricts the credential to attempt to authenticate on a specific port.  | [optional] 
**site_assignment** | **String** | Assigns the shared scan credential either to be available to all sites or to a specific list of sites. The following table describes each supported value:  | Value | Description |  | ---------- | ---------------- |  | &#x60;\&quot;all-sites\&quot;&#x60; | The shared scan credential is assigned to all current and future sites. |  | &#x60;\&quot;specific-sites\&quot;&#x60; | The shared scan credential is assigned to zero sites by default. Administrators must explicitly assign sites to the shared credential. |  Shared scan credentials assigned to a site can disabled within the site configuration, if needed. | 
**sites** | **Array&lt;Integer&gt;** | List of site identifiers. These sites are explicitly assigned access to the shared scan credential, allowing the site to use the credential for authentication during a scan. This property can only be set if the value of property &#x60;siteAssignment&#x60; is set to &#x60;\&quot;specific-sites\&quot;&#x60;. When the property &#x60;siteAssignment&#x60; is set to &#x60;\&quot;all-sites\&quot;&#x60;, this property will be &#x60;null&#x60;. | [optional] 

