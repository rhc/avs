=begin
#InsightVM API

## Overview   This guide documents the InsightVM Application Programming Interface (API) Version 3. This API supports the Representation State Transfer (REST) design pattern. Unless noted otherwise this API accepts and produces the `application/json` media type. This API uses Hypermedia as the Engine of Application State (HATEOAS) and is hypermedia friendly. All API connections must be made to the security console using HTTPS.  ## Versioning  Versioning is specified in the URL and the base path of this API is: `https://<host>:<port>/api/3/`.  ## Specification  An <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md\">OpenAPI v2</a> specification (also  known as Swagger 2) of this API is available. Tools such as <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://github.com/swagger-api/swagger-codegen\">swagger-codegen</a> can be used to generate an API client in the language of your choosing using this specification document.  <p class=\"openapi\">Download the specification: <a class=\"openapi-button\" target=\"_blank\" rel=\"noopener noreferrer\" download=\"\" href=\"/insightvm/en-us/api/api-v3.json\"> Download </a></p>  ## Authentication  Authorization to the API uses HTTP Basic Authorization  (see <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://www.ietf.org/rfc/rfc2617.txt\">RFC 2617</a> for more information). Requests must  supply authorization credentials in the `Authorization` header using a Base64 encoded hash of `\"username:password\"`.  <!-- ReDoc-Inject: <security-definitions> -->  ### 2FA  This API supports two-factor authentication (2FA) by supplying an authentication token in addition to the Basic Authorization. The token is specified using the `Token` request header. To leverage two-factor authentication, this must be enabled on the console and be configured for the account accessing the API.  ## Resources  ### Naming  Resource names represent nouns and identify the entity being manipulated or accessed. All collection resources are  pluralized to indicate to the client they are interacting with a collection of multiple resources of the same type. Singular resource names are used when there exists only one resource available to interact with.  The following naming conventions are used by this API:  | Type                                          | Case                     | | --------------------------------------------- | ------------------------ | | Resource names                                | `lower_snake_case`       | | Header, body, and query parameters parameters | `camelCase`              | | JSON fields and property names                | `camelCase`              |  #### Collections  A collection resource is a parent resource for instance resources, but can itself be retrieved and operated on  independently. Collection resources use a pluralized resource name. The resource path for collection resources follow  the convention:  ``` /api/3/{resource_name} ```  #### Instances  An instance resource is a \"leaf\" level resource that may be retrieved, optionally nested within a collection resource. Instance resources are usually retrievable with opaque identifiers. The resource path for instance resources follows  the convention:  ``` /api/3/{resource_name}/{instance_id}... ```  ## Verbs  The following HTTP operations are supported throughout this API. The general usage of the operation and both its failure and success status codes are outlined below.    | Verb      | Usage                                                                                 | Success     | Failure                                                        | | --------- | ------------------------------------------------------------------------------------- | ----------- | -------------------------------------------------------------- | | `GET`     | Used to retrieve a resource by identifier, or a collection of resources by type.      | `200`       | `400`, `401`, `402`, `404`, `405`, `408`, `410`, `415`, `500`  | | `POST`    | Creates a resource with an application-specified identifier.                          | `201`       | `400`, `401`, `404`, `405`, `408`, `413`, `415`, `500`         | | `POST`    | Performs a request to queue an asynchronous job.                                      | `202`       | `400`, `401`, `405`, `408`, `410`, `413`, `415`, `500`         | | `PUT`     | Creates a resource with a client-specified identifier.                                | `200`       | `400`, `401`, `403`, `405`, `408`, `410`, `413`, `415`, `500`  | | `PUT`     | Performs a full update of a resource with a specified identifier.                     | `201`       | `400`, `401`, `403`, `405`, `408`, `410`, `413`, `415`, `500`  | | `DELETE`  | Deletes a resource by identifier or an entire collection of resources.                | `204`       | `400`, `401`, `405`, `408`, `410`, `413`, `415`, `500`         | | `OPTIONS` | Requests what operations are available on a resource.                                 | `200`       | `401`, `404`, `405`, `408`, `500`                              |  ### Common Operations  #### OPTIONS  All resources respond to the `OPTIONS` request, which allows discoverability of available operations that are supported.  The `OPTIONS` response returns the acceptable HTTP operations on that resource within the `Allow` header. The response is always a `200 OK` status.  ### Collection Resources  Collection resources can support the `GET`, `POST`, `PUT`, and `DELETE` operations.  #### GET  The `GET` operation invoked on a collection resource indicates a request to retrieve all, or some, of the entities  contained within the collection. This also includes the optional capability to filter or search resources during the request. The response from a collection listing is a paginated document. See  [hypermedia links](#section/Overview/Paging) for more information.  #### POST  The `POST` is a non-idempotent operation that allows for the creation of a new resource when the resource identifier  is not provided by the system during the creation operation (i.e. the Security Console generates the identifier). The content of the `POST` request is sent in the request body. The response to a successful `POST` request should be a  `201 CREATED` with a valid `Location` header field set to the URI that can be used to access to the newly  created resource.   The `POST` to a collection resource can also be used to interact with asynchronous resources. In this situation,  instead of a `201 CREATED` response, the `202 ACCEPTED` response indicates that processing of the request is not fully  complete but has been accepted for future processing. This request will respond similarly with a `Location` header with  link to the job-oriented asynchronous resource that was created and/or queued.  #### PUT  The `PUT` is an idempotent operation that either performs a create with user-supplied identity, or a full replace or update of a resource by a known identifier. The response to a `PUT` operation to create an entity is a `201 Created` with a valid `Location` header field set to the URI that can be used to access to the newly created resource.  `PUT` on a collection resource replaces all values in the collection. The typical response to a `PUT` operation that  updates an entity is hypermedia links, which may link to related resources caused by the side-effects of the changes  performed.  #### DELETE  The `DELETE` is an idempotent operation that physically deletes a resource, or removes an association between resources. The typical response to a `DELETE` operation is hypermedia links, which may link to related resources caused by the  side-effects of the changes performed.  ### Instance Resources  Instance resources can support the `GET`, `PUT`, `POST`, `PATCH` and `DELETE` operations.  #### GET  Retrieves the details of a specific resource by its identifier. The details retrieved can be controlled through  property selection and property views. The content of the resource is returned within the body of the response in the  acceptable media type.   #### PUT  Allows for and idempotent \"full update\" (complete replacement) on a specific resource. If the resource does not exist,  it will be created; if it does exist, it is completely overwritten. Any omitted properties in the request are assumed to  be undefined/null. For \"partial updates\" use `POST` or `PATCH` instead.   The content of the `PUT` request is sent in the request body. The identifier of the resource is specified within the URL  (not the request body). The response to a successful `PUT` request is a `201 CREATED` to represent the created status,  with a valid `Location` header field set to the URI that can be used to access to the newly created (or fully replaced)  resource.   #### POST  Performs a non-idempotent creation of a new resource. The `POST` of an instance resource most commonly occurs with the  use of nested resources (e.g. searching on a parent collection resource). The response to a `POST` of an instance  resource is typically a `200 OK` if the resource is non-persistent, and a `201 CREATED` if there is a resource  created/persisted as a result of the operation. This varies by endpoint.  #### PATCH  The `PATCH` operation is used to perform a partial update of a resource. `PATCH` is a non-idempotent operation that enforces an atomic mutation of a resource. Only the properties specified in the request are to be overwritten on the  resource it is applied to. If a property is missing, it is assumed to not have changed.  #### DELETE  Permanently removes the individual resource from the system. If the resource is an association between resources, only  the association is removed, not the resources themselves. A successful deletion of the resource should return  `204 NO CONTENT` with no response body. This operation is not fully idempotent, as follow-up requests to delete a  non-existent resource should return a `404 NOT FOUND`.  ## Requests  Unless otherwise indicated, the default request body media type is `application/json`.  ### Headers  Commonly used request headers include:  | Header             | Example                                       | Purpose                                                                                        |                    | ------------------ | --------------------------------------------- | ---------------------------------------------------------------------------------------------- | | `Accept`           | `application/json`                            | Defines what acceptable content types are allowed by the client. For all types, use `*/*`.     | | `Accept-Encoding`  | `deflate, gzip`                               | Allows for the encoding to be specified (such as gzip).                                        | | `Accept-Language`  | `en-US`                                       | Indicates to the server the client's locale (defaults `en-US`).                                | | `Authorization `   | `Basic Base64(\"username:password\")`           | Basic authentication                                                                           | | `Token `           | `123456`                                      | Two-factor authentication token (if enabled)                                                   |  ### Dates & Times  Dates and/or times are specified as strings in the ISO 8601 format(s). The following formats are supported as input:  | Value                       | Format                                                 | Notes                                                 | | --------------------------- | ------------------------------------------------------ | ----------------------------------------------------- | | Date                        | YYYY-MM-DD                                             | Defaults to 12 am UTC (if used for a date & time      | | Date & time only            | YYYY-MM-DD'T'hh:mm:ss[.nnn]                            | Defaults to UTC                                       | | Date & time in UTC          | YYYY-MM-DD'T'hh:mm:ss[.nnn]Z                           |                                                       | | Date & time w/ offset       | YYYY-MM-DD'T'hh:mm:ss[.nnn][+&#124;-]hh:mm             |                                                       | | Date & time w/ zone-offset  | YYYY-MM-DD'T'hh:mm:ss[.nnn][+&#124;-]hh:mm[<zone-id>]  |                                                       |   ### Timezones  Timezones are specified in the regional zone format, such as `\"America/Los_Angeles\"`, `\"Asia/Tokyo\"`, or `\"GMT\"`.   ### Paging  Pagination is supported on certain collection resources using a combination of two query parameters, `page` and `size`.  As these are control parameters, they are prefixed with the underscore character. The page parameter dictates the  zero-based index of the page to retrieve, and the `size` indicates the size of the page.   For example, `/resources?page=2&size=10` will return page 3, with 10 records per page, giving results 21-30.  The maximum page size for a request is 500.  ### Sorting  Sorting is supported on paginated resources with the `sort` query parameter(s). The sort query parameter(s) supports  identifying a single or multi-property sort with a single or multi-direction output. The format of the parameter is:  ``` sort=property[,ASC|DESC]... ```  Therefore, the request `/resources?sort=name,title,DESC` would return the results sorted by the name and title  descending, in that order. The sort directions are either ascending `ASC` or descending `DESC`. With single-order  sorting, all properties are sorted in the same direction. To sort the results with varying orders by property,  multiple sort parameters are passed.    For example, the request `/resources?sort=name,ASC&sort=title,DESC` would sort by name ascending and title  descending, in that order.  ## Responses  The following response statuses may be returned by this API.     | Status | Meaning                  | Usage                                                                                                                                                                    | | ------ | ------------------------ |------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | | `200`  | OK                       | The operation performed without error according to the specification of the request, and no more specific 2xx code is suitable.                                          | | `201`  | Created                  | A create request has been fulfilled and a resource has been created. The resource is available as the URI specified in the response, including the `Location` header.    | | `202`  | Accepted                 | An asynchronous task has been accepted, but not guaranteed, to be processed in the future.                                                                               | | `400`  | Bad Request              | The request was invalid or cannot be otherwise served. The request is not likely to succeed in the future without modifications.                                         | | `401`  | Unauthorized             | The user is unauthorized to perform the operation requested, or does not maintain permissions to perform the operation on the resource specified.                        | | `403`  | Forbidden                | The resource exists to which the user has access, but the operating requested is not permitted.                                                                          | | `404`  | Not Found                | The resource specified could not be located, does not exist, or an unauthenticated client does not have permissions to a resource.                                       | | `405`  | Method Not Allowed       | The operations may not be performed on the specific resource. Allowed operations are returned and may be performed on the resource.                                      | | `408`  | Request Timeout          | The client has failed to complete a request in a timely manner and the request has been discarded.                                                                       | | `413`  | Request Entity Too Large | The request being provided is too large for the server to accept processing.                                                                                             | | `415`  | Unsupported Media Type   | The media type is not supported for the requested resource.                                                                                                              | | `500`  | Internal Server Error    | An internal and unexpected error has occurred on the server at no fault of the client.                                                                                   |  ### Security  The response statuses 401, 403 and 404 need special consideration for security purposes. As necessary,  error statuses and messages may be obscured to strengthen security and prevent information exposure. The following is a  guideline for privileged resource response statuses:  | Use Case                                                           | Access             | Resource           | Permission   | Status       | | ------------------------------------------------------------------ | ------------------ |------------------- | ------------ | ------------ | | Unauthenticated access to an unauthenticated resource.             | Unauthenticated    | Unauthenticated    | Yes          | `20x`        | | Unauthenticated access to an authenticated resource.               | Unauthenticated    | Authenticated      | No           | `401`        | | Unauthenticated access to an authenticated resource.               | Unauthenticated    | Non-existent       | No           | `401`        | | Authenticated access to a unauthenticated resource.                | Authenticated      | Unauthenticated    | Yes          | `20x`        | | Authenticated access to an authenticated, unprivileged resource.   | Authenticated      | Authenticated      | No           | `404`        | | Authenticated access to an authenticated, privileged resource.     | Authenticated      | Authenticated      | Yes          | `20x`        | | Authenticated access to an authenticated, non-existent resource    | Authenticated      | Non-existent       | Yes          | `404`        |  ### Headers  Commonly used response headers include:  | Header                     |  Example                          | Purpose                                                         | | -------------------------- | --------------------------------- | --------------------------------------------------------------- | | `Allow`                    | `OPTIONS, GET`                    | Defines the allowable HTTP operations on a resource.            | | `Cache-Control`            | `no-store, must-revalidate`       | Disables caching of resources (as they are all dynamic).        | | `Content-Encoding`         | `gzip`                            | The encoding of the response body (if any).                     | | `Location`                 |                                   | Refers to the URI of the resource created by a request.         | | `Transfer-Encoding`        | `chunked`                         | Specified the encoding used to transform response.              | | `Retry-After`              | 5000                              | Indicates the time to wait before retrying a request.           | | `X-Content-Type-Options`   | `nosniff`                         | Disables MIME type sniffing.                                    | | `X-XSS-Protection`         | `1; mode=block`                   | Enables XSS filter protection.                                  | | `X-Frame-Options`          | `SAMEORIGIN`                      | Prevents rendering in a frame from a different origin.          | | `X-UA-Compatible`          | `IE=edge,chrome=1`                | Specifies the browser mode to render in.                        |  ### Format  When `application/json` is returned in the response body it is always pretty-printed (indented, human readable output).  Additionally, gzip compression/encoding is supported on all responses.   #### Dates & Times  Dates or times are returned as strings in the ISO 8601 'extended' format. When a date and time is returned (instant) the value is converted to UTC.  For example:  | Value           | Format                         | Example               | | --------------- | ------------------------------ | --------------------- | | Date            | `YYYY-MM-DD`                   | 2017-12-03            | | Date & Time     | `YYYY-MM-DD'T'hh:mm:ss[.nnn]Z` | 2017-12-03T10:15:30Z  |  #### Content  In some resources a Content data type is used. This allows for multiple formats of representation to be returned within resource, specifically `\"html\"` and `\"text\"`. The `\"text\"` property returns a flattened representation suitable for output in textual displays. The `\"html\"` property returns an HTML fragment suitable for display within an HTML  element. Note, the HTML returned is not a valid stand-alone HTML document.  #### Paging  The response to a paginated request follows the format:  ```json {    resources\": [        ...     ],    \"page\": {        \"number\" : ...,       \"size\" : ...,       \"totalResources\" : ...,       \"totalPages\" : ...    },    \"links\": [        \"first\" : {          \"href\" : \"...\"        },        \"prev\" : {          \"href\" : \"...\"        },        \"self\" : {          \"href\" : \"...\"        },        \"next\" : {          \"href\" : \"...\"        },        \"last\" : {          \"href\" : \"...\"        }     ] } ```  The `resources` property is an array of the resources being retrieved from the endpoint, each which should contain at  minimum a \"self\" relation hypermedia link. The `page` property outlines the details of the current page and total possible pages. The object for the page includes the following properties:  - number - The page number (zero-based) of the page returned. - size - The size of the pages, which is less than or equal to the maximum page size. - totalResources - The total amount of resources available across all pages. - totalPages - The total amount of pages.  The last property of the paged response is the `links` array, which contains all available hypermedia links. For  paginated responses, the \"self\", \"next\", \"previous\", \"first\", and \"last\" links are returned. The \"self\" link must always be returned and should contain a link to allow the client to replicate the original request against the  collection resource in an identical manner to that in which it was invoked.   The \"next\" and \"previous\" links are present if either or both there exists a previous or next page, respectively.  The \"next\" and \"previous\" links have hrefs that allow \"natural movement\" to the next page, that is all parameters  required to move the next page are provided in the link. The \"first\" and \"last\" links provide references to the first and last pages respectively.   Requests outside the boundaries of the pageable will result in a `404 NOT FOUND`. Paginated requests do not provide a  \"stateful cursor\" to the client, nor does it need to provide a read consistent view. Records in adjacent pages may  change while pagination is being traversed, and the total number of pages and resources may change between requests  within the same filtered/queries resource collection.  #### Property Views  The \"depth\" of the response of a resource can be configured using a \"view\". All endpoints supports two views that can  tune the extent of the information returned in the resource. The supported views are `summary` and `details` (the default).  View are specified using a query parameter, in this format:  ```bash /<resource>?view={viewName} ```  #### Error  Any error responses can provide a response body with a message to the client indicating more information (if applicable)  to aid debugging of the error. All 40x and 50x responses will return an error response in the body. The format of the  response is as follows:  ```json {    \"status\": <statusCode>,    \"message\": <message>,    \"links\" : [ {       \"rel\" : \"...\",       \"href\" : \"...\"     } ] }   ```   The `status` property is the same as the HTTP status returned in the response, to ease client parsing. The message  property is a localized message in the request client's locale (if applicable) that articulates the nature of the  error. The last property is the `links` property. This may contain additional  [hypermedia links](#section/Overview/Authentication) to troubleshoot.  #### Search Criteria <a section=\"section/Responses/SearchCriteria\"></a>  Multiple resources make use of search criteria to match assets. Search criteria is an array of search filters. Each  search filter has a generic format of:  ```json {     \"field\": \"<field-name>\",     \"operator\": \"<operator>\",     [\"value\": <value>,]    [\"lower\": <value>,]    [\"upper\": <value>] }     ```  Every filter defines two required properties `field` and `operator`. The field is the name of an asset property that is being filtered on. The operator is a type and property-specific operating performed on the filtered property. The valid values for fields and operators are outlined in the table below. Depending on the data type of the operator the value may be a numeric or string format.  Every filter also defines one or more values that are supplied to the operator. The valid values vary by operator and are outlined below.  ##### Fields  The following table outlines the search criteria fields and the available operators:  | Field                             | Operators                                                                                                                      | | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | | `alternate-address-type`          | `in`                                                                                                                           | | `container-image`                 | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain` `is-like` `not-like`                                     | | `container-status`                | `is` `is-not`                                                                                                                  | | `containers`                      | `are`                                                                                                                          | | `criticality-tag`                 | `is` `is-not` `is-greater-than` `is-less-than` `is-applied` ` is-not-applied`                                                  | | `custom-tag`                      | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain` `is-applied` `is-not-applied`                            | | `cve`                             | `is` `is-not` `contains` `does-not-contain`                                                                                    | | `cvss-access-complexity`          | `is` `is-not`                                                                                                                  | | `cvss-authentication-required`    | `is` `is-not`                                                                                                                  | | `cvss-access-vector`              | `is` `is-not`                                                                                                                  | | `cvss-availability-impact`        | `is` `is-not`                                                                                                                  | | `cvss-confidentiality-impact`     | `is` `is-not`                                                                                                                  | | `cvss-integrity-impact`           | `is` `is-not`                                                                                                                  | | `cvss-v3-confidentiality-impact`  | `is` `is-not`                                                                                                                  | | `cvss-v3-integrity-impact`        | `is` `is-not`                                                                                                                  | | `cvss-v3-availability-impact`     | `is` `is-not`                                                                                                                  | | `cvss-v3-attack-vector`           | `is` `is-not`                                                                                                                  | | `cvss-v3-attack-complexity`       | `is` `is-not`                                                                                                                  | | `cvss-v3-user-interaction`        | `is` `is-not`                                                                                                                  | | `cvss-v3-privileges-required`     | `is` `is-not`                                                                                                                  | | `host-name`                       | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain` `is-empty` `is-not-empty` `is-like` `not-like`           | | `host-type`                       | `in` `not-in`                                                                                                                  | | `ip-address`                      | `is` `is-not` `in-range` `not-in-range` `is-like` `not-like`                                                                   | | `ip-address-type`                 | `in` `not-in`                                                                                                                  | | `last-scan-date`                  | `is-on-or-before` `is-on-or-after` `is-between` `is-earlier-than` `is-within-the-last`                                         | | `location-tag`                    | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain` `is-applied` `is-not-applied`                            | | `mobile-device-last-sync-time`    | `is-within-the-last` `is-earlier-than`                                                                                         | | `open-ports`                      | `is` `is-not` ` in-range`                                                                                                      | | `operating-system`                | `contains` ` does-not-contain` ` is-empty` ` is-not-empty`                                                                     | | `owner-tag`                       | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain` `is-applied` `is-not-applied`                            | | `pci-compliance`                  | `is`                                                                                                                           | | `risk-score`                      | `is` `is-not` `is-greater-than` `is-less-than` `in-range`                                                                      | | `service-name`                    | `contains` `does-not-contain`                                                                                                  | | `site-id`                         | `in` `not-in`                                                                                                                  | | `software`                        | `contains` `does-not-contain`                                                                                                  | | `vAsset-cluster`                  | `is` `is-not` `contains` `does-not-contain` `starts-with`                                                                      | | `vAsset-datacenter`               | `is` `is-not`                                                                                                                  | | `vAsset-host-name`                | `is` `is-not` `contains` `does-not-contain` `starts-with`                                                                      | | `vAsset-power-state`              | `in` `not-in`                                                                                                                  | | `vAsset-resource-pool-path`       | `contains` `does-not-contain`                                                                                                  | | `vulnerability-assessed`          | `is-on-or-before` `is-on-or-after` `is-between` `is-earlier-than` `is-within-the-last`                                         | | `vulnerability-category`          | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain`                                                          | | `vulnerability-cvss-v3-score`     | `is` `is-not`                                                                                                                  | | `vulnerability-cvss-score`        | `is` `is-not` `in-range` `is-greater-than` `is-less-than`                                                                      | | `vulnerability-exposures`         | `includes` `does-not-include`                                                                                                  | | `vulnerability-title`             | `contains` `does-not-contain` `is` `is-not` `starts-with` `ends-with`                                                          | | `vulnerability-validated-status`  | `are`                                                                                                                          |  ##### Enumerated Properties  The following fields have enumerated values:  | Field                                     | Acceptable Values                                                                                             | | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------- | | `alternate-address-type`                  | 0=IPv4, 1=IPv6                                                                                                | | `containers`                              | 0=present, 1=not present                                                                                      | | `container-status`                        | `created` `running` `paused` `restarting` `exited` `dead` `unknown`                                           | | `cvss-access-complexity`                  | <ul><li><code>L</code> = Low</li><li><code>M</code> = Medium</li><li><code>H</code> = High</li></ul>          | | `cvss-integrity-impact`                   | <ul><li><code>N</code> = None</li><li><code>P</code> = Partial</li><li><code>C</code> = Complete</li></ul>    | | `cvss-confidentiality-impact`             | <ul><li><code>N</code> = None</li><li><code>P</code> = Partial</li><li><code>C</code> = Complete</li></ul>    | | `cvss-availability-impact`                | <ul><li><code>N</code> = None</li><li><code>P</code> = Partial</li><li><code>C</code> = Complete</li></ul>    | | `cvss-access-vector`                      | <ul><li><code>L</code> = Local</li><li><code>A</code> = Adjacent</li><li><code>N</code> = Network</li></ul>   | | `cvss-authentication-required`            | <ul><li><code>N</code> = None</li><li><code>S</code> = Single</li><li><code>M</code> = Multiple</li></ul>     | | `cvss-v3-confidentiality-impact`     | <ul><li><code>L</code> = Local</li><li><code>L</code> = Low</li><li><code>N</code> = None</li><li><code>H</code> = High</li></ul>          | | `cvss-v3-integrity-impact`            | <ul><li><code>L</code> = Local</li><li><code>L</code> = Low</li><li><code>N</code> = None</li><li><code>H</code> = High</li></ul>          | | `cvss-v3-availability-impact`             | <ul><li><code>N</code> = None</li><li><code>L</code> = Low</li><li><code>H</code> = High</li></ul>    | | `cvss-v3-attack-vector`                | <ul><li><code>N</code> = Network</li><li><code>A</code> = Adjacent</li><li><code>L</code> = Local</li><li><code>P</code> = Physical</li></ul>    | | `cvss-v3-attack-complexity`                      | <ul><li><code>L</code> = Low</li><li><code>H</code> = High</li></ul>   | | `cvss-v3-user-interaction`            | <ul><li><code>N</code> = None</li><li><code>R</code> = Required</li></ul>     | | `cvss-v3-privileges-required`         | <ul><li><code>N</code> = None</li><li><code>L</code> = Low</li><li><code>H</code> = High</li></ul>    | | `host-type`                               | 0=Unknown, 1=Guest, 2=Hypervisor, 3=Physical, 4=Mobile                                                        | | `ip-address-type`                         | 0=IPv4, 1=IPv6                                                                                                | | `pci-compliance`                          | 0=fail, 1=pass                                                                                                | | `vulnerability-validated-status`          | 0=present, 1=not present                                                                                      |  ##### Operator Properties <a section=\"section/Responses/SearchCriteria/OperatorProperties\"></a>  The following table outlines which properties are required for each operator and the appropriate data type(s):  | Operator              | `value`               | `lower`               | `upper`                | | ----------------------|-----------------------|-----------------------|------------------------| | `are`                 | `string`              |                       |                        | | `contains`            | `string`              |                       |                        | | `does-not-contain`    | `string`              |                       |                        | | `ends with`           | `string`              |                       |                        | | `in`                  | `Array[ string ]`     |                       |                        | | `in-range`            |                       | `numeric`             | `numeric`              | | `includes`            | `Array[ string ]`     |                       |                        | | `is`                  | `string`              |                       |                        | | `is-applied`          |                       |                       |                        | | `is-between`          |                       | `string` (yyyy-MM-dd) | `numeric` (yyyy-MM-dd) | | `is-earlier-than`     | `numeric` (days)      |                       |                        | | `is-empty`            |                       |                       |                        | | `is-greater-than`     | `numeric`             |                       |                        | | `is-on-or-after`      | `string` (yyyy-MM-dd) |                       |                        | | `is-on-or-before`     | `string` (yyyy-MM-dd) |                       |                        | | `is-not`              | `string`              |                       |                        | | `is-not-applied`      |                       |                       |                        | | `is-not-empty`        |                       |                       |                        | | `is-within-the-last`  | `numeric` (days)      |                       |                        | | `less-than`           | `string`              |                       |                        |  | `like`                | `string`              |                       |                        | | `not-contains`        | `string`              |                       |                        | | `not-in`              | `Array[ string ]`     |                       |                        | | `not-in-range`        |                       | `numeric`             | `numeric`              | | `not-like`            | `string`              |                       |                        | | `starts-with`         | `string`              |                       |                        |  #### Discovery Connection Search Criteria <a section=\"section/Responses/DiscoverySearchCriteria\"></a>  Dynamic sites make use of search criteria to match assets from a discovery connection. Search criteria is an array of search filters.    Each search filter has a generic format of:  ```json {     \"field\": \"<field-name>\",     \"operator\": \"<operator>\",     [\"value\": \"<value>\",]    [\"lower\": \"<value>\",]    [\"upper\": \"<value>\"] }     ```  Every filter defines two required properties `field` and `operator`. The field is the name of an asset property that is being filtered on. The list of supported fields vary depending on the type of discovery connection configured  for the dynamic site (e.g vSphere, ActiveSync, etc.). The operator is a type and property-specific operating  performed on the filtered property. The valid values for fields outlined in the tables below and are grouped by the  type of connection.    Every filter also defines one or more values that are supplied to the operator. See  <a href=\"#section/Responses/SearchCriteria/OperatorProperties\">Search Criteria Operator Properties</a> for more  information on the valid values for each operator.    ##### Fields (ActiveSync)  This section documents search criteria information for ActiveSync discovery connections. The discovery connections  must be one of the following types: `\"activesync-ldap\"`, `\"activesync-office365\"`, or `\"activesync-powershell\"`.    The following table outlines the search criteria fields and the available operators for ActiveSync connections:  | Field                             | Operators                                                     | | --------------------------------- | ------------------------------------------------------------- | | `last-sync-time`                  | `is-within-the-last` ` is-earlier-than`                       | | `operating-system`                | `contains` ` does-not-contain`                                | | `user`                            | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with` |  ##### Fields (AWS)  This section documents search criteria information for AWS discovery connections. The discovery connections must be the type `\"aws\"`.    The following table outlines the search criteria fields and the available operators for AWS connections:  | Field                   | Operators                                                     | | ----------------------- | ------------------------------------------------------------- | | `availability-zone`     | `contains` ` does-not-contain`                                | | `guest-os-family`       | `contains` ` does-not-contain`                                | | `instance-id`           | `contains` ` does-not-contain`                                | | `instance-name`         | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with` | | `instance-state`        | `in` ` not-in`                                                | | `instance-type`         | `in` ` not-in`                                                | | `ip-address`            | `in-range` ` not-in-range` ` is` ` is-not`                    | | `region`                | `in` ` not-in`                                                | | `vpc-id`                | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with` |  ##### Fields (DHCP)  This section documents search criteria information for DHCP discovery connections. The discovery connections must be the type `\"dhcp\"`.    The following table outlines the search criteria fields and the available operators for DHCP connections:  | Field           | Operators                                                     | | --------------- | ------------------------------------------------------------- | | `host-name`     | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with` | | `ip-address`    | `in-range` ` not-in-range` ` is` ` is-not`                    | | `mac-address`   | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with` |  ##### Fields (Sonar)  This section documents search criteria information for Sonar discovery connections. The discovery connections must be the type `\"sonar\"`.    The following table outlines the search criteria fields and the available operators for Sonar connections:  | Field               | Operators            | | ------------------- | -------------------- | | `search-domain`     | `contains` ` is`     | | `ip-address`        | `in-range` ` is`     | | `sonar-scan-date`   | `is-within-the-last` |  ##### Fields (vSphere)  This section documents search criteria information for vSphere discovery connections. The discovery connections must be the type `\"vsphere\"`.    The following table outlines the search criteria fields and the available operators for vSphere connections:  | Field                | Operators                                                                                  | | -------------------- | ------------------------------------------------------------------------------------------ | | `cluster`            | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with`                              | | `data-center`        | `is` ` is-not`                                                                             | | `discovered-time`    | `is-on-or-before` ` is-on-or-after` ` is-between` ` is-earlier-than` ` is-within-the-last` | | `guest-os-family`    | `contains` ` does-not-contain`                                                             | | `host-name`          | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with`                              | | `ip-address`         | `in-range` ` not-in-range` ` is` ` is-not`                                                 | | `power-state`        | `in` ` not-in`                                                                             | | `resource-pool-path` | `contains` ` does-not-contain`                                                             | | `last-time-seen`     | `is-on-or-before` ` is-on-or-after` ` is-between` ` is-earlier-than` ` is-within-the-last` | | `vm`                 | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with`                              |  ##### Enumerated Properties (vSphere)  The following fields have enumerated values:  | Field         | Acceptable Values                    | | ------------- | ------------------------------------ | | `power-state` | `poweredOn` `poweredOff` `suspended` |  ## HATEOAS  This API follows Hypermedia as the Engine of Application State (HATEOAS) principals and is therefore hypermedia friendly.  Hyperlinks are returned in the `links` property of any given resource and contain a fully-qualified hyperlink to the corresponding resource. The format of the hypermedia link adheres to both the <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"http://jsonapi.org\">{json:api} v1</a>  <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"http://jsonapi.org/format/#document-links\">\"Link Object\"</a> and  <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"http://json-schema.org/latest/json-schema-hypermedia.html\">JSON Hyper-Schema</a>  <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"http://json-schema.org/latest/json-schema-hypermedia.html#rfc.section.5.2\">\"Link Description Object\"</a> formats. For example:  ```json \"links\": [{   \"rel\": \"<relation>\",   \"href\": \"<href>\"   ... }] ```  Where appropriate link objects may also contain additional properties than the `rel` and `href` properties, such as `id`, `type`, etc.  See the [Root](#tag/Root) resources for the entry points into API discovery. 

