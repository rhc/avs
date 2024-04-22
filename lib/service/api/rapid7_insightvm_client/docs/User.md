# SwaggerClient::User

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**authentication** | [**AuthenticationSource**](AuthenticationSource.md) |  | [optional] 
**email** | **String** | The email address of the user. | [optional] 
**enabled** | **BOOLEAN** | Whether the user account is enabled. | [optional] 
**id** | **Integer** | The identifier of the user. | [optional] 
**links** | [**Array&lt;Link&gt;**](Link.md) | Hypermedia links to corresponding or related resources. | [optional] 
**locale** | [**LocalePreferences**](LocalePreferences.md) |  | [optional] 
**locked** | **BOOLEAN** | Whether the user account is locked (exceeded maximum password retry attempts). | [optional] 
**login** | **String** | The login name of the user. | 
**name** | **String** | The full name of the user. | 
**role** | [**UserRole**](UserRole.md) |  | [optional] 

