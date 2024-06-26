# SwaggerClient::ScanTemplateWebSpider

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**dont_scan_multi_use_devices** | **BOOLEAN** | Whether scanning of multi-use devices, such as printers or print servers should be avoided. | [optional] 
**include_query_strings** | **BOOLEAN** | Whether query strings are using in URLs when web spidering. This causes the web spider to make many more requests to the Web server. This will increase overall scan time and possibly affect the Web server&#x27;s performance for legitimate users. | [optional] 
**paths** | [**ScanTemplateWebSpiderPaths**](ScanTemplateWebSpiderPaths.md) |  | [optional] 
**patterns** | [**ScanTemplateWebSpiderPatterns**](ScanTemplateWebSpiderPatterns.md) |  | [optional] 
**performance** | [**ScanTemplateWebSpiderPerformance**](ScanTemplateWebSpiderPerformance.md) |  | [optional] 
**test_common_usernames_and_passwords** | **BOOLEAN** | Whether to determine if discovered logon forms accept commonly used user names or passwords. The process may cause authentication services with certain security policies to lock out accounts with these credentials. | [optional] 
**test_xss_in_single_scan** | **BOOLEAN** | Whether to test for persistent cross-site scripting during a single scan. This test helps to reduce the risk of dangerous attacks via malicious code stored on Web servers. Enabling it may increase Web spider scan times. | [optional] 
**user_agent** | **String** | The &#x60;User-Agent&#x60; to use when web spidering. Defaults to &#x60;\&quot;Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 6.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)\&quot;&#x60;. | [optional] 