OpenAPI spec version: 3
Contact: support@rapid7.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.54
=end

module SwaggerClient
  class TagApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Tags
    # Creates a new tag.
    # @param [Hash] opts the optional parameters
    # @option opts [Tag] :body The details of the tag.
    # @return [ReferenceWithTagIDLink]
    def create_tag(opts = {})
      data, _status_code, _headers = create_tag_with_http_info(opts)
      data
    end

    # Tags
    # Creates a new tag.
    # @param [Hash] opts the optional parameters
    # @option opts [Tag] :body The details of the tag.
    # @return [Array<(ReferenceWithTagIDLink, Integer, Hash)>] ReferenceWithTagIDLink data, response status code and response headers
    def create_tag_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.create_tag ...'
      end
      # resource path
      local_var_path = '/api/3/tags'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] || 'ReferenceWithTagIDLink' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#create_tag\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag
    # Deletes the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Links]
    def delete_tag(site_idte_id, opts = {})
      data, _status_code, _headers = delete_tag_with_http_info(site_idte_id, opts)
      data
    end

    # Tag
    # Deletes the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def delete_tag_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.delete_tag ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.delete_tag"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#delete_tag\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag
    # Returns a tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Tag]
    def get_tag(site_idte_id, opts = {})
      data, _status_code, _headers = get_tag_with_http_info(site_idte_id, opts)
      data
    end

    # Tag
    # Returns a tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Tag, Integer, Hash)>] Tag data, response status code and response headers
    def get_tag_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.get_tag ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.get_tag"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Tag' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#get_tag\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Asset Groups
    # Returns the asset groups associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [ReferencesWithAssetGroupIDLink]
    def get_tag_asset_groups(site_idte_id, opts = {})
      data, _status_code, _headers = get_tag_asset_groups_with_http_info(site_idte_id, opts)
      data
    end

    # Tag Asset Groups
    # Returns the asset groups associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Array<(ReferencesWithAssetGroupIDLink, Integer, Hash)>] ReferencesWithAssetGroupIDLink data, response status code and response headers
    def get_tag_asset_groups_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.get_tag_asset_groups ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.get_tag_asset_groups"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/asset_groups'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'ReferencesWithAssetGroupIDLink' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#get_tag_asset_groups\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Search Criteria
    # Returns the search criteria associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [SearchCriteria]
    def get_tag_search_criteria(site_idte_id, opts = {})
      data, _status_code, _headers = get_tag_search_criteria_with_http_info(site_idte_id, opts)
      data
    end

    # Tag Search Criteria
    # Returns the search criteria associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Array<(SearchCriteria, Integer, Hash)>] SearchCriteria data, response status code and response headers
    def get_tag_search_criteria_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.get_tag_search_criteria ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.get_tag_search_criteria"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/search_criteria'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'SearchCriteria' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#get_tag_search_criteria\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Assets
    # Returns the assets tagged with a tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [TaggedAssetReferences]
    def get_tagged_assets(site_idte_id, opts = {})
      data, _status_code, _headers = get_tagged_assets_with_http_info(site_idte_id, opts)
      data
    end

    # Tag Assets
    # Returns the assets tagged with a tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Array<(TaggedAssetReferences, Integer, Hash)>] TaggedAssetReferences data, response status code and response headers
    def get_tagged_assets_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.get_tagged_assets ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.get_tagged_assets"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/assets'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'TaggedAssetReferences' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#get_tagged_assets\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Sites
    # Returns the sites associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [ReferencesWithSiteIDLink]
    def get_tagged_sites(site_idte_id, opts = {})
      data, _status_code, _headers = get_tagged_sites_with_http_info(site_idte_id, opts)
      data
    end

    # Tag Sites
    # Returns the sites associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Array<(ReferencesWithSiteIDLink, Integer, Hash)>] ReferencesWithSiteIDLink data, response status code and response headers
    def get_tagged_sites_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.get_tagged_sites ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.get_tagged_sites"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/sites'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'ReferencesWithSiteIDLink' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#get_tagged_sites\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tags
    # Returns all tags.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :name name
    # @option opts [String] :type type
    # @option opts [Integer] :page The index of the page (zero-based) to retrieve. (default to 0)
    # @option opts [Integer] :size The number of records per page to retrieve. (default to 10)
    # @option opts [Array<String>] :sort The criteria to sort the records by, in the format: &#x60;property[,ASC|DESC]&#x60;. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
    # @return [PageOfTag]
    def get_tags(opts = {})
      data, _status_code, _headers = get_tags_with_http_info(opts)
      data
    end

    # Tags
    # Returns all tags.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :name name
    # @option opts [String] :type type
    # @option opts [Integer] :page The index of the page (zero-based) to retrieve.
    # @option opts [Integer] :size The number of records per page to retrieve.
    # @option opts [Array<String>] :sort The criteria to sort the records by, in the format: &#x60;property[,ASC|DESC]&#x60;. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
    # @return [Array<(PageOfTag, Integer, Hash)>] PageOfTag data, response status code and response headers
    def get_tags_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.get_tags ...'
      end
      # resource path
      local_var_path = '/api/3/tags'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'name'] = opts[:'name'] if !opts[:'name'].nil?
      query_params[:'type'] = opts[:'type'] if !opts[:'type'].nil?
      query_params[:'page'] = opts[:'page'] if !opts[:'page'].nil?
      query_params[:'size'] = opts[:'size'] if !opts[:'size'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :multi) if !opts[:'sort'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'PageOfTag' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#get_tags\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Search Criteria
    # Removes the search criteria associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Links]
    def remove_tag_search_criteria(site_idte_id, opts = {})
      data, _status_code, _headers = remove_tag_search_criteria_with_http_info(site_idte_id, opts)
      data
    end

    # Tag Search Criteria
    # Removes the search criteria associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def remove_tag_search_criteria_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.remove_tag_search_criteria ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.remove_tag_search_criteria"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/search_criteria'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#remove_tag_search_criteria\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Sites
    # Removes the associations between the tag and the sites.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Links]
    def remove_tagged_sites(site_idte_id, opts = {})
      data, _status_code, _headers = remove_tagged_sites_with_http_info(site_idte_id, opts)
      data
    end

    # Tag Sites
    # Removes the associations between the tag and the sites.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def remove_tagged_sites_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.remove_tagged_sites ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.remove_tagged_sites"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/sites'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#remove_tagged_sites\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Asset Groups
    # Sets the asset groups associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<Integer>] :body The asset groups to add to the tag.
    # @return [Links]
    def set_tagged_asset_groups(site_idte_id, opts = {})
      data, _status_code, _headers = set_tagged_asset_groups_with_http_info(site_idte_id, opts)
      data
    end

    # Tag Asset Groups
    # Sets the asset groups associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<Integer>] :body The asset groups to add to the tag.
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def set_tagged_asset_groups_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.set_tagged_asset_groups ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.set_tagged_asset_groups"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/asset_groups'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#set_tagged_asset_groups\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Sites
    # Sets the sites associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<Integer>] :body The sites to add to the tag.
    # @return [Links]
    def set_tagged_sites(site_idte_id, opts = {})
      data, _status_code, _headers = set_tagged_sites_with_http_info(site_idte_id, opts)
      data
    end

    # Tag Sites
    # Sets the sites associated with the tag.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<Integer>] :body The sites to add to the tag.
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def set_tagged_sites_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.set_tagged_sites ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.set_tagged_sites"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/sites'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#set_tagged_sites\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Asset
    # Adds an asset to the tag.
    # @param id The identifier of the tag.
    # @param asset_id The identifier of the asset.
    # @param [Hash] opts the optional parameters
    # @return [Links]
    def tag_asset(site_idte_id, asset_id, opts = {})
      data, _status_code, _headers = tag_asset_with_http_info(site_idte_id, asset_id, opts)
      data
    end

    # Tag Asset
    # Adds an asset to the tag.
    # @param id The identifier of the tag.
    # @param asset_id The identifier of the asset.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def tag_asset_with_http_info(site_idte_id, asset_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.tag_asset ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.tag_asset"
      end
      # verify the required parameter 'asset_id' is set
      if @api_client.config.client_side_validation && asset_id.nil?
        fail ArgumentError, "Missing the required parameter 'asset_id' when calling TagApi.tag_asset"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/assets/{assetId}'.sub('{' + 'id' + '}', site_idte_id.to_s).sub('{' + 'assetId' + '}', asset_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#tag_asset\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Asset Group
    # Adds an asset group to this tag.
    # @param id The identifier of the tag.
    # @param asset_group_id The asset group identifier.
    # @param [Hash] opts the optional parameters
    # @return [Links]
    def tag_asset_group(site_idte_id, asset_group_id, opts = {})
      data, _status_code, _headers = tag_asset_group_with_http_info(site_idte_id, asset_group_id, opts)
      data
    end

    # Tag Asset Group
    # Adds an asset group to this tag.
    # @param id The identifier of the tag.
    # @param asset_group_id The asset group identifier.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def tag_asset_group_with_http_info(site_idte_id, asset_group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.tag_asset_group ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.tag_asset_group"
      end
      # verify the required parameter 'asset_group_id' is set
      if @api_client.config.client_side_validation && asset_group_id.nil?
        fail ArgumentError, "Missing the required parameter 'asset_group_id' when calling TagApi.tag_asset_group"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/asset_groups/{assetGroupId}'.sub('{' + 'id' + '}', site_idte_id.to_s).sub('{' + 'assetGroupId' + '}', asset_group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#tag_asset_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Site
    # Adds a site to this tag.
    # @param id The identifier of the tag.
    # @param site_id The identifier of the site.
    # @param [Hash] opts the optional parameters
    # @return [Links]
    def tag_site(site_idte_id, site_id, opts = {})
      data, _status_code, _headers = tag_site_with_http_info(site_idte_id, site_id, opts)
      data
    end

    # Tag Site
    # Adds a site to this tag.
    # @param id The identifier of the tag.
    # @param site_id The identifier of the site.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def tag_site_with_http_info(site_idte_id, site_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.tag_site ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.tag_site"
      end
      # verify the required parameter 'site_id' is set
      if @api_client.config.client_side_validation && site_id.nil?
        fail ArgumentError, "Missing the required parameter 'site_id' when calling TagApi.tag_site"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/sites/{siteId}'.sub('{' + 'id' + '}', site_idte_id.to_s).sub('{' + 'siteId' + '}', site_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#tag_site\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Asset Groups
    # Removes the associations between the tag and all asset groups.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Links]
    def untag_all_asset_groups(site_idte_id, opts = {})
      data, _status_code, _headers = untag_all_asset_groups_with_http_info(site_idte_id, opts)
      data
    end

    # Tag Asset Groups
    # Removes the associations between the tag and all asset groups.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def untag_all_asset_groups_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.untag_all_asset_groups ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.untag_all_asset_groups"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/asset_groups'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#untag_all_asset_groups\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Asset
    # Removes an asset from the tag. Note: The asset must be added through the asset or tag, if the asset is added using a site, asset group, or search criteria this will not remove the asset.
    # @param id The identifier of the tag.
    # @param asset_id The identifier of the asset.
    # @param [Hash] opts the optional parameters
    # @return [Links]
    def untag_asset(site_idte_id, asset_id, opts = {})
      data, _status_code, _headers = untag_asset_with_http_info(site_idte_id, asset_id, opts)
      data
    end

    # Tag Asset
    # Removes an asset from the tag. Note: The asset must be added through the asset or tag, if the asset is added using a site, asset group, or search criteria this will not remove the asset.
    # @param id The identifier of the tag.
    # @param asset_id The identifier of the asset.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def untag_asset_with_http_info(site_idte_id, asset_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.untag_asset ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.untag_asset"
      end
      # verify the required parameter 'asset_id' is set
      if @api_client.config.client_side_validation && asset_id.nil?
        fail ArgumentError, "Missing the required parameter 'asset_id' when calling TagApi.untag_asset"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/assets/{assetId}'.sub('{' + 'id' + '}', site_idte_id.to_s).sub('{' + 'assetId' + '}', asset_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#untag_asset\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Asset Group
    # Removes an asset group from this tag.
    # @param id The identifier of the tag.
    # @param asset_group_id The asset group identifier.
    # @param [Hash] opts the optional parameters
    # @return [Links]
    def untag_asset_group(site_idte_id, asset_group_id, opts = {})
      data, _status_code, _headers = untag_asset_group_with_http_info(site_idte_id, asset_group_id, opts)
      data
    end

    # Tag Asset Group
    # Removes an asset group from this tag.
    # @param id The identifier of the tag.
    # @param asset_group_id The asset group identifier.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def untag_asset_group_with_http_info(site_idte_id, asset_group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.untag_asset_group ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.untag_asset_group"
      end
      # verify the required parameter 'asset_group_id' is set
      if @api_client.config.client_side_validation && asset_group_id.nil?
        fail ArgumentError, "Missing the required parameter 'asset_group_id' when calling TagApi.untag_asset_group"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/asset_groups/{assetGroupId}'.sub('{' + 'id' + '}', site_idte_id.to_s).sub('{' + 'assetGroupId' + '}', asset_group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#untag_asset_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Site
    # Removes a site from this tag.
    # @param id The identifier of the tag.
    # @param site_id The identifier of the site.
    # @param [Hash] opts the optional parameters
    # @return [Links]
    def untag_site(site_idte_id, site_id, opts = {})
      data, _status_code, _headers = untag_site_with_http_info(site_idte_id, site_id, opts)
      data
    end

    # Tag Site
    # Removes a site from this tag.
    # @param id The identifier of the tag.
    # @param site_id The identifier of the site.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def untag_site_with_http_info(site_idte_id, site_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.untag_site ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.untag_site"
      end
      # verify the required parameter 'site_id' is set
      if @api_client.config.client_side_validation && site_id.nil?
        fail ArgumentError, "Missing the required parameter 'site_id' when calling TagApi.untag_site"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/sites/{siteId}'.sub('{' + 'id' + '}', site_idte_id.to_s).sub('{' + 'siteId' + '}', site_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#untag_site\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag
    # Updates the details of a tag. For more information about accepted fields for the tag search criteria see the PUT /search_criteria documentation.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @option opts [Tag] :body The details of the tag.
    # @return [Links]
    def update_tag(site_idte_id, opts = {})
      data, _status_code, _headers = update_tag_with_http_info(site_idte_id, opts)
      data
    end

    # Tag
    # Updates the details of a tag. For more information about accepted fields for the tag search criteria see the PUT /search_criteria documentation.
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @option opts [Tag] :body The details of the tag.
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def update_tag_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.update_tag ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.update_tag"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#update_tag\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Tag Search Criteria
    # Updates the search criteria associated with the tag.   The following table outlines the search criteria fields and the available operators:  | Field | Operators |  | ---------- | ---------------- |  | ip-address | is, is-not, in-range, not-in-range, is-like, not-like |  | ip-address-type | in, not-in |  | alternate-address-type | in |  | host-name | is, is-not, starts-with, ends-with, contains, does-not-contain, is-empty, is-not-empty, is-like, not-like |  | host-type | in, not-in |  | operating-system | contains, does-not-contain, is-empty, is-not-empty |  | software | contains, does-not-contain|  | open-ports | is, is-not, in-range |  | service-name | contains, does-not-contain |  | risk-score | is, is-not, in-range, is-greater-than,is-less-than |  | last-scan-date | is-on-or-before, is-on-or-after, is-between, is-earlier-than, is-within-the-last |  | vulnerability-assessed | is-on-or-before, is-on-or-after, is-between, is-earlier-than, is-within-the-last |  | vulnerability-category | is, is-not, starts-with, ends-with, contains, does-not-contain|  | vulnerability-cvss-score | is, is-not, in-range, is-greater-than, is-less-than |  | vulnerability-cvss-v3-score | is, is-not, in-range, is-greater-than, is-less-than |  | vulnerability-exposures | includes, does not-include |  | vulnerability-title | contains, does-not-contain, is, is-not, starts-with, ends-with |  | cve | is, is-not, contains, does-not-contain |  | cvss-access-complexity | is, is-not | | cvss-authentication-required | is, is-not | | cvss-access-vector | is, is-not | | cvss-availability-impact | is, is-not | | cvss-confidentiality-impact | is, is-not | | cvss-integrity-impact | is, is-not | | cvss-v3-confidentiality-impact | is, is-not | | cvss-v3-integrity-impact | is, is-not | | cvss-v3-availability-impact | is, is-not | | cvss-v3-attack-vector | is, is-not | | cvss-v3-attack-complexity | is, is-not | | cvss-v3-user-interaction | is, is-not | | cvss-v3-privileges-required | is, is-not | | mobile-device-last-sync | is-within-the-last, is-earlier-than |  | pci-compliance | is |  | site-id | in, not-in |  | criticality-tag | is, is-not, is-greater-than, is-less-than, is-applied, is-not-applied |  | custom-tag | is, is-not, starts-with, ends-with, contains, does-not-contain, is-applied, is-not-applied |  | location-tag | is, is-not, starts-with, ends-with, contains, does-not-contain, is-applied, is-not-applied |  | owner-tag | is, is-not, starts-with, ends-with, contains, does-not-contain, is-applied, is-not-applied |  | vulnerability-validated-status | are |  | vasset-cluster | is, is-not, contains, does-not-contain, starts-with |  | vasset-datacenter | is, is-not |  | vasset-host name | is, is-not, contains, does-not-contain, starts-with |  | vasset-power state | in, not-in |  | vasset-resource pool path | contains, does-not-contain |  | container-image | is, is-not, starts-with, ends-with, contains, does-not-contain, is-like, not-like |  | container-status | is, is-not |  | containers | are |   The following table outlines the operators and the values associated with them:  | Operator | Values |  | -------- | ------ |  | are | A single string property named \"value\" |  | is-between | A number property named \"lower\" and a number property named \"upper\" |  | contains | A single string property named \"value\" |  | does-not-contain | A single string property named \"value\" |  | is-earlier-than | A single number property named \"value\" |  | ends-with | A single string property named \"value\" |  | is-greater-than | A single number property named \"value\" |  | in | An array property named \"values\" |  | not-in | An array property named \"values\" |  | in-range | A number property named \"lower\" and a number property named \"upper\" |  | includes | An array property named \"values\" |  | is | A single string property named \"value\" |  | is-not | A single string property named \"value\" |  | is-applied | No value |  | is-not-applied | No value |  | is-empty | No value |  | is-not-empty | No value |  | is-less-than | A single number property named \"value\" |  | is-like | A single string property named \"value\" |  | does-not-contain | A single string property named \"value\" |  | not-in-range | A number property named \"lower\" and a number property named \"upper\" |  | not-like | A single string property named \"value\" |  | is-on-or-after | A single string property named \"value\", which is the date in ISO8601 format (yyyy-MM-dd) |  | is-on-or-before | A single string property named \"value\", which is the date in ISO8601 format (yyyy-MM-dd) |  | starts-with | A single string property named \"value\" |  | is-within-the-last | A single number property named \"value\" |   The following fields have enumerated values:  | Field | Acceptable Values |  | ----- | ----------------- |  | containers | 0=present, 1=not present |  | vulnerability-validated-status | 0=present, 1=not present |  | pci-compliance | 0=fail, 1=pass |  | alternate-address-type | 0=IPv4, 1=IPv6 |  | ip-address-type | 0=IPv4, 1=IPv6 |  | host-type | 0=Unknown, 1=Guest, 2=Hypervisor, 3=Physical, 4=Mobile |  | cvss-access-complexity | L=Low, M=Medium, H=High |  | cvss-integrity-impact | N=None, P=Partial, C=Complete |  | cvss-confidentiality-impact | N=None, P=Partial, C=Complete |  | cvss-availability-impact | N=None, P=Partial, C=Complete |  | cvss-access-vector | L=Local, A=Adjacent, N=Network |  | cvss-authentication-required | N=None, S=Single, M=Multiple |  | cvss-access-complexity | L=Low, M=Medium, H=High |  | cvss-v3-confidentiality-impact | N=None, L=Low, H=High |  | cvss-v3-integrity-impact | N=None, L=Low, H=High |  | cvss-v3-availability-impact | N=None, L=Low, H=High |  | cvss-v3-attack-vector | N=Network, A=Adjacent, L=Local, P=Physical |  | cvss-v3-attack-complexity | L=Low, H=High |  | cvss-v3-user-interaction | N=None, R=Required |  | cvss-v3-privileges-required | N=None, L=Low, H=High |  | container-status | created, running, paused, restarting, exited, dead, unknown |  
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @option opts [SearchCriteria] :body The details of the search criteria.
    # @return [Links]
    def update_tag_search_criteria(site_idte_id, opts = {})
      data, _status_code, _headers = update_tag_search_criteria_with_http_info(site_idte_id, opts)
      data
    end

    # Tag Search Criteria
    # Updates the search criteria associated with the tag.   The following table outlines the search criteria fields and the available operators:  | Field | Operators |  | ---------- | ---------------- |  | ip-address | is, is-not, in-range, not-in-range, is-like, not-like |  | ip-address-type | in, not-in |  | alternate-address-type | in |  | host-name | is, is-not, starts-with, ends-with, contains, does-not-contain, is-empty, is-not-empty, is-like, not-like |  | host-type | in, not-in |  | operating-system | contains, does-not-contain, is-empty, is-not-empty |  | software | contains, does-not-contain|  | open-ports | is, is-not, in-range |  | service-name | contains, does-not-contain |  | risk-score | is, is-not, in-range, is-greater-than,is-less-than |  | last-scan-date | is-on-or-before, is-on-or-after, is-between, is-earlier-than, is-within-the-last |  | vulnerability-assessed | is-on-or-before, is-on-or-after, is-between, is-earlier-than, is-within-the-last |  | vulnerability-category | is, is-not, starts-with, ends-with, contains, does-not-contain|  | vulnerability-cvss-score | is, is-not, in-range, is-greater-than, is-less-than |  | vulnerability-cvss-v3-score | is, is-not, in-range, is-greater-than, is-less-than |  | vulnerability-exposures | includes, does not-include |  | vulnerability-title | contains, does-not-contain, is, is-not, starts-with, ends-with |  | cve | is, is-not, contains, does-not-contain |  | cvss-access-complexity | is, is-not | | cvss-authentication-required | is, is-not | | cvss-access-vector | is, is-not | | cvss-availability-impact | is, is-not | | cvss-confidentiality-impact | is, is-not | | cvss-integrity-impact | is, is-not | | cvss-v3-confidentiality-impact | is, is-not | | cvss-v3-integrity-impact | is, is-not | | cvss-v3-availability-impact | is, is-not | | cvss-v3-attack-vector | is, is-not | | cvss-v3-attack-complexity | is, is-not | | cvss-v3-user-interaction | is, is-not | | cvss-v3-privileges-required | is, is-not | | mobile-device-last-sync | is-within-the-last, is-earlier-than |  | pci-compliance | is |  | site-id | in, not-in |  | criticality-tag | is, is-not, is-greater-than, is-less-than, is-applied, is-not-applied |  | custom-tag | is, is-not, starts-with, ends-with, contains, does-not-contain, is-applied, is-not-applied |  | location-tag | is, is-not, starts-with, ends-with, contains, does-not-contain, is-applied, is-not-applied |  | owner-tag | is, is-not, starts-with, ends-with, contains, does-not-contain, is-applied, is-not-applied |  | vulnerability-validated-status | are |  | vasset-cluster | is, is-not, contains, does-not-contain, starts-with |  | vasset-datacenter | is, is-not |  | vasset-host name | is, is-not, contains, does-not-contain, starts-with |  | vasset-power state | in, not-in |  | vasset-resource pool path | contains, does-not-contain |  | container-image | is, is-not, starts-with, ends-with, contains, does-not-contain, is-like, not-like |  | container-status | is, is-not |  | containers | are |   The following table outlines the operators and the values associated with them:  | Operator | Values |  | -------- | ------ |  | are | A single string property named \&quot;value\&quot; |  | is-between | A number property named \&quot;lower\&quot; and a number property named \&quot;upper\&quot; |  | contains | A single string property named \&quot;value\&quot; |  | does-not-contain | A single string property named \&quot;value\&quot; |  | is-earlier-than | A single number property named \&quot;value\&quot; |  | ends-with | A single string property named \&quot;value\&quot; |  | is-greater-than | A single number property named \&quot;value\&quot; |  | in | An array property named \&quot;values\&quot; |  | not-in | An array property named \&quot;values\&quot; |  | in-range | A number property named \&quot;lower\&quot; and a number property named \&quot;upper\&quot; |  | includes | An array property named \&quot;values\&quot; |  | is | A single string property named \&quot;value\&quot; |  | is-not | A single string property named \&quot;value\&quot; |  | is-applied | No value |  | is-not-applied | No value |  | is-empty | No value |  | is-not-empty | No value |  | is-less-than | A single number property named \&quot;value\&quot; |  | is-like | A single string property named \&quot;value\&quot; |  | does-not-contain | A single string property named \&quot;value\&quot; |  | not-in-range | A number property named \&quot;lower\&quot; and a number property named \&quot;upper\&quot; |  | not-like | A single string property named \&quot;value\&quot; |  | is-on-or-after | A single string property named \&quot;value\&quot;, which is the date in ISO8601 format (yyyy-MM-dd) |  | is-on-or-before | A single string property named \&quot;value\&quot;, which is the date in ISO8601 format (yyyy-MM-dd) |  | starts-with | A single string property named \&quot;value\&quot; |  | is-within-the-last | A single number property named \&quot;value\&quot; |   The following fields have enumerated values:  | Field | Acceptable Values |  | ----- | ----------------- |  | containers | 0&#x3D;present, 1&#x3D;not present |  | vulnerability-validated-status | 0&#x3D;present, 1&#x3D;not present |  | pci-compliance | 0&#x3D;fail, 1&#x3D;pass |  | alternate-address-type | 0&#x3D;IPv4, 1&#x3D;IPv6 |  | ip-address-type | 0&#x3D;IPv4, 1&#x3D;IPv6 |  | host-type | 0&#x3D;Unknown, 1&#x3D;Guest, 2&#x3D;Hypervisor, 3&#x3D;Physical, 4&#x3D;Mobile |  | cvss-access-complexity | L&#x3D;Low, M&#x3D;Medium, H&#x3D;High |  | cvss-integrity-impact | N&#x3D;None, P&#x3D;Partial, C&#x3D;Complete |  | cvss-confidentiality-impact | N&#x3D;None, P&#x3D;Partial, C&#x3D;Complete |  | cvss-availability-impact | N&#x3D;None, P&#x3D;Partial, C&#x3D;Complete |  | cvss-access-vector | L&#x3D;Local, A&#x3D;Adjacent, N&#x3D;Network |  | cvss-authentication-required | N&#x3D;None, S&#x3D;Single, M&#x3D;Multiple |  | cvss-access-complexity | L&#x3D;Low, M&#x3D;Medium, H&#x3D;High |  | cvss-v3-confidentiality-impact | N&#x3D;None, L&#x3D;Low, H&#x3D;High |  | cvss-v3-integrity-impact | N&#x3D;None, L&#x3D;Low, H&#x3D;High |  | cvss-v3-availability-impact | N&#x3D;None, L&#x3D;Low, H&#x3D;High |  | cvss-v3-attack-vector | N&#x3D;Network, A&#x3D;Adjacent, L&#x3D;Local, P&#x3D;Physical |  | cvss-v3-attack-complexity | L&#x3D;Low, H&#x3D;High |  | cvss-v3-user-interaction | N&#x3D;None, R&#x3D;Required |  | cvss-v3-privileges-required | N&#x3D;None, L&#x3D;Low, H&#x3D;High |  | container-status | created, running, paused, restarting, exited, dead, unknown |  
    # @param id The identifier of the tag.
    # @param [Hash] opts the optional parameters
    # @option opts [SearchCriteria] :body The details of the search criteria.
    # @return [Array<(Links, Integer, Hash)>] Links data, response status code and response headers
    def update_tag_search_criteria_with_http_info(site_idte_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: TagApi.update_tag_search_criteria ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && site_idte_id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling TagApi.update_tag_search_criteria"
      end
      # resource path
      local_var_path = '/api/3/tags/{id}/search_criteria'.sub('{' + 'id' + '}', site_idte_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=UTF-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] || 'Links' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: TagApi#update_tag_search_criteria\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
