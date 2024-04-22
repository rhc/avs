# SwaggerClient::RootApi

All URIs are relative to *https://localhost:3780/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**resources**](RootApi.md#resources) | **GET** /api/3 | Resources

# **resources**
> Links resources

Resources

Returns a listing of the resources (endpoints) that are available to be invoked in this API.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::RootApi.new

begin
  #Resources
  result = api_instance.resources
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling RootApi->resources: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Links**](Links.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=UTF-8



