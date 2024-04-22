# SwaggerClient::UserEdit

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**authentication** | [**CreateAuthenticationSource**](CreateAuthenticationSource.md) |  | [optional] 
**email** | **String** | The email address of the user. | [optional] 
**enabled** | **BOOLEAN** | Whether the user account is enabled. Defaults to &#x60;true&#x60;. | [optional] 
**id** | **Integer** | The identifier of the user. | [optional] 
**locale** | [**LocalePreferences**](LocalePreferences.md) |  | [optional] 
**locked** | **BOOLEAN** | Whether the user account is locked (exceeded maximum password retry attempts). | [optional] 
**login** | **String** | The login name of the user. | 
**name** | **String** | The full name of the user. | 
**password** | **String** | The password to use for the user. | 
**password_reset_on_login** | **BOOLEAN** | Whether to require a reset of the user&#x27;s password upon first login. Defaults to &#x60;false&#x60;. | [optional] 
**role** | [**UserCreateRole**](UserCreateRole.md) |  | 

