# swagger_client

SwaggerClient - the Ruby gem for the InsightVM API

# Overview   This guide documents the InsightVM Application Programming Interface (API) Version 3. This API supports the Representation State Transfer (REST) design pattern. Unless noted otherwise this API accepts and produces the `application/json` media type. This API uses Hypermedia as the Engine of Application State (HATEOAS) and is hypermedia friendly. All API connections must be made to the security console using HTTPS.  ## Versioning  Versioning is specified in the URL and the base path of this API is: `https://<host>:<port>/api/3/`.  ## Specification  An <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md\">OpenAPI v2</a> specification (also  known as Swagger 2) of this API is available. Tools such as <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://github.com/swagger-api/swagger-codegen\">swagger-codegen</a> can be used to generate an API client in the language of your choosing using this specification document.  <p class=\"openapi\">Download the specification: <a class=\"openapi-button\" target=\"_blank\" rel=\"noopener noreferrer\" download=\"\" href=\"/insightvm/en-us/api/api-v3.json\"> Download </a></p>  ## Authentication  Authorization to the API uses HTTP Basic Authorization  (see <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://www.ietf.org/rfc/rfc2617.txt\">RFC 2617</a> for more information). Requests must  supply authorization credentials in the `Authorization` header using a Base64 encoded hash of `\"username:password\"`.  <!-- ReDoc-Inject: <security-definitions> -->  ### 2FA  This API supports two-factor authentication (2FA) by supplying an authentication token in addition to the Basic Authorization. The token is specified using the `Token` request header. To leverage two-factor authentication, this must be enabled on the console and be configured for the account accessing the API.  ## Resources  ### Naming  Resource names represent nouns and identify the entity being manipulated or accessed. All collection resources are  pluralized to indicate to the client they are interacting with a collection of multiple resources of the same type. Singular resource names are used when there exists only one resource available to interact with.  The following naming conventions are used by this API:  | Type                                          | Case                     | | --------------------------------------------- | ------------------------ | | Resource names                                | `lower_snake_case`       | | Header, body, and query parameters parameters | `camelCase`              | | JSON fields and property names                | `camelCase`              |  #### Collections  A collection resource is a parent resource for instance resources, but can itself be retrieved and operated on  independently. Collection resources use a pluralized resource name. The resource path for collection resources follow  the convention:  ``` /api/3/{resource_name} ```  #### Instances  An instance resource is a \"leaf\" level resource that may be retrieved, optionally nested within a collection resource. Instance resources are usually retrievable with opaque identifiers. The resource path for instance resources follows  the convention:  ``` /api/3/{resource_name}/{instance_id}... ```  ## Verbs  The following HTTP operations are supported throughout this API. The general usage of the operation and both its failure and success status codes are outlined below.    | Verb      | Usage                                                                                 | Success     | Failure                                                        | | --------- | ------------------------------------------------------------------------------------- | ----------- | -------------------------------------------------------------- | | `GET`     | Used to retrieve a resource by identifier, or a collection of resources by type.      | `200`       | `400`, `401`, `402`, `404`, `405`, `408`, `410`, `415`, `500`  | | `POST`    | Creates a resource with an application-specified identifier.                          | `201`       | `400`, `401`, `404`, `405`, `408`, `413`, `415`, `500`         | | `POST`    | Performs a request to queue an asynchronous job.                                      | `202`       | `400`, `401`, `405`, `408`, `410`, `413`, `415`, `500`         | | `PUT`     | Creates a resource with a client-specified identifier.                                | `200`       | `400`, `401`, `403`, `405`, `408`, `410`, `413`, `415`, `500`  | | `PUT`     | Performs a full update of a resource with a specified identifier.                     | `201`       | `400`, `401`, `403`, `405`, `408`, `410`, `413`, `415`, `500`  | | `DELETE`  | Deletes a resource by identifier or an entire collection of resources.                | `204`       | `400`, `401`, `405`, `408`, `410`, `413`, `415`, `500`         | | `OPTIONS` | Requests what operations are available on a resource.                                 | `200`       | `401`, `404`, `405`, `408`, `500`                              |  ### Common Operations  #### OPTIONS  All resources respond to the `OPTIONS` request, which allows discoverability of available operations that are supported.  The `OPTIONS` response returns the acceptable HTTP operations on that resource within the `Allow` header. The response is always a `200 OK` status.  ### Collection Resources  Collection resources can support the `GET`, `POST`, `PUT`, and `DELETE` operations.  #### GET  The `GET` operation invoked on a collection resource indicates a request to retrieve all, or some, of the entities  contained within the collection. This also includes the optional capability to filter or search resources during the request. The response from a collection listing is a paginated document. See  [hypermedia links](#section/Overview/Paging) for more information.  #### POST  The `POST` is a non-idempotent operation that allows for the creation of a new resource when the resource identifier  is not provided by the system during the creation operation (i.e. the Security Console generates the identifier). The content of the `POST` request is sent in the request body. The response to a successful `POST` request should be a  `201 CREATED` with a valid `Location` header field set to the URI that can be used to access to the newly  created resource.   The `POST` to a collection resource can also be used to interact with asynchronous resources. In this situation,  instead of a `201 CREATED` response, the `202 ACCEPTED` response indicates that processing of the request is not fully  complete but has been accepted for future processing. This request will respond similarly with a `Location` header with  link to the job-oriented asynchronous resource that was created and/or queued.  #### PUT  The `PUT` is an idempotent operation that either performs a create with user-supplied identity, or a full replace or update of a resource by a known identifier. The response to a `PUT` operation to create an entity is a `201 Created` with a valid `Location` header field set to the URI that can be used to access to the newly created resource.  `PUT` on a collection resource replaces all values in the collection. The typical response to a `PUT` operation that  updates an entity is hypermedia links, which may link to related resources caused by the side-effects of the changes  performed.  #### DELETE  The `DELETE` is an idempotent operation that physically deletes a resource, or removes an association between resources. The typical response to a `DELETE` operation is hypermedia links, which may link to related resources caused by the  side-effects of the changes performed.  ### Instance Resources  Instance resources can support the `GET`, `PUT`, `POST`, `PATCH` and `DELETE` operations.  #### GET  Retrieves the details of a specific resource by its identifier. The details retrieved can be controlled through  property selection and property views. The content of the resource is returned within the body of the response in the  acceptable media type.   #### PUT  Allows for and idempotent \"full update\" (complete replacement) on a specific resource. If the resource does not exist,  it will be created; if it does exist, it is completely overwritten. Any omitted properties in the request are assumed to  be undefined/null. For \"partial updates\" use `POST` or `PATCH` instead.   The content of the `PUT` request is sent in the request body. The identifier of the resource is specified within the URL  (not the request body). The response to a successful `PUT` request is a `201 CREATED` to represent the created status,  with a valid `Location` header field set to the URI that can be used to access to the newly created (or fully replaced)  resource.   #### POST  Performs a non-idempotent creation of a new resource. The `POST` of an instance resource most commonly occurs with the  use of nested resources (e.g. searching on a parent collection resource). The response to a `POST` of an instance  resource is typically a `200 OK` if the resource is non-persistent, and a `201 CREATED` if there is a resource  created/persisted as a result of the operation. This varies by endpoint.  #### PATCH  The `PATCH` operation is used to perform a partial update of a resource. `PATCH` is a non-idempotent operation that enforces an atomic mutation of a resource. Only the properties specified in the request are to be overwritten on the  resource it is applied to. If a property is missing, it is assumed to not have changed.  #### DELETE  Permanently removes the individual resource from the system. If the resource is an association between resources, only  the association is removed, not the resources themselves. A successful deletion of the resource should return  `204 NO CONTENT` with no response body. This operation is not fully idempotent, as follow-up requests to delete a  non-existent resource should return a `404 NOT FOUND`.  ## Requests  Unless otherwise indicated, the default request body media type is `application/json`.  ### Headers  Commonly used request headers include:  | Header             | Example                                       | Purpose                                                                                        |                    | ------------------ | --------------------------------------------- | ---------------------------------------------------------------------------------------------- | | `Accept`           | `application/json`                            | Defines what acceptable content types are allowed by the client. For all types, use `*/*`.     | | `Accept-Encoding`  | `deflate, gzip`                               | Allows for the encoding to be specified (such as gzip).                                        | | `Accept-Language`  | `en-US`                                       | Indicates to the server the client's locale (defaults `en-US`).                                | | `Authorization `   | `Basic Base64(\"username:password\")`           | Basic authentication                                                                           | | `Token `           | `123456`                                      | Two-factor authentication token (if enabled)                                                   |  ### Dates & Times  Dates and/or times are specified as strings in the ISO 8601 format(s). The following formats are supported as input:  | Value                       | Format                                                 | Notes                                                 | | --------------------------- | ------------------------------------------------------ | ----------------------------------------------------- | | Date                        | YYYY-MM-DD                                             | Defaults to 12 am UTC (if used for a date & time      | | Date & time only            | YYYY-MM-DD'T'hh:mm:ss[.nnn]                            | Defaults to UTC                                       | | Date & time in UTC          | YYYY-MM-DD'T'hh:mm:ss[.nnn]Z                           |                                                       | | Date & time w/ offset       | YYYY-MM-DD'T'hh:mm:ss[.nnn][+&#124;-]hh:mm             |                                                       | | Date & time w/ zone-offset  | YYYY-MM-DD'T'hh:mm:ss[.nnn][+&#124;-]hh:mm[<zone-id>]  |                                                       |   ### Timezones  Timezones are specified in the regional zone format, such as `\"America/Los_Angeles\"`, `\"Asia/Tokyo\"`, or `\"GMT\"`.   ### Paging  Pagination is supported on certain collection resources using a combination of two query parameters, `page` and `size`.  As these are control parameters, they are prefixed with the underscore character. The page parameter dictates the  zero-based index of the page to retrieve, and the `size` indicates the size of the page.   For example, `/resources?page=2&size=10` will return page 3, with 10 records per page, giving results 21-30.  The maximum page size for a request is 500.  ### Sorting  Sorting is supported on paginated resources with the `sort` query parameter(s). The sort query parameter(s) supports  identifying a single or multi-property sort with a single or multi-direction output. The format of the parameter is:  ``` sort=property[,ASC|DESC]... ```  Therefore, the request `/resources?sort=name,title,DESC` would return the results sorted by the name and title  descending, in that order. The sort directions are either ascending `ASC` or descending `DESC`. With single-order  sorting, all properties are sorted in the same direction. To sort the results with varying orders by property,  multiple sort parameters are passed.    For example, the request `/resources?sort=name,ASC&sort=title,DESC` would sort by name ascending and title  descending, in that order.  ## Responses  The following response statuses may be returned by this API.     | Status | Meaning                  | Usage                                                                                                                                                                    | | ------ | ------------------------ |------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | | `200`  | OK                       | The operation performed without error according to the specification of the request, and no more specific 2xx code is suitable.                                          | | `201`  | Created                  | A create request has been fulfilled and a resource has been created. The resource is available as the URI specified in the response, including the `Location` header.    | | `202`  | Accepted                 | An asynchronous task has been accepted, but not guaranteed, to be processed in the future.                                                                               | | `400`  | Bad Request              | The request was invalid or cannot be otherwise served. The request is not likely to succeed in the future without modifications.                                         | | `401`  | Unauthorized             | The user is unauthorized to perform the operation requested, or does not maintain permissions to perform the operation on the resource specified.                        | | `403`  | Forbidden                | The resource exists to which the user has access, but the operating requested is not permitted.                                                                          | | `404`  | Not Found                | The resource specified could not be located, does not exist, or an unauthenticated client does not have permissions to a resource.                                       | | `405`  | Method Not Allowed       | The operations may not be performed on the specific resource. Allowed operations are returned and may be performed on the resource.                                      | | `408`  | Request Timeout          | The client has failed to complete a request in a timely manner and the request has been discarded.                                                                       | | `413`  | Request Entity Too Large | The request being provided is too large for the server to accept processing.                                                                                             | | `415`  | Unsupported Media Type   | The media type is not supported for the requested resource.                                                                                                              | | `500`  | Internal Server Error    | An internal and unexpected error has occurred on the server at no fault of the client.                                                                                   |  ### Security  The response statuses 401, 403 and 404 need special consideration for security purposes. As necessary,  error statuses and messages may be obscured to strengthen security and prevent information exposure. The following is a  guideline for privileged resource response statuses:  | Use Case                                                           | Access             | Resource           | Permission   | Status       | | ------------------------------------------------------------------ | ------------------ |------------------- | ------------ | ------------ | | Unauthenticated access to an unauthenticated resource.             | Unauthenticated    | Unauthenticated    | Yes          | `20x`        | | Unauthenticated access to an authenticated resource.               | Unauthenticated    | Authenticated      | No           | `401`        | | Unauthenticated access to an authenticated resource.               | Unauthenticated    | Non-existent       | No           | `401`        | | Authenticated access to a unauthenticated resource.                | Authenticated      | Unauthenticated    | Yes          | `20x`        | | Authenticated access to an authenticated, unprivileged resource.   | Authenticated      | Authenticated      | No           | `404`        | | Authenticated access to an authenticated, privileged resource.     | Authenticated      | Authenticated      | Yes          | `20x`        | | Authenticated access to an authenticated, non-existent resource    | Authenticated      | Non-existent       | Yes          | `404`        |  ### Headers  Commonly used response headers include:  | Header                     |  Example                          | Purpose                                                         | | -------------------------- | --------------------------------- | --------------------------------------------------------------- | | `Allow`                    | `OPTIONS, GET`                    | Defines the allowable HTTP operations on a resource.            | | `Cache-Control`            | `no-store, must-revalidate`       | Disables caching of resources (as they are all dynamic).        | | `Content-Encoding`         | `gzip`                            | The encoding of the response body (if any).                     | | `Location`                 |                                   | Refers to the URI of the resource created by a request.         | | `Transfer-Encoding`        | `chunked`                         | Specified the encoding used to transform response.              | | `Retry-After`              | 5000                              | Indicates the time to wait before retrying a request.           | | `X-Content-Type-Options`   | `nosniff`                         | Disables MIME type sniffing.                                    | | `X-XSS-Protection`         | `1; mode=block`                   | Enables XSS filter protection.                                  | | `X-Frame-Options`          | `SAMEORIGIN`                      | Prevents rendering in a frame from a different origin.          | | `X-UA-Compatible`          | `IE=edge,chrome=1`                | Specifies the browser mode to render in.                        |  ### Format  When `application/json` is returned in the response body it is always pretty-printed (indented, human readable output).  Additionally, gzip compression/encoding is supported on all responses.   #### Dates & Times  Dates or times are returned as strings in the ISO 8601 'extended' format. When a date and time is returned (instant) the value is converted to UTC.  For example:  | Value           | Format                         | Example               | | --------------- | ------------------------------ | --------------------- | | Date            | `YYYY-MM-DD`                   | 2017-12-03            | | Date & Time     | `YYYY-MM-DD'T'hh:mm:ss[.nnn]Z` | 2017-12-03T10:15:30Z  |  #### Content  In some resources a Content data type is used. This allows for multiple formats of representation to be returned within resource, specifically `\"html\"` and `\"text\"`. The `\"text\"` property returns a flattened representation suitable for output in textual displays. The `\"html\"` property returns an HTML fragment suitable for display within an HTML  element. Note, the HTML returned is not a valid stand-alone HTML document.  #### Paging  The response to a paginated request follows the format:  ```json {    resources\": [        ...     ],    \"page\": {        \"number\" : ...,       \"size\" : ...,       \"totalResources\" : ...,       \"totalPages\" : ...    },    \"links\": [        \"first\" : {          \"href\" : \"...\"        },        \"prev\" : {          \"href\" : \"...\"        },        \"self\" : {          \"href\" : \"...\"        },        \"next\" : {          \"href\" : \"...\"        },        \"last\" : {          \"href\" : \"...\"        }     ] } ```  The `resources` property is an array of the resources being retrieved from the endpoint, each which should contain at  minimum a \"self\" relation hypermedia link. The `page` property outlines the details of the current page and total possible pages. The object for the page includes the following properties:  - number - The page number (zero-based) of the page returned. - size - The size of the pages, which is less than or equal to the maximum page size. - totalResources - The total amount of resources available across all pages. - totalPages - The total amount of pages.  The last property of the paged response is the `links` array, which contains all available hypermedia links. For  paginated responses, the \"self\", \"next\", \"previous\", \"first\", and \"last\" links are returned. The \"self\" link must always be returned and should contain a link to allow the client to replicate the original request against the  collection resource in an identical manner to that in which it was invoked.   The \"next\" and \"previous\" links are present if either or both there exists a previous or next page, respectively.  The \"next\" and \"previous\" links have hrefs that allow \"natural movement\" to the next page, that is all parameters  required to move the next page are provided in the link. The \"first\" and \"last\" links provide references to the first and last pages respectively.   Requests outside the boundaries of the pageable will result in a `404 NOT FOUND`. Paginated requests do not provide a  \"stateful cursor\" to the client, nor does it need to provide a read consistent view. Records in adjacent pages may  change while pagination is being traversed, and the total number of pages and resources may change between requests  within the same filtered/queries resource collection.  #### Property Views  The \"depth\" of the response of a resource can be configured using a \"view\". All endpoints supports two views that can  tune the extent of the information returned in the resource. The supported views are `summary` and `details` (the default).  View are specified using a query parameter, in this format:  ```bash /<resource>?view={viewName} ```  #### Error  Any error responses can provide a response body with a message to the client indicating more information (if applicable)  to aid debugging of the error. All 40x and 50x responses will return an error response in the body. The format of the  response is as follows:  ```json {    \"status\": <statusCode>,    \"message\": <message>,    \"links\" : [ {       \"rel\" : \"...\",       \"href\" : \"...\"     } ] }   ```   The `status` property is the same as the HTTP status returned in the response, to ease client parsing. The message  property is a localized message in the request client's locale (if applicable) that articulates the nature of the  error. The last property is the `links` property. This may contain additional  [hypermedia links](#section/Overview/Authentication) to troubleshoot.  #### Search Criteria <a section=\"section/Responses/SearchCriteria\"></a>  Multiple resources make use of search criteria to match assets. Search criteria is an array of search filters. Each  search filter has a generic format of:  ```json {     \"field\": \"<field-name>\",     \"operator\": \"<operator>\",     [\"value\": <value>,]    [\"lower\": <value>,]    [\"upper\": <value>] }     ```  Every filter defines two required properties `field` and `operator`. The field is the name of an asset property that is being filtered on. The operator is a type and property-specific operating performed on the filtered property. The valid values for fields and operators are outlined in the table below. Depending on the data type of the operator the value may be a numeric or string format.  Every filter also defines one or more values that are supplied to the operator. The valid values vary by operator and are outlined below.  ##### Fields  The following table outlines the search criteria fields and the available operators:  | Field                             | Operators                                                                                                                      | | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | | `alternate-address-type`          | `in`                                                                                                                           | | `container-image`                 | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain` `is-like` `not-like`                                     | | `container-status`                | `is` `is-not`                                                                                                                  | | `containers`                      | `are`                                                                                                                          | | `criticality-tag`                 | `is` `is-not` `is-greater-than` `is-less-than` `is-applied` ` is-not-applied`                                                  | | `custom-tag`                      | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain` `is-applied` `is-not-applied`                            | | `cve`                             | `is` `is-not` `contains` `does-not-contain`                                                                                    | | `cvss-access-complexity`          | `is` `is-not`                                                                                                                  | | `cvss-authentication-required`    | `is` `is-not`                                                                                                                  | | `cvss-access-vector`              | `is` `is-not`                                                                                                                  | | `cvss-availability-impact`        | `is` `is-not`                                                                                                                  | | `cvss-confidentiality-impact`     | `is` `is-not`                                                                                                                  | | `cvss-integrity-impact`           | `is` `is-not`                                                                                                                  | | `cvss-v3-confidentiality-impact`  | `is` `is-not`                                                                                                                  | | `cvss-v3-integrity-impact`        | `is` `is-not`                                                                                                                  | | `cvss-v3-availability-impact`     | `is` `is-not`                                                                                                                  | | `cvss-v3-attack-vector`           | `is` `is-not`                                                                                                                  | | `cvss-v3-attack-complexity`       | `is` `is-not`                                                                                                                  | | `cvss-v3-user-interaction`        | `is` `is-not`                                                                                                                  | | `cvss-v3-privileges-required`     | `is` `is-not`                                                                                                                  | | `host-name`                       | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain` `is-empty` `is-not-empty` `is-like` `not-like`           | | `host-type`                       | `in` `not-in`                                                                                                                  | | `ip-address`                      | `is` `is-not` `in-range` `not-in-range` `is-like` `not-like`                                                                   | | `ip-address-type`                 | `in` `not-in`                                                                                                                  | | `last-scan-date`                  | `is-on-or-before` `is-on-or-after` `is-between` `is-earlier-than` `is-within-the-last`                                         | | `location-tag`                    | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain` `is-applied` `is-not-applied`                            | | `mobile-device-last-sync-time`    | `is-within-the-last` `is-earlier-than`                                                                                         | | `open-ports`                      | `is` `is-not` ` in-range`                                                                                                      | | `operating-system`                | `contains` ` does-not-contain` ` is-empty` ` is-not-empty`                                                                     | | `owner-tag`                       | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain` `is-applied` `is-not-applied`                            | | `pci-compliance`                  | `is`                                                                                                                           | | `risk-score`                      | `is` `is-not` `is-greater-than` `is-less-than` `in-range`                                                                      | | `service-name`                    | `contains` `does-not-contain`                                                                                                  | | `site-id`                         | `in` `not-in`                                                                                                                  | | `software`                        | `contains` `does-not-contain`                                                                                                  | | `vAsset-cluster`                  | `is` `is-not` `contains` `does-not-contain` `starts-with`                                                                      | | `vAsset-datacenter`               | `is` `is-not`                                                                                                                  | | `vAsset-host-name`                | `is` `is-not` `contains` `does-not-contain` `starts-with`                                                                      | | `vAsset-power-state`              | `in` `not-in`                                                                                                                  | | `vAsset-resource-pool-path`       | `contains` `does-not-contain`                                                                                                  | | `vulnerability-assessed`          | `is-on-or-before` `is-on-or-after` `is-between` `is-earlier-than` `is-within-the-last`                                         | | `vulnerability-category`          | `is` `is-not` `starts-with` `ends-with` `contains` `does-not-contain`                                                          | | `vulnerability-cvss-v3-score`     | `is` `is-not`                                                                                                                  | | `vulnerability-cvss-score`        | `is` `is-not` `in-range` `is-greater-than` `is-less-than`                                                                      | | `vulnerability-exposures`         | `includes` `does-not-include`                                                                                                  | | `vulnerability-title`             | `contains` `does-not-contain` `is` `is-not` `starts-with` `ends-with`                                                          | | `vulnerability-validated-status`  | `are`                                                                                                                          |  ##### Enumerated Properties  The following fields have enumerated values:  | Field                                     | Acceptable Values                                                                                             | | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------- | | `alternate-address-type`                  | 0=IPv4, 1=IPv6                                                                                                | | `containers`                              | 0=present, 1=not present                                                                                      | | `container-status`                        | `created` `running` `paused` `restarting` `exited` `dead` `unknown`                                           | | `cvss-access-complexity`                  | <ul><li><code>L</code> = Low</li><li><code>M</code> = Medium</li><li><code>H</code> = High</li></ul>          | | `cvss-integrity-impact`                   | <ul><li><code>N</code> = None</li><li><code>P</code> = Partial</li><li><code>C</code> = Complete</li></ul>    | | `cvss-confidentiality-impact`             | <ul><li><code>N</code> = None</li><li><code>P</code> = Partial</li><li><code>C</code> = Complete</li></ul>    | | `cvss-availability-impact`                | <ul><li><code>N</code> = None</li><li><code>P</code> = Partial</li><li><code>C</code> = Complete</li></ul>    | | `cvss-access-vector`                      | <ul><li><code>L</code> = Local</li><li><code>A</code> = Adjacent</li><li><code>N</code> = Network</li></ul>   | | `cvss-authentication-required`            | <ul><li><code>N</code> = None</li><li><code>S</code> = Single</li><li><code>M</code> = Multiple</li></ul>     | | `cvss-v3-confidentiality-impact`     | <ul><li><code>L</code> = Local</li><li><code>L</code> = Low</li><li><code>N</code> = None</li><li><code>H</code> = High</li></ul>          | | `cvss-v3-integrity-impact`            | <ul><li><code>L</code> = Local</li><li><code>L</code> = Low</li><li><code>N</code> = None</li><li><code>H</code> = High</li></ul>          | | `cvss-v3-availability-impact`             | <ul><li><code>N</code> = None</li><li><code>L</code> = Low</li><li><code>H</code> = High</li></ul>    | | `cvss-v3-attack-vector`                | <ul><li><code>N</code> = Network</li><li><code>A</code> = Adjacent</li><li><code>L</code> = Local</li><li><code>P</code> = Physical</li></ul>    | | `cvss-v3-attack-complexity`                      | <ul><li><code>L</code> = Low</li><li><code>H</code> = High</li></ul>   | | `cvss-v3-user-interaction`            | <ul><li><code>N</code> = None</li><li><code>R</code> = Required</li></ul>     | | `cvss-v3-privileges-required`         | <ul><li><code>N</code> = None</li><li><code>L</code> = Low</li><li><code>H</code> = High</li></ul>    | | `host-type`                               | 0=Unknown, 1=Guest, 2=Hypervisor, 3=Physical, 4=Mobile                                                        | | `ip-address-type`                         | 0=IPv4, 1=IPv6                                                                                                | | `pci-compliance`                          | 0=fail, 1=pass                                                                                                | | `vulnerability-validated-status`          | 0=present, 1=not present                                                                                      |  ##### Operator Properties <a section=\"section/Responses/SearchCriteria/OperatorProperties\"></a>  The following table outlines which properties are required for each operator and the appropriate data type(s):  | Operator              | `value`               | `lower`               | `upper`                | | ----------------------|-----------------------|-----------------------|------------------------| | `are`                 | `string`              |                       |                        | | `contains`            | `string`              |                       |                        | | `does-not-contain`    | `string`              |                       |                        | | `ends with`           | `string`              |                       |                        | | `in`                  | `Array[ string ]`     |                       |                        | | `in-range`            |                       | `numeric`             | `numeric`              | | `includes`            | `Array[ string ]`     |                       |                        | | `is`                  | `string`              |                       |                        | | `is-applied`          |                       |                       |                        | | `is-between`          |                       | `string` (yyyy-MM-dd) | `numeric` (yyyy-MM-dd) | | `is-earlier-than`     | `numeric` (days)      |                       |                        | | `is-empty`            |                       |                       |                        | | `is-greater-than`     | `numeric`             |                       |                        | | `is-on-or-after`      | `string` (yyyy-MM-dd) |                       |                        | | `is-on-or-before`     | `string` (yyyy-MM-dd) |                       |                        | | `is-not`              | `string`              |                       |                        | | `is-not-applied`      |                       |                       |                        | | `is-not-empty`        |                       |                       |                        | | `is-within-the-last`  | `numeric` (days)      |                       |                        | | `less-than`           | `string`              |                       |                        |  | `like`                | `string`              |                       |                        | | `not-contains`        | `string`              |                       |                        | | `not-in`              | `Array[ string ]`     |                       |                        | | `not-in-range`        |                       | `numeric`             | `numeric`              | | `not-like`            | `string`              |                       |                        | | `starts-with`         | `string`              |                       |                        |  #### Discovery Connection Search Criteria <a section=\"section/Responses/DiscoverySearchCriteria\"></a>  Dynamic sites make use of search criteria to match assets from a discovery connection. Search criteria is an array of search filters.    Each search filter has a generic format of:  ```json {     \"field\": \"<field-name>\",     \"operator\": \"<operator>\",     [\"value\": \"<value>\",]    [\"lower\": \"<value>\",]    [\"upper\": \"<value>\"] }     ```  Every filter defines two required properties `field` and `operator`. The field is the name of an asset property that is being filtered on. The list of supported fields vary depending on the type of discovery connection configured  for the dynamic site (e.g vSphere, ActiveSync, etc.). The operator is a type and property-specific operating  performed on the filtered property. The valid values for fields outlined in the tables below and are grouped by the  type of connection.    Every filter also defines one or more values that are supplied to the operator. See  <a href=\"#section/Responses/SearchCriteria/OperatorProperties\">Search Criteria Operator Properties</a> for more  information on the valid values for each operator.    ##### Fields (ActiveSync)  This section documents search criteria information for ActiveSync discovery connections. The discovery connections  must be one of the following types: `\"activesync-ldap\"`, `\"activesync-office365\"`, or `\"activesync-powershell\"`.    The following table outlines the search criteria fields and the available operators for ActiveSync connections:  | Field                             | Operators                                                     | | --------------------------------- | ------------------------------------------------------------- | | `last-sync-time`                  | `is-within-the-last` ` is-earlier-than`                       | | `operating-system`                | `contains` ` does-not-contain`                                | | `user`                            | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with` |  ##### Fields (AWS)  This section documents search criteria information for AWS discovery connections. The discovery connections must be the type `\"aws\"`.    The following table outlines the search criteria fields and the available operators for AWS connections:  | Field                   | Operators                                                     | | ----------------------- | ------------------------------------------------------------- | | `availability-zone`     | `contains` ` does-not-contain`                                | | `guest-os-family`       | `contains` ` does-not-contain`                                | | `instance-id`           | `contains` ` does-not-contain`                                | | `instance-name`         | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with` | | `instance-state`        | `in` ` not-in`                                                | | `instance-type`         | `in` ` not-in`                                                | | `ip-address`            | `in-range` ` not-in-range` ` is` ` is-not`                    | | `region`                | `in` ` not-in`                                                | | `vpc-id`                | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with` |  ##### Fields (DHCP)  This section documents search criteria information for DHCP discovery connections. The discovery connections must be the type `\"dhcp\"`.    The following table outlines the search criteria fields and the available operators for DHCP connections:  | Field           | Operators                                                     | | --------------- | ------------------------------------------------------------- | | `host-name`     | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with` | | `ip-address`    | `in-range` ` not-in-range` ` is` ` is-not`                    | | `mac-address`   | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with` |  ##### Fields (Sonar)  This section documents search criteria information for Sonar discovery connections. The discovery connections must be the type `\"sonar\"`.    The following table outlines the search criteria fields and the available operators for Sonar connections:  | Field               | Operators            | | ------------------- | -------------------- | | `search-domain`     | `contains` ` is`     | | `ip-address`        | `in-range` ` is`     | | `sonar-scan-date`   | `is-within-the-last` |  ##### Fields (vSphere)  This section documents search criteria information for vSphere discovery connections. The discovery connections must be the type `\"vsphere\"`.    The following table outlines the search criteria fields and the available operators for vSphere connections:  | Field                | Operators                                                                                  | | -------------------- | ------------------------------------------------------------------------------------------ | | `cluster`            | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with`                              | | `data-center`        | `is` ` is-not`                                                                             | | `discovered-time`    | `is-on-or-before` ` is-on-or-after` ` is-between` ` is-earlier-than` ` is-within-the-last` | | `guest-os-family`    | `contains` ` does-not-contain`                                                             | | `host-name`          | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with`                              | | `ip-address`         | `in-range` ` not-in-range` ` is` ` is-not`                                                 | | `power-state`        | `in` ` not-in`                                                                             | | `resource-pool-path` | `contains` ` does-not-contain`                                                             | | `last-time-seen`     | `is-on-or-before` ` is-on-or-after` ` is-between` ` is-earlier-than` ` is-within-the-last` | | `vm`                 | `is` ` is-not` ` contains` ` does-not-contain` ` starts-with`                              |  ##### Enumerated Properties (vSphere)  The following fields have enumerated values:  | Field         | Acceptable Values                    | | ------------- | ------------------------------------ | | `power-state` | `poweredOn` `poweredOff` `suspended` |  ## HATEOAS  This API follows Hypermedia as the Engine of Application State (HATEOAS) principals and is therefore hypermedia friendly.  Hyperlinks are returned in the `links` property of any given resource and contain a fully-qualified hyperlink to the corresponding resource. The format of the hypermedia link adheres to both the <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"http://jsonapi.org\">{json:api} v1</a>  <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"http://jsonapi.org/format/#document-links\">\"Link Object\"</a> and  <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"http://json-schema.org/latest/json-schema-hypermedia.html\">JSON Hyper-Schema</a>  <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"http://json-schema.org/latest/json-schema-hypermedia.html#rfc.section.5.2\">\"Link Description Object\"</a> formats. For example:  ```json \"links\": [{   \"rel\": \"<relation>\",   \"href\": \"<href>\"   ... }] ```  Where appropriate link objects may also contain additional properties than the `rel` and `href` properties, such as `id`, `type`, etc.  See the [Root](#tag/Root) resources for the entry points into API discovery. 

This SDK is automatically generated by the [Swagger Codegen](https://github.com/swagger-api/swagger-codegen) project:

- API version: 3
- Package version: 1.0.0
- Build package: io.swagger.codegen.v3.generators.ruby.RubyClientCodegen

## Installation

### Build a gem

To build the Ruby code into a gem:

```shell
gem build swagger_client.gemspec
```

Then either install the gem locally:

```shell
gem install ./swagger_client-1.0.0.gem
```
(for development, run `gem install --dev ./swagger_client-1.0.0.gem` to install the development dependencies)

or publish the gem to a gem hosting service, e.g. [RubyGems](https://rubygems.org/).

Finally add this to the Gemfile:

    gem 'swagger_client', '~> 1.0.0'

### Install from Git

If the Ruby gem is hosted at a git repository: https://github.com/GIT_USER_ID/GIT_REPO_ID, then add the following in the Gemfile:

    gem 'swagger_client', :git => 'https://github.com/GIT_USER_ID/GIT_REPO_ID.git'

### Include the Ruby code directly

Include the Ruby code directly using `-I` as follows:

```shell
ruby -Ilib script.rb
```

## Getting Started

Please follow the [installation](#installation) procedure and then run the following code:
```ruby
# Load the gem
require 'swagger_client'

api_instance = SwaggerClient::AdministrationApi.new
opts = { 
  license: 'license_example', # String | 
  key: 'key_example' # String | A license activation key.
}

begin
  #License
  result = api_instance.activate_license(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AdministrationApi->activate_license: #{e}"
end

api_instance = SwaggerClient::AdministrationApi.new
opts = { 
  body: 'body_example' # String | The console command to execute.
}

begin
  #Console Commands
  result = api_instance.execute_command(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AdministrationApi->execute_command: #{e}"
end

api_instance = SwaggerClient::AdministrationApi.new

begin
  #Information
  result = api_instance.get_info
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AdministrationApi->get_info: #{e}"
end

api_instance = SwaggerClient::AdministrationApi.new

begin
  #License
  result = api_instance.get_license
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AdministrationApi->get_license: #{e}"
end

api_instance = SwaggerClient::AdministrationApi.new

begin
  #Properties
  result = api_instance.get_properties
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AdministrationApi->get_properties: #{e}"
end

api_instance = SwaggerClient::AdministrationApi.new

begin
  #Settings
  result = api_instance.get_settings
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AdministrationApi->get_settings: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.
tag_id = 56 # Integer | The identifier of the tag.


begin
  #Asset Tag
  result = api_instance.add_asset_tag(id, tag_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->add_asset_tag: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: SwaggerClient::AssetCreate.new # AssetCreate | The details of the asset being added or updated. 
The operating system can be specified in one of three ways, with the order of precedence: `"osFingerprint"`, `"os"`, `"cpe"`
}

begin
  #Assets
  result = api_instance.create_asset(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->create_asset: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.


begin
  #Asset
  result = api_instance.delete_asset(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->delete_asset: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
body = SwaggerClient::SearchCriteria.new # SearchCriteria | param1
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Asset Search
  result = api_instance.find_assets(body, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->find_assets: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.


begin
  #Asset
  result = api_instance.get_asset(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.


begin
  #Asset Databases
  result = api_instance.get_asset_databases(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_databases: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.


begin
  #Asset Files
  result = api_instance.get_asset_files(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_files: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.
protocol = 'protocol_example' # String | The protocol of the service.
port = 56 # Integer | The port of the service.


begin
  #Asset Service
  result = api_instance.get_asset_service(id, protocol, port)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_service: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.
protocol = 'protocol_example' # String | The protocol of the service.
port = 56 # Integer | The port of the service.


begin
  #Asset Service Configurations
  result = api_instance.get_asset_service_configurations(id, protocol, port)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_service_configurations: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.
protocol = 'protocol_example' # String | The protocol of the service.
port = 56 # Integer | The port of the service.


begin
  #Asset Service Databases
  result = api_instance.get_asset_service_databases(id, protocol, port)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_service_databases: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.
protocol = 'protocol_example' # String | The protocol of the service.
port = 56 # Integer | The port of the service.


begin
  #Asset Service User Groups
  result = api_instance.get_asset_service_user_groups(id, protocol, port)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_service_user_groups: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.
protocol = 'protocol_example' # String | The protocol of the service.
port = 56 # Integer | The port of the service.


begin
  #Asset Service Users
  result = api_instance.get_asset_service_users(id, protocol, port)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_service_users: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.
protocol = 'protocol_example' # String | The protocol of the service.
port = 56 # Integer | The port of the service.
web_application_id = 789 # Integer | The identifier of the web application.


begin
  #Asset Service Web Application
  result = api_instance.get_asset_service_web_application(id, protocol, port, web_application_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_service_web_application: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.
protocol = 'protocol_example' # String | The protocol of the service.
port = 56 # Integer | The port of the service.


begin
  #Asset Service Web Applications
  result = api_instance.get_asset_service_web_applications(id, protocol, port)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_service_web_applications: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.


begin
  #Asset Services
  result = api_instance.get_asset_services(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_services: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.


begin
  #Asset Software
  result = api_instance.get_asset_software(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_software: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.


begin
  #Asset Tags
  result = api_instance.get_asset_tags(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_tags: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.


begin
  #Asset User Groups
  result = api_instance.get_asset_user_groups(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_user_groups: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.


begin
  #Asset Users
  result = api_instance.get_asset_users(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_asset_users: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Assets
  result = api_instance.get_assets(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_assets: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the operating system.


begin
  #Operating System
  result = api_instance.get_operating_system(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_operating_system: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Operating Systems
  result = api_instance.get_operating_systems(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_operating_systems: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the software.


begin
  #Software
  result = api_instance.get_software(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_software: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Software
  result = api_instance.get_softwares(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->get_softwares: #{e}"
end

api_instance = SwaggerClient::AssetApi.new
id = 789 # Integer | The identifier of the asset.
tag_id = 56 # Integer | The identifier of the tag.


begin
  #Asset Tag
  result = api_instance.remove_asset_tag(id, tag_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetApi->remove_asset_tag: #{e}"
end

api_instance = SwaggerClient::AssetDiscoveryApi.new
opts = { 
  body: SwaggerClient::SonarQuery.new # SonarQuery | The criteria for a Sonar query.
}

begin
  #Sonar Queries
  result = api_instance.create_sonar_query(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetDiscoveryApi->create_sonar_query: #{e}"
end

api_instance = SwaggerClient::AssetDiscoveryApi.new
id = 789 # Integer | The identifier of the Sonar query.


begin
  #Sonar Query
  result = api_instance.delete_sonar_query(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetDiscoveryApi->delete_sonar_query: #{e}"
end

api_instance = SwaggerClient::AssetDiscoveryApi.new
id = 789 # Integer | The identifier of the discovery connection.


begin
  #Discovery Connection
  result = api_instance.get_discovery_connection(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetDiscoveryApi->get_discovery_connection: #{e}"
end

api_instance = SwaggerClient::AssetDiscoveryApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Discovery Connections
  result = api_instance.get_discovery_connections(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetDiscoveryApi->get_discovery_connections: #{e}"
end

api_instance = SwaggerClient::AssetDiscoveryApi.new

begin
  #Sonar Queries
  result = api_instance.get_sonar_queries
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetDiscoveryApi->get_sonar_queries: #{e}"
end

api_instance = SwaggerClient::AssetDiscoveryApi.new
id = 789 # Integer | The identifier of the Sonar query.


begin
  #Sonar Query
  result = api_instance.get_sonar_query(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetDiscoveryApi->get_sonar_query: #{e}"
end

api_instance = SwaggerClient::AssetDiscoveryApi.new
id = 789 # Integer | The identifier of the Sonar query.


begin
  #Sonar Query Assets
  result = api_instance.get_sonar_query_assets(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetDiscoveryApi->get_sonar_query_assets: #{e}"
end

api_instance = SwaggerClient::AssetDiscoveryApi.new
id = 789 # Integer | The identifier of the discovery connection.


begin
  #Discovery Connection Reconnect
  api_instance.reconnect_discovery_connection(id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetDiscoveryApi->reconnect_discovery_connection: #{e}"
end

api_instance = SwaggerClient::AssetDiscoveryApi.new
opts = { 
  body: SwaggerClient::SonarCriteria.new # SonarCriteria | The criteria for a Sonar query.
}

begin
  #Sonar Query Search
  result = api_instance.sonar_query_search(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetDiscoveryApi->sonar_query_search: #{e}"
end

api_instance = SwaggerClient::AssetDiscoveryApi.new
id = 789 # Integer | The identifier of the Sonar query.
opts = { 
  body: SwaggerClient::SonarQuery.new # SonarQuery | The criteria for a Sonar query.
}

begin
  #Sonar Query
  result = api_instance.update_sonar_query(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetDiscoveryApi->update_sonar_query: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
tag_id = 56 # Integer | The identifier of the tag.


begin
  #Resources and operations for managing asset groups.
  result = api_instance.add_asset_group_tag(id, tag_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->add_asset_group_tag: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
user_id = 56 # Integer | The identifier of the user.


begin
  #Asset Group User
  result = api_instance.add_asset_group_user(id, user_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->add_asset_group_user: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
asset_id = 789 # Integer | The identifier of the asset.


begin
  #Asset Group Asset
  result = api_instance.add_asset_to_asset_group(id, asset_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->add_asset_to_asset_group: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
opts = { 
  body: SwaggerClient::AssetGroup.new # AssetGroup | The details of the asset group.
}

begin
  #Asset Groups
  result = api_instance.create_asset_group(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->create_asset_group: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.


begin
  #Asset Group
  result = api_instance.delete_asset_group(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->delete_asset_group: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Agents
  result = api_instance.get_agents(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->get_agents: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.


begin
  #Asset Group
  result = api_instance.get_asset_group(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->get_asset_group: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.


begin
  #Asset Group Assets
  result = api_instance.get_asset_group_assets(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->get_asset_group_assets: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.


begin
  #Asset Group Search Criteria
  result = api_instance.get_asset_group_search_criteria(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->get_asset_group_search_criteria: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.


begin
  #Asset Group Tags
  result = api_instance.get_asset_group_tags(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->get_asset_group_tags: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.


begin
  #Asset Group Users
  result = api_instance.get_asset_group_users(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->get_asset_group_users: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
opts = { 
  type: 'type_example', # String | The type of asset group.
  name: 'name_example', # String | A search pattern for the name of the asset group. Searches are case-insensitive contains.
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Asset Groups
  result = api_instance.get_asset_groups(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->get_asset_groups: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.


begin
  #Asset Group Tags
  result = api_instance.remove_all_asset_group_tags(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->remove_all_asset_group_tags: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.


begin
  #Asset Group Assets
  result = api_instance.remove_all_assets_from_asset_group(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->remove_all_assets_from_asset_group: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
asset_id = 789 # Integer | The identifier of the asset.


begin
  #Asset Group Asset
  result = api_instance.remove_asset_from_asset_group(id, asset_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->remove_asset_from_asset_group: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
tag_id = 56 # Integer | The identifier of the tag.


begin
  #Resources and operations for managing asset groups.
  result = api_instance.remove_asset_group_tag(id, tag_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->remove_asset_group_tag: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
user_id = 56 # Integer | The identifier of the user.


begin
  #Asset Group User
  result = api_instance.remove_asset_group_user(id, user_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->remove_asset_group_user: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
opts = { 
  body: SwaggerClient::SearchCriteria.new # SearchCriteria | The search criteria specification.
}

begin
  #Asset Group Search Criteria
  result = api_instance.set_asset_group_search_criteria(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->set_asset_group_search_criteria: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
opts = { 
  body: [56] # Array<Integer> | The tags to associate to the asset group.
}

begin
  #Asset Group Tags
  result = api_instance.set_asset_group_tags(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->set_asset_group_tags: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
opts = { 
  body: [56] # Array<Integer> | The users to grant access to the asset group.
}

begin
  #Asset Group Users
  result = api_instance.set_asset_group_users(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->set_asset_group_users: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
opts = { 
  body: SwaggerClient::AssetGroup.new # AssetGroup | The details of the asset group.
}

begin
  #Asset Group
  result = api_instance.update_asset_group(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->update_asset_group: #{e}"
end

api_instance = SwaggerClient::AssetGroupApi.new
id = 56 # Integer | The identifier of the asset group.
opts = { 
  body: [56] # Array<Integer> | The assets to place in the asset group. 
}

begin
  #Asset Group Assets
  result = api_instance.update_asset_group_assets(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AssetGroupApi->update_asset_group_assets: #{e}"
end

api_instance = SwaggerClient::CredentialApi.new
opts = { 
  body: SwaggerClient::SharedCredential.new # SharedCredential | The specification of a shared credential.
}

begin
  #Shared Credentials
  result = api_instance.create_shared_credential(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CredentialApi->create_shared_credential: #{e}"
end

api_instance = SwaggerClient::CredentialApi.new

begin
  #Shared Credentials
  result = api_instance.delete_all_shared_credentials
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CredentialApi->delete_all_shared_credentials: #{e}"
end

api_instance = SwaggerClient::CredentialApi.new
id = 56 # Integer | The identifier of the credential.


begin
  #Shared Credential
  result = api_instance.delete_shared_credential(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CredentialApi->delete_shared_credential: #{e}"
end

api_instance = SwaggerClient::CredentialApi.new
id = 56 # Integer | The identifier of the credential.


begin
  #Shared Credential
  result = api_instance.get_shared_credential(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CredentialApi->get_shared_credential: #{e}"
end

api_instance = SwaggerClient::CredentialApi.new

begin
  #Shared Credentials
  result = api_instance.get_shared_credentials
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CredentialApi->get_shared_credentials: #{e}"
end

api_instance = SwaggerClient::CredentialApi.new
id = 56 # Integer | The identifier of the credential.
opts = { 
  body: SwaggerClient::SharedCredential.new # SharedCredential | The specification of the shared credential to update.
}

begin
  #Shared Credential
  result = api_instance.update_shared_credential(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CredentialApi->update_shared_credential: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
asset_id = 789 # Integer | The identifier of the asset.
policy_id = 789 # Integer | The identifier of the policy


begin
  #Policy Rules or Groups Directly Under Policy For Asset
  result = api_instance.get_asset_policy_children(asset_id, policy_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_asset_policy_children: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
asset_id = 789 # Integer | The identifier of the asset.
policy_id = 789 # Integer | The identifier of the policy
group_id = 789 # Integer | The identifier of the policy group.


begin
  #Policy Rules or Groups Directly Under Policy Group For Asset
  result = api_instance.get_asset_policy_group_children(asset_id, policy_id, group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_asset_policy_group_children: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
asset_id = 789 # Integer | The identifier of the asset.
policy_id = 789 # Integer | The identifier of the policy
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Policy Rules For Asset
  result = api_instance.get_asset_policy_rules_summary(asset_id, policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_asset_policy_rules_summary: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
group_id = 789 # Integer | The identifier of the policy group.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Policy Rules Under Policy Group
  result = api_instance.get_descendant_policy_rules(policy_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_descendant_policy_rules: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Disabled Policy Rules
  result = api_instance.get_disabled_policy_rules(policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_disabled_policy_rules: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
opts = { 
  filter: 'filter_example', # String | Filters the retrieved policies with those whose titles that match the parameter.
  scanned_only: true, # BOOLEAN | Flag indicating the policies retrieved should only include those with Pass or Fail compliance results. The list of scanned policies is based on the user's list of accessible assets.
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Policies
  result = api_instance.get_policies(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policies: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
asset_id = 789 # Integer | The identifier of the asset.
opts = { 
  applicable_only: true, # BOOLEAN | An optional boolean parameter indicating the policies retrieved should only include those with a policy compliance status of either a PASS of FAIL result. Default value is `false`, which will also include policies with a compliance status of NOT_APPLICABLE.
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Policies For Asset
  result = api_instance.get_policies_for_asset(asset_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policies_for_asset: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy


begin
  #Policy
  result = api_instance.get_policy(policy_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
asset_id = 789 # Integer | The identifier of the asset.


begin
  #Policy Asset Result
  result = api_instance.get_policy_asset_result(policy_id, asset_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_asset_result: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
opts = { 
  applicable_only: true, # BOOLEAN | An optional boolean parameter indicating the assets retrieved should only include those with rule results of either PASS or FAIL. Default value is `false`, which will also include assets with a compliance status of NOT_APPLICABLE.
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Policy Asset Results
  result = api_instance.get_policy_asset_results(policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_asset_results: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
id = 789 # Integer | The identifier of the policy


begin
  #Policy Rules or Groups Directly Under Policy
  result = api_instance.get_policy_children(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_children: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
group_id = 789 # Integer | The identifier of the policy group.


begin
  #Policy Group
  result = api_instance.get_policy_group(policy_id, group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_group: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
group_id = 789 # Integer | The identifier of the policy group.
asset_id = 789 # Integer | The identifier of the asset.


begin
  #Asset Compliance For Policy Rules Under Policy Group
  result = api_instance.get_policy_group_asset_result(policy_id, group_id, asset_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_group_asset_result: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
group_id = 789 # Integer | The identifier of the policy group.
opts = { 
  applicable_only: true, # BOOLEAN | An optional boolean parameter indicating the assets retrieved should only include those with rule results of either PASS or FAIL. Default value is `false`, which will also include assets with a compliance status of NOT_APPLICABLE.
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Assets Compliance For Policy Rules Under Policy Group
  result = api_instance.get_policy_group_asset_results(policy_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_group_asset_results: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
group_id = 789 # Integer | The identifier of the policy group.


begin
  #Policy Rules or Groups Directly Under Policy Group
  result = api_instance.get_policy_group_children(policy_id, group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_group_children: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
asset_id = 789 # Integer | The identifier of the asset.
policy_id = 789 # Integer | The identifier of the policy
group_id = 789 # Integer | The identifier of the policy group.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Policy Rules Under Policy Group For Asset
  result = api_instance.get_policy_group_rules_with_asset_assessment(asset_id, policy_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_group_rules_with_asset_assessment: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Policy Groups
  result = api_instance.get_policy_groups(policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_groups: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
rule_id = 789 # Integer | The identifier of the policy rule.


begin
  #Policy Rule
  result = api_instance.get_policy_rule(policy_id, rule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_rule: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
rule_id = 789 # Integer | The identifier of the policy rule.
asset_id = 789 # Integer | The identifier of the asset.


begin
  #Asset Compliance For Policy Rule
  result = api_instance.get_policy_rule_asset_result(policy_id, rule_id, asset_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_rule_asset_result: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
rule_id = 789 # Integer | The identifier of the policy rule.
asset_id = 789 # Integer | The identifier of the asset.


begin
  #Policy Rule Proof For Asset
  result = api_instance.get_policy_rule_asset_result_proof(policy_id, rule_id, asset_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_rule_asset_result_proof: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
rule_id = 789 # Integer | The identifier of the policy rule.
opts = { 
  applicable_only: true, # BOOLEAN | An optional boolean parameter indicating the assets retrieved should only include those with rule results of either PASS or FAIL. Default value is `false`, which will also include assets with a compliance status of NOT_APPLICABLE.
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Assets Compliance For Policy Rule
  result = api_instance.get_policy_rule_asset_results(policy_id, rule_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_rule_asset_results: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
rule_id = 789 # Integer | The identifier of the policy rule.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Policy Rule Controls
  result = api_instance.get_policy_rule_controls(policy_id, rule_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_rule_controls: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
rule_id = 789 # Integer | The identifier of the policy rule.


begin
  #Policy Rule Rationale
  result = api_instance.get_policy_rule_rationale(policy_id, rule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_rule_rationale: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
rule_id = 789 # Integer | The identifier of the policy rule.


begin
  #Policy Rule Remediation
  result = api_instance.get_policy_rule_remediation(policy_id, rule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_rule_remediation: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new
policy_id = 789 # Integer | The identifier of the policy
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Policy Rules
  result = api_instance.get_policy_rules(policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_rules: #{e}"
end

api_instance = SwaggerClient::PolicyApi.new

begin
  #Policy Compliance Summaries
  result = api_instance.get_policy_summary
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->get_policy_summary: #{e}"
end

api_instance = SwaggerClient::PolicyOverrideApi.new
opts = { 
  body: SwaggerClient::PolicyOverride.new # PolicyOverride | The specification of a policy override. Allows users to override the compliance result of a policy rule.
}

begin
  #Policy Overrides
  result = api_instance.create_policy_override(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOverrideApi->create_policy_override: #{e}"
end

api_instance = SwaggerClient::PolicyOverrideApi.new
id = 789 # Integer | The identifier of the policy override.


begin
  #Policy Override
  result = api_instance.delete_policy_override(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOverrideApi->delete_policy_override: #{e}"
end

api_instance = SwaggerClient::PolicyOverrideApi.new
id = 789 # Integer | The identifier of the asset.


begin
  #Asset Policy Overrides
  result = api_instance.get_asset_policy_overrides(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOverrideApi->get_asset_policy_overrides: #{e}"
end

api_instance = SwaggerClient::PolicyOverrideApi.new
id = 789 # Integer | The identifier of the policy override.


begin
  #Policy Override
  result = api_instance.get_policy_override(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOverrideApi->get_policy_override: #{e}"
end

api_instance = SwaggerClient::PolicyOverrideApi.new
id = 789 # Integer | The identifier of the policy override.


begin
  #Policy Override Expiration
  result = api_instance.get_policy_override_expiration(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOverrideApi->get_policy_override_expiration: #{e}"
end

api_instance = SwaggerClient::PolicyOverrideApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Policy Overrides
  result = api_instance.get_policy_overrides(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOverrideApi->get_policy_overrides: #{e}"
end

api_instance = SwaggerClient::PolicyOverrideApi.new
id = 789 # Integer | The identifier of the policy override.
opts = { 
  body: 'body_example' # String | The date the policy override is set to expire. Date is represented in ISO 8601 format.
}

begin
  #Policy Override Expiration
  result = api_instance.set_policy_override_expiration(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOverrideApi->set_policy_override_expiration: #{e}"
end

api_instance = SwaggerClient::PolicyOverrideApi.new
id = 789 # Integer | The identifier of the policy override.
status = 'status_example' # String | Policy Override Status
opts = { 
  body: 'body_example' # String | A comment describing the change of the policy override status.
}

begin
  #Policy Override Status
  api_instance.set_policy_override_status(id, status, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOverrideApi->set_policy_override_status: #{e}"
end

api_instance = SwaggerClient::RemediationApi.new
id = 789 # Integer | The identifier of the asset.
vulnerability_id = 'vulnerability_id_example' # String | The identifier of the vulnerability.


begin
  #Asset Vulnerability Solution
  result = api_instance.get_asset_vulnerability_solutions(id, vulnerability_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling RemediationApi->get_asset_vulnerability_solutions: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
opts = { 
  body: SwaggerClient::Report.new # Report | The specification of a report configuration.
}

begin
  #Reports
  result = api_instance.create_report(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->create_report: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
id = 56 # Integer | The identifier of the report.


begin
  #Report
  result = api_instance.delete_report(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->delete_report: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
id = 56 # Integer | The identifier of the report.
instance = 'instance_example' # String | The identifier of the report instance.


begin
  #Report History
  result = api_instance.delete_report_instance(id, instance)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->delete_report_instance: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
id = 56 # Integer | The identifier of the report.
instance = 'instance_example' # String | The identifier of the report instance.


begin
  #Report Download
  result = api_instance.download_report(id, instance)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->download_report: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
id = 56 # Integer | The identifier of the report.


begin
  #Report Generation
  result = api_instance.generate_report(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->generate_report: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
id = 56 # Integer | The identifier of the report.


begin
  #Report
  result = api_instance.get_report(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->get_report: #{e}"
end

api_instance = SwaggerClient::ReportApi.new

begin
  #Report Formats
  result = api_instance.get_report_formats
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->get_report_formats: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
id = 56 # Integer | The identifier of the report.
instance = 'instance_example' # String | The identifier of the report instance.


begin
  #Report History
  result = api_instance.get_report_instance(id, instance)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->get_report_instance: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
id = 56 # Integer | The identifier of the report.


begin
  #Report Histories
  result = api_instance.get_report_instances(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->get_report_instances: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
id = 'id_example' # String | The identifier of the report template;


begin
  #Report Template
  result = api_instance.get_report_template(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->get_report_template: #{e}"
end

api_instance = SwaggerClient::ReportApi.new

begin
  #Report Templates
  result = api_instance.get_report_templates
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->get_report_templates: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Reports
  result = api_instance.get_reports(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->get_reports: #{e}"
end

api_instance = SwaggerClient::ReportApi.new
id = 56 # Integer | The identifier of the report.
opts = { 
  body: SwaggerClient::Report.new # Report | The specification of a report configuration.
}

begin
  #Report
  result = api_instance.update_report(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ReportApi->update_report: #{e}"
end

api_instance = SwaggerClient::RootApi.new

begin
  #Resources
  result = api_instance.resources
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling RootApi->resources: #{e}"
end

api_instance = SwaggerClient::ScanApi.new
id = 789 # Integer | The identifier of the scan.


begin
  #Scan
  result = api_instance.get_scan(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanApi->get_scan: #{e}"
end

api_instance = SwaggerClient::ScanApi.new
opts = { 
  active: false, # BOOLEAN | Return running scans or past scans (true/false value).
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Scans
  result = api_instance.get_scans(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanApi->get_scans: #{e}"
end

api_instance = SwaggerClient::ScanApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  active: false, # BOOLEAN | Return running scans or past scans (true/false value).
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Site Scans
  result = api_instance.get_site_scans(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanApi->get_site_scans: #{e}"
end

api_instance = SwaggerClient::ScanApi.new
id = 789 # Integer | The identifier of the scan.
status = 'status_example' # String | The status of the scan.


begin
  #Scan Status
  result = api_instance.set_scan_status(id, status)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanApi->set_scan_status: #{e}"
end

api_instance = SwaggerClient::ScanApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: SwaggerClient::AdhocScan.new, # AdhocScan | The details for the scan.
  override_blackout: false # BOOLEAN | Whether to request for the override of an scan blackout window.
}

begin
  #Site Scans
  result = api_instance.start_scan(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanApi->start_scan: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the engine pool.
engine_id = 56 # Integer | The identifier of the scan engine.


begin
  #Engine Pool Engines
  result = api_instance.add_scan_engine_pool_scan_engine(id, engine_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->add_scan_engine_pool_scan_engine: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
opts = { 
  body: SwaggerClient::ScanEngine.new # ScanEngine | The specification of a scan engine.
}

begin
  #Scan Engines
  result = api_instance.create_scan_engine(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->create_scan_engine: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
opts = { 
  body: SwaggerClient::EnginePool.new # EnginePool | The details for the scan engine to update.
}

begin
  #Engine Pools
  result = api_instance.create_scan_engine_pool(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->create_scan_engine_pool: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new

begin
  #Scan Engine Shared Secret
  result = api_instance.create_shared_secret
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->create_shared_secret: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the scan engine.


begin
  #Scan Engine
  result = api_instance.delete_scan_engine(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->delete_scan_engine: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new

begin
  #Scan Engine Shared Secret
  result = api_instance.delete_shared_secret
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->delete_shared_secret: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the scan engine.


begin
  #Assigned Engine Pools
  result = api_instance.get_assigned_engine_pools(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_assigned_engine_pools: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new

begin
  #Scan Engine Shared Secret
  result = api_instance.get_current_shared_secret
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_current_shared_secret: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new

begin
  #Scan Engine Shared Secret Time to live
  result = api_instance.get_current_shared_secret_time_to_live
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_current_shared_secret_time_to_live: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the engine pool.


begin
  #Engine Pool
  result = api_instance.get_engine_pool(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_engine_pool: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the scan engine.


begin
  #Scan Engine
  result = api_instance.get_scan_engine(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_scan_engine: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the engine pool.


begin
  #Engine Pool Engines
  result = api_instance.get_scan_engine_pool_scan_engines(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_scan_engine_pool_scan_engines: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the engine pool.


begin
  #Engine Pool Sites
  result = api_instance.get_scan_engine_pool_sites(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_scan_engine_pool_sites: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new

begin
  #Engine Pools
  result = api_instance.get_scan_engine_pools
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_scan_engine_pools: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the scan engine.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Scan Engine Scans
  result = api_instance.get_scan_engine_scans(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_scan_engine_scans: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the scan engine.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Scan Engine Sites
  result = api_instance.get_scan_engine_sites(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_scan_engine_sites: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new

begin
  #Scan Engines
  result = api_instance.get_scan_engines
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->get_scan_engines: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the engine pool.


begin
  #Engine Pool
  result = api_instance.remove_scan_engine_pool(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->remove_scan_engine_pool: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the engine pool.
engine_id = 56 # Integer | The identifier of the scan engine.


begin
  #Engine Pool Engines
  result = api_instance.remove_scan_engine_pool_scan_engine(id, engine_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->remove_scan_engine_pool_scan_engine: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the engine pool.
opts = { 
  body: [56] # Array<Integer> | The identifiers of the scan engines to place into the engine pool.
}

begin
  #Engine Pool Engines
  result = api_instance.set_scan_engine_pool_scan_engines(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->set_scan_engine_pool_scan_engines: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the scan engine.
opts = { 
  body: SwaggerClient::ScanEngine.new # ScanEngine | The specification of the scan engine to update.
}

begin
  #Scan Engine
  result = api_instance.update_scan_engine(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->update_scan_engine: #{e}"
end

api_instance = SwaggerClient::ScanEngineApi.new
id = 56 # Integer | The identifier of the engine pool.
opts = { 
  body: SwaggerClient::EnginePool.new # EnginePool | The details for the scan engine to update.
}

begin
  #Engine Pool
  result = api_instance.update_scan_engine_pool(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanEngineApi->update_scan_engine_pool: #{e}"
end

api_instance = SwaggerClient::ScanTemplateApi.new
opts = { 
  body: SwaggerClient::ScanTemplate.new # ScanTemplate | The details of the scan template.
}

begin
  #Scan Templates
  result = api_instance.create_scan_template(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanTemplateApi->create_scan_template: #{e}"
end

api_instance = SwaggerClient::ScanTemplateApi.new
id = 'id_example' # String | The identifier of the scan template


begin
  #Scan Template
  result = api_instance.delete_scan_template(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanTemplateApi->delete_scan_template: #{e}"
end

api_instance = SwaggerClient::ScanTemplateApi.new
id = 'id_example' # String | The identifier of the scan template


begin
  #Scan Template
  result = api_instance.get_scan_template(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanTemplateApi->get_scan_template: #{e}"
end

api_instance = SwaggerClient::ScanTemplateApi.new

begin
  #Scan Templates
  result = api_instance.get_scan_templates
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanTemplateApi->get_scan_templates: #{e}"
end

api_instance = SwaggerClient::ScanTemplateApi.new
id = 'id_example' # String | The identifier of the scan template
opts = { 
  body: SwaggerClient::ScanTemplate.new # ScanTemplate | The details of the scan template.
}

begin
  #Scan Template
  result = api_instance.update_scan_template(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ScanTemplateApi->update_scan_template: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: ['body_example'] # Array<String> | List of addresses to add to the site's excluded scan targets. Each address is a string that can represent either a hostname, ipv4 address, ipv4 address range, ipv6 address, or CIDR notation.
}

begin
  #Site Excluded Targets
  result = api_instance.add_excluded_targets(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->add_excluded_targets: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: ['body_example'] # Array<String> | List of addresses to add to the site's included scan targets. Each address is a string that can represent either a hostname, ipv4 address, ipv4 address range, ipv6 address, or CIDR notation.
}

begin
  #Site Included Targets
  result = api_instance.add_included_targets(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->add_included_targets: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
tag_id = 56 # Integer | The identifier of the tag.


begin
  #Site Tag
  result = api_instance.add_site_tag(id, tag_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->add_site_tag: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: 56 # Integer | The identifier of the user.
}

begin
  #Site Users Access
  result = api_instance.add_site_user(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->add_site_user: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
opts = { 
  body: SwaggerClient::SiteCreateResource.new # SiteCreateResource | Resource for creating a site configuration.
}

begin
  #Sites
  result = api_instance.create_site(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->create_site: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: SwaggerClient::SiteCredential.new # SiteCredential | The specification of a site credential.
}

begin
  #Site Scan Credentials
  result = api_instance.create_site_credential(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->create_site_credential: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: SwaggerClient::ScanSchedule.new # ScanSchedule | Resource for a scan schedule.
}

begin
  #Site Scan Schedules
  result = api_instance.create_site_scan_schedule(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->create_site_scan_schedule: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: SwaggerClient::SmtpAlert.new # SmtpAlert | Resource for creating a new SMTP alert.
}

begin
  #Site SMTP Alerts
  result = api_instance.create_site_smtp_alert(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->create_site_smtp_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: SwaggerClient::SnmpAlert.new # SnmpAlert | Resource for creating a new SNMP alert.
}

begin
  #Site SNMP Alerts
  result = api_instance.create_site_snmp_alert(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->create_site_snmp_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: SwaggerClient::SyslogAlert.new # SyslogAlert | Resource for creating a new Syslog alert.
}

begin
  #Site Syslog Alerts
  result = api_instance.create_site_syslog_alert(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->create_site_syslog_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Alerts
  result = api_instance.delete_all_site_alerts(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_all_site_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Scan Credentials
  result = api_instance.delete_all_site_credentials(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_all_site_credentials: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Scan Schedules
  result = api_instance.delete_all_site_scan_schedules(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_all_site_scan_schedules: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site SMTP Alerts
  result = api_instance.delete_all_site_smtp_alerts(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_all_site_smtp_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site SNMP Alerts
  result = api_instance.delete_all_site_snmp_alerts(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_all_site_snmp_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Syslog Alerts
  result = api_instance.delete_all_site_syslog_alerts(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_all_site_syslog_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site
  result = api_instance.delete_site(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_site: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
credential_id = 56 # Integer | The identifier of the site credential.


begin
  #Site Scan Credential
  result = api_instance.delete_site_credential(id, credential_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_site_credential: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
schedule_id = 56 # Integer | The identifier of the scan schedule.


begin
  #Site Scan Schedule
  result = api_instance.delete_site_scan_schedule(id, schedule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_site_scan_schedule: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
alert_id = 56 # Integer | The identifier of the alert.


begin
  #Site SMTP Alert
  result = api_instance.delete_site_smtp_alert(id, alert_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_site_smtp_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
alert_id = 56 # Integer | The identifier of the alert.


begin
  #Site SNMP Alert
  result = api_instance.delete_site_snmp_alert(id, alert_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_site_snmp_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
alert_id = 56 # Integer | The identifier of the alert.


begin
  #Site Syslog Alert
  result = api_instance.delete_site_syslog_alert(id, alert_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->delete_site_syslog_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
credential_id = 56 # Integer | The identifier of the shared credential.
opts = { 
  body: true # BOOLEAN | Flag indicating whether the shared credential is enabled for the site's scans.
}

begin
  #Assigned Shared Credential Enablement
  result = api_instance.enable_shared_credential_on_site(id, credential_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->enable_shared_credential_on_site: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
credential_id = 56 # Integer | The identifier of the site credential.
opts = { 
  body: true # BOOLEAN | Flag indicating whether the credential is enabled for use during the scan.
}

begin
  #Site Credential Enablement
  result = api_instance.enable_site_credential(id, credential_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->enable_site_credential: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Excluded Asset Groups
  result = api_instance.get_excluded_asset_groups(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_excluded_asset_groups: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Excluded Targets
  result = api_instance.get_excluded_targets(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_excluded_targets: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Included Asset Groups
  result = api_instance.get_included_asset_groups(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_included_asset_groups: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Included Targets
  result = api_instance.get_included_targets(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_included_targets: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site
  result = api_instance.get_site(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Alerts
  result = api_instance.get_site_alerts(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Site Assets
  result = api_instance.get_site_assets(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_assets: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
credential_id = 56 # Integer | The identifier of the site credential.


begin
  #Site Scan Credential
  result = api_instance.get_site_credential(id, credential_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_credential: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Scan Credentials
  result = api_instance.get_site_credentials(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_credentials: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Discovery Connection
  result = api_instance.get_site_discovery_connection(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_discovery_connection: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Discovery Search Criteria
  result = api_instance.get_site_discovery_search_criteria(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_discovery_search_criteria: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Organization Information
  result = api_instance.get_site_organization(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_organization: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Scan Engine
  result = api_instance.get_site_scan_engine(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_scan_engine: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
schedule_id = 56 # Integer | The identifier of the scan schedule.


begin
  #Site Scan Schedule
  result = api_instance.get_site_scan_schedule(id, schedule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_scan_schedule: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Scan Schedules
  result = api_instance.get_site_scan_schedules(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_scan_schedules: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Scan Template
  result = api_instance.get_site_scan_template(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_scan_template: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Assigned Shared Credentials
  result = api_instance.get_site_shared_credentials(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_shared_credentials: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
alert_id = 56 # Integer | The identifier of the alert.


begin
  #Site SMTP Alert
  result = api_instance.get_site_smtp_alert(id, alert_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_smtp_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site SMTP Alerts
  result = api_instance.get_site_smtp_alerts(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_smtp_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
alert_id = 56 # Integer | The identifier of the alert.


begin
  #Site SNMP Alert
  result = api_instance.get_site_snmp_alert(id, alert_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_snmp_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site SNMP Alerts
  result = api_instance.get_site_snmp_alerts(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_snmp_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
alert_id = 56 # Integer | The identifier of the alert.


begin
  #Site Syslog Alert
  result = api_instance.get_site_syslog_alert(id, alert_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_syslog_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Syslog Alerts
  result = api_instance.get_site_syslog_alerts(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_syslog_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Tags
  result = api_instance.get_site_tags(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_tags: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Users Access
  result = api_instance.get_site_users(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_site_users: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Sites
  result = api_instance.get_sites(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_sites: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Web Authentication HTML Forms
  result = api_instance.get_web_auth_html_forms(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_web_auth_html_forms: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Web Authentication HTTP Headers
  result = api_instance.get_web_auth_http_headers(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->get_web_auth_http_headers: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Excluded Asset Groups
  result = api_instance.remove_all_excluded_asset_groups(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->remove_all_excluded_asset_groups: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Included Asset Groups
  result = api_instance.remove_all_included_asset_groups(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->remove_all_included_asset_groups: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
asset_id = 789 # Integer | The identifier of the asset.


begin
  #Site Asset
  result = api_instance.remove_asset_from_site(id, asset_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->remove_asset_from_site: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
asset_group_id = 56 # Integer | The identifier of the asset group.


begin
  #Site Excluded Asset Group
  result = api_instance.remove_excluded_asset_group(id, asset_group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->remove_excluded_asset_group: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: ['body_example'] # Array<String> | List of address to remove from the sites excluded scan targets. Each address is a string that can represent either a hostname, ipv4 address, ipv4 address range, ipv6 address, or CIDR notation.
}

begin
  #Site Excluded Targets
  result = api_instance.remove_excluded_targets(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->remove_excluded_targets: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
asset_group_id = 56 # Integer | The identifier of the asset group.


begin
  #Site Included Asset Group
  result = api_instance.remove_included_asset_group(id, asset_group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->remove_included_asset_group: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: ['body_example'] # Array<String> | List of address to remove from the sites included scan targets. Each address is a string that can represent either a hostname, ipv4 address, ipv4 address range, ipv6 address, or CIDR notation.
}

begin
  #Site Included Targets
  result = api_instance.remove_included_targets(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->remove_included_targets: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.


begin
  #Site Assets
  result = api_instance.remove_site_assets(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->remove_site_assets: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
tag_id = 56 # Integer | The identifier of the tag.


begin
  #Site Tag
  result = api_instance.remove_site_tag(id, tag_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->remove_site_tag: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
user_id = 56 # Integer | The identifier of the user.


begin
  #Site User Access
  result = api_instance.remove_site_user(id, user_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->remove_site_user: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: [SwaggerClient::SiteCredential.new] # Array<SiteCredential> | A list of site credentials resources.
}

begin
  #Site Scan Credentials
  result = api_instance.set_site_credentials(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_credentials: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: 56 # Integer | The identifier of the discovery connection.
}

begin
  #Site Discovery Connection
  result = api_instance.set_site_discovery_connection(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_discovery_connection: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
body = SwaggerClient::DiscoverySearchCriteria.new # DiscoverySearchCriteria | param1
id = 56 # Integer | The identifier of the site.


begin
  #Site Discovery Search Criteria
  result = api_instance.set_site_discovery_search_criteria(body, id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_discovery_search_criteria: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: 56 # Integer | The identifier of the scan engine.
}

begin
  #Site Scan Engine
  result = api_instance.set_site_scan_engine(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_scan_engine: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: [SwaggerClient::ScanSchedule.new] # Array<ScanSchedule> | Array of resources for updating all scan schedules defined in the site. Scan schedules defined in the site that are omitted from this request will be deleted from the site.
}

begin
  #Site Scan Schedules
  result = api_instance.set_site_scan_schedules(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_scan_schedules: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: 'body_example' # String | The identifier of the scan template.
}

begin
  #Site Scan Template
  result = api_instance.set_site_scan_template(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_scan_template: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: [SwaggerClient::SmtpAlert.new] # Array<SmtpAlert> | Array of resources for updating all SMTP alerts defined in the site. Alerts defined in the site that are omitted from this request will be deleted from the site.
}

begin
  #Site SMTP Alerts
  result = api_instance.set_site_smtp_alerts(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_smtp_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: [SwaggerClient::SnmpAlert.new] # Array<SnmpAlert> | Array of resources for updating all SNMP alerts defined in the site. Alerts defined in the site that are omitted from this request will be deleted from the site.
}

begin
  #Site SNMP Alerts
  result = api_instance.set_site_snmp_alerts(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_snmp_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: [SwaggerClient::SyslogAlert.new] # Array<SyslogAlert> | Array of resources for updating all Syslog alerts defined in the site. Alerts defined in the site that are omitted from this request will be deleted from the site.
}

begin
  #Site Syslog Alerts
  result = api_instance.set_site_syslog_alerts(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_syslog_alerts: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: [56] # Array<Integer> | A list of tag identifiers to replace the site's tags.
}

begin
  #Site Tags
  result = api_instance.set_site_tags(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_tags: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: [56] # Array<Integer> | A list of user identifiers to replace the site's access list.
}

begin
  #Site Users Access
  result = api_instance.set_site_users(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->set_site_users: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: [56] # Array<Integer> | Array of asset group identifiers.
}

begin
  #Site Excluded Asset Groups
  result = api_instance.update_excluded_asset_groups(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_excluded_asset_groups: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: ['body_example'] # Array<String> | List of addresses to be the site's new excluded scan targets. Each address is a string that can represent either a hostname, ipv4 address, ipv4 address range, ipv6 address, or CIDR notation.
}

begin
  #Site Excluded Targets
  result = api_instance.update_excluded_targets(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_excluded_targets: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: [56] # Array<Integer> | Array of asset group identifiers.
}

begin
  #Site Included Asset Groups
  result = api_instance.update_included_asset_groups(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_included_asset_groups: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: ['body_example'] # Array<String> | List of addresses to be the site's new included scan targets. Each address is a string that can represent either a hostname, ipv4 address, ipv4 address range, ipv6 address, or CIDR notation.
}

begin
  #Site Included Targets
  result = api_instance.update_included_targets(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_included_targets: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: SwaggerClient::SiteUpdateResource.new # SiteUpdateResource | Resource for updating a site configuration.
}

begin
  #Site
  result = api_instance.update_site(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_site: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
credential_id = 56 # Integer | The identifier of the site credential.
opts = { 
  body: SwaggerClient::SiteCredential.new # SiteCredential | The specification of the site credential to update.
}

begin
  #Site Scan Credential
  result = api_instance.update_site_credential(id, credential_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_site_credential: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
opts = { 
  body: SwaggerClient::SiteOrganization.new # SiteOrganization | Resource for updating the specified site's organization information.
}

begin
  #Site Organization Information
  result = api_instance.update_site_organization(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_site_organization: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
schedule_id = 56 # Integer | The identifier of the scan schedule.
opts = { 
  body: SwaggerClient::ScanSchedule.new # ScanSchedule | Resource for updating the specified scan schedule.
}

begin
  #Site Scan Schedule
  result = api_instance.update_site_scan_schedule(id, schedule_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_site_scan_schedule: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
alert_id = 56 # Integer | The identifier of the alert.
opts = { 
  body: SwaggerClient::SmtpAlert.new # SmtpAlert | Resource for updating the specified SMTP alert.
}

begin
  #Site SMTP Alert
  result = api_instance.update_site_smtp_alert(id, alert_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_site_smtp_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
alert_id = 56 # Integer | The identifier of the alert.
opts = { 
  body: SwaggerClient::SnmpAlert.new # SnmpAlert | Resource for updating the specified SNMP alert.
}

begin
  #Site SNMP Alert
  result = api_instance.update_site_snmp_alert(id, alert_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_site_snmp_alert: #{e}"
end

api_instance = SwaggerClient::SiteApi.new
id = 56 # Integer | The identifier of the site.
alert_id = 56 # Integer | The identifier of the alert.
opts = { 
  body: SwaggerClient::SyslogAlert.new # SyslogAlert | Resource for updating the specified Syslog alert.
}

begin
  #Site Syslog Alert
  result = api_instance.update_site_syslog_alert(id, alert_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SiteApi->update_site_syslog_alert: #{e}"
end

api_instance = SwaggerClient::TagApi.new
opts = { 
  body: SwaggerClient::Tag.new # Tag | The details of the tag.
}

begin
  #Tags
  result = api_instance.create_tag(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->create_tag: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.


begin
  #Tag
  result = api_instance.delete_tag(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->delete_tag: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.


begin
  #Tag
  result = api_instance.get_tag(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->get_tag: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.


begin
  #Tag Asset Groups
  result = api_instance.get_tag_asset_groups(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->get_tag_asset_groups: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.


begin
  #Tag Search Criteria
  result = api_instance.get_tag_search_criteria(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->get_tag_search_criteria: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.


begin
  #Tag Assets
  result = api_instance.get_tagged_assets(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->get_tagged_assets: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.


begin
  #Tag Sites
  result = api_instance.get_tagged_sites(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->get_tagged_sites: #{e}"
end

api_instance = SwaggerClient::TagApi.new
opts = { 
  name: 'name_example', # String | name
  type: 'type_example', # String | type
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Tags
  result = api_instance.get_tags(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->get_tags: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.


begin
  #Tag Search Criteria
  result = api_instance.remove_tag_search_criteria(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->remove_tag_search_criteria: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.


begin
  #Tag Sites
  result = api_instance.remove_tagged_sites(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->remove_tagged_sites: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.
opts = { 
  body: [56] # Array<Integer> | The asset groups to add to the tag.
}

begin
  #Tag Asset Groups
  result = api_instance.set_tagged_asset_groups(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->set_tagged_asset_groups: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.
opts = { 
  body: [56] # Array<Integer> | The sites to add to the tag.
}

begin
  #Tag Sites
  result = api_instance.set_tagged_sites(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->set_tagged_sites: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.
asset_id = 789 # Integer | The identifier of the asset.


begin
  #Tag Asset
  result = api_instance.tag_asset(id, asset_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->tag_asset: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.
asset_group_id = 56 # Integer | The asset group identifier.


begin
  #Tag Asset Group
  result = api_instance.tag_asset_group(id, asset_group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->tag_asset_group: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.
site_id = 56 # Integer | The identifier of the site.


begin
  #Tag Site
  result = api_instance.tag_site(id, site_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->tag_site: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.


begin
  #Tag Asset Groups
  result = api_instance.untag_all_asset_groups(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->untag_all_asset_groups: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.
asset_id = 789 # Integer | The identifier of the asset.


begin
  #Tag Asset
  result = api_instance.untag_asset(id, asset_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->untag_asset: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.
asset_group_id = 56 # Integer | The asset group identifier.


begin
  #Tag Asset Group
  result = api_instance.untag_asset_group(id, asset_group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->untag_asset_group: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.
site_id = 56 # Integer | The identifier of the site.


begin
  #Tag Site
  result = api_instance.untag_site(id, site_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->untag_site: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.
opts = { 
  body: SwaggerClient::Tag.new # Tag | The details of the tag.
}

begin
  #Tag
  result = api_instance.update_tag(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->update_tag: #{e}"
end

api_instance = SwaggerClient::TagApi.new
id = 56 # Integer | The identifier of the tag.
opts = { 
  body: SwaggerClient::SearchCriteria.new # SearchCriteria | The details of the search criteria.
}

begin
  #Tag Search Criteria
  result = api_instance.update_tag_search_criteria(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TagApi->update_tag_search_criteria: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.
asset_group_id = 56 # Integer | The identifier of the asset group.


begin
  #Asset Group Access
  result = api_instance.add_user_asset_group(id, asset_group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->add_user_asset_group: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.
site_id = 56 # Integer | The identifier of the site.


begin
  #Site Access
  result = api_instance.add_user_site(id, site_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->add_user_site: #{e}"
end

api_instance = SwaggerClient::UserApi.new
opts = { 
  body: SwaggerClient::UserEdit.new # UserEdit | The details of the user.
}

begin
  #Users
  result = api_instance.create_user(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->create_user: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 'id_example' # String | The identifier of the role.


begin
  #Role
  result = api_instance.delete_role(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->delete_role: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.


begin
  #User
  result = api_instance.delete_user(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->delete_user: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the authentication source.


begin
  #Authentication Source
  result = api_instance.get_authentication_source(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_authentication_source: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the authentication source.


begin
  #Authentication Source Users
  result = api_instance.get_authentication_source_users(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_authentication_source_users: #{e}"
end

api_instance = SwaggerClient::UserApi.new

begin
  #Authentication Sources
  result = api_instance.get_authentication_sources
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_authentication_sources: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 'id_example' # String | The identifier of the privilege.


begin
  #Privilege
  result = api_instance.get_privilege(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_privilege: #{e}"
end

api_instance = SwaggerClient::UserApi.new

begin
  #Privileges
  result = api_instance.get_privileges
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_privileges: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 'id_example' # String | The identifier of the role.


begin
  #Role
  result = api_instance.get_role(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_role: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 'id_example' # String | The identifier of the role.


begin
  #Users With Role
  result = api_instance.get_role_users(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_role_users: #{e}"
end

api_instance = SwaggerClient::UserApi.new

begin
  #Roles
  result = api_instance.get_roles
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_roles: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.


begin
  #Two-Factor Authentication
  result = api_instance.get_two_factor_authentication_key(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_two_factor_authentication_key: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.


begin
  #User
  result = api_instance.get_user(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_user: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.


begin
  #Asset Groups Access
  result = api_instance.get_user_asset_groups(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_user_asset_groups: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.


begin
  #User Privileges
  result = api_instance.get_user_privileges(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_user_privileges: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.


begin
  #Sites Access
  result = api_instance.get_user_sites(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_user_sites: #{e}"
end

api_instance = SwaggerClient::UserApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Users
  result = api_instance.get_users(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_users: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 'id_example' # String | The identifier of the privilege.


begin
  #Users With Privilege
  result = api_instance.get_users_with_privilege(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->get_users_with_privilege: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.


begin
  #Two-Factor Authentication
  result = api_instance.regenerate_two_factor_authentication(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->regenerate_two_factor_authentication: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.


begin
  #Asset Groups Access
  result = api_instance.remove_all_user_asset_groups(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->remove_all_user_asset_groups: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.


begin
  #Sites Access
  result = api_instance.remove_all_user_sites(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->remove_all_user_sites: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.
asset_group_id = 56 # Integer | The identifier of the asset group.


begin
  #Asset Group Access
  result = api_instance.remove_user_asset_group(id, asset_group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->remove_user_asset_group: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.
site_id = 56 # Integer | The identifier of the site.


begin
  #Site Access
  result = api_instance.remove_user_site(id, site_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->remove_user_site: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.
opts = { 
  body: SwaggerClient::PasswordResource.new # PasswordResource | The new password to set.
}

begin
  #Password Reset
  result = api_instance.reset_password(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->reset_password: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.
opts = { 
  body: 'body_example' # String | The authentication token seed (key) to use for the user.
}

begin
  #Two-Factor Authentication
  result = api_instance.set_two_factor_authentication(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->set_two_factor_authentication: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.
opts = { 
  body: [56] # Array<Integer> | The identifiers of the asset groups to grant the user access to. Ignored if user has access to `allAssetGroups`.
}

begin
  #Asset Groups Access
  result = api_instance.set_user_asset_groups(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->set_user_asset_groups: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.
opts = { 
  body: [56] # Array<Integer> | The identifiers of the sites to grant the user access to. Ignored if the user has access to `allSites`.
}

begin
  #Sites Access
  result = api_instance.set_user_sites(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->set_user_sites: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.


begin
  #Unlock Account
  result = api_instance.unlock_user(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->unlock_user: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 'id_example' # String | The identifier of the role.
opts = { 
  body: SwaggerClient::Role.new # Role | The details of the role.
}

begin
  #Role
  result = api_instance.update_role(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->update_role: #{e}"
end

api_instance = SwaggerClient::UserApi.new
id = 56 # Integer | The identifier of the user.
opts = { 
  body: SwaggerClient::UserEdit.new # UserEdit | The details of the user.
}

begin
  #User
  result = api_instance.update_user(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UserApi->update_user: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 'id_example' # String | The identifier of the vulnerability.


begin
  #Vulnerability Affected Assets
  result = api_instance.get_affected_assets(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_affected_assets: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 56 # Integer | The identifier of the exploit.


begin
  #Exploit
  result = api_instance.get_exploit(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_exploit: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 56 # Integer | The identifier of the exploit.


begin
  #Exploitable Vulnerabilities
  result = api_instance.get_exploit_vulnerabilities(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_exploit_vulnerabilities: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Exploits
  result = api_instance.get_exploits(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_exploits: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 56 # Integer | The identifier of the malware kit.


begin
  #Malware Kit
  result = api_instance.get_malware_kit(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_malware_kit: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 56 # Integer | The identifier of the malware kit.


begin
  #Malware Kit Vulnerabilities
  result = api_instance.get_malware_kit_vulnerabilities(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_malware_kit_vulnerabilities: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Malware Kits
  result = api_instance.get_malware_kits(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_malware_kits: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 'id_example' # String | The identifier of the solution.


begin
  #Solution Prerequisites
  result = api_instance.get_prerequisite_solutions(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_prerequisite_solutions: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 'id_example' # String | The identifier of the solution.


begin
  #Solution
  result = api_instance.get_solution(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_solution: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Solutions
  result = api_instance.get_solutions(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_solutions: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 'id_example' # String | The identifier of the solution.


begin
  #Superseded Solutions
  result = api_instance.get_superseded_solutions(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_superseded_solutions: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 'id_example' # String | The identifier of the solution.
opts = { 
  rollup: true # BOOLEAN | Whether to return only highest-level \"rollup\" superseding solutions.
}

begin
  #Superseding Solutions
  result = api_instance.get_superseding_solutions(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_superseding_solutions: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Vulnerabilities
  result = api_instance.get_vulnerabilities(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerabilities: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 'id_example' # String | The identifier of the vulnerability.


begin
  #Vulnerability
  result = api_instance.get_vulnerability(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Categories
  result = api_instance.get_vulnerability_categories(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability_categories: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 56 # Integer | The identifier of the vulnerability category.


begin
  #Category
  result = api_instance.get_vulnerability_category(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability_category: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 56 # Integer | The identifier of the vulnerability category.


begin
  #Category Vulnerabilities
  result = api_instance.get_vulnerability_category_vulnerabilities(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability_category_vulnerabilities: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 'id_example' # String | The identifier of the vulnerability.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Vulnerability Exploits
  result = api_instance.get_vulnerability_exploits(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability_exploits: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 'id_example' # String | The identifier of the vulnerability.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Vulnerability Malware Kits
  result = api_instance.get_vulnerability_malware_kits(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability_malware_kits: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 56 # Integer | The identifier of the vulnerability reference.


begin
  #Reference
  result = api_instance.get_vulnerability_reference(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability_reference: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 56 # Integer | id
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Reference Vulnerabilities
  result = api_instance.get_vulnerability_reference_vulnerabilities(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability_reference_vulnerabilities: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #References
  result = api_instance.get_vulnerability_references(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability_references: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 'id_example' # String | The identifier of the vulnerability.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Vulnerability References
  result = api_instance.get_vulnerability_references1(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability_references1: #{e}"
end

api_instance = SwaggerClient::VulnerabilityApi.new
id = 'id_example' # String | The identifier of the vulnerability.


begin
  #Vulnerability Solutions
  result = api_instance.get_vulnerability_solutions(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityApi->get_vulnerability_solutions: #{e}"
end

api_instance = SwaggerClient::VulnerabilityCheckApi.new

begin
  #Check Types
  result = api_instance.get_vulnerability_check_types
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityCheckApi->get_vulnerability_check_types: #{e}"
end

api_instance = SwaggerClient::VulnerabilityCheckApi.new
opts = { 
  search: 'search_example', # String | Vulnerability search term to find vulnerability checks for. e.g. `\"ssh\"`.
  safe: true, # BOOLEAN | Whether to return vulnerability checks that are considered \"safe\" to run. Defaults to return safe and unsafe checks.
  potential: true, # BOOLEAN | Whether to only return checks that result in potentially vulnerable results. Defaults to return all checks.
  requires_credentials: true, # BOOLEAN | Whether to only return checks that require credentials in order to successfully execute. Defaults to return all checks.
  unique: true, # BOOLEAN | Whether to only return checks that guarantee to be executed once-and-only once on a host resulting in a unique result. False returns checks that can result in multiple occurrences of the same vulnerability on a host.
  type: 'type_example', # String | The type of vulnerability checks to return. See <a href=\"#operation/vulnerabilityCheckTypesUsingGET\">Check Types</a> for all available types.
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Checks
  result = api_instance.get_vulnerability_checks(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityCheckApi->get_vulnerability_checks: #{e}"
end

api_instance = SwaggerClient::VulnerabilityCheckApi.new
id = 'id_example' # String | The identifier of the vulnerability.


begin
  #Vulnerability Checks
  result = api_instance.get_vulnerability_checks_for_vulnerability(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityCheckApi->get_vulnerability_checks_for_vulnerability: #{e}"
end

api_instance = SwaggerClient::VulnerabilityCheckApi.new
id = 'id_example' # String | The identifier of the vulnerability check.


begin
  #Check
  result = api_instance.vulnerability_check(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityCheckApi->vulnerability_check: #{e}"
end

api_instance = SwaggerClient::VulnerabilityExceptionApi.new
opts = { 
  body: SwaggerClient::VulnerabilityException.new # VulnerabilityException | The vulnerability exception to create.
}

begin
  #Exceptions
  result = api_instance.create_vulnerability_exception(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityExceptionApi->create_vulnerability_exception: #{e}"
end

api_instance = SwaggerClient::VulnerabilityExceptionApi.new
id = 56 # Integer | The identifier of the vulnerability exception.


begin
  #Exception
  result = api_instance.get_vulnerability_exception(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityExceptionApi->get_vulnerability_exception: #{e}"
end

api_instance = SwaggerClient::VulnerabilityExceptionApi.new
id = 56 # Integer | id


begin
  #Exception Expiration
  result = api_instance.get_vulnerability_exception_expiration(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityExceptionApi->get_vulnerability_exception_expiration: #{e}"
end

api_instance = SwaggerClient::VulnerabilityExceptionApi.new
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Exceptions
  result = api_instance.get_vulnerability_exceptions(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityExceptionApi->get_vulnerability_exceptions: #{e}"
end

api_instance = SwaggerClient::VulnerabilityExceptionApi.new
id = 56 # Integer | id


begin
  #Exception
  result = api_instance.remove_vulnerability_exception(id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityExceptionApi->remove_vulnerability_exception: #{e}"
end

api_instance = SwaggerClient::VulnerabilityExceptionApi.new
body = 'body_example' # String | param1
id = 56 # Integer | id


begin
  #Exception Expiration
  result = api_instance.update_vulnerability_exception_expiration(body, id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityExceptionApi->update_vulnerability_exception_expiration: #{e}"
end

api_instance = SwaggerClient::VulnerabilityExceptionApi.new
id = 56 # Integer | id
status = 'status_example' # String | Exception Status
opts = { 
  body: 'body_example' # String | param2
}

begin
  #Exception Status
  result = api_instance.update_vulnerability_exception_status(id, status, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityExceptionApi->update_vulnerability_exception_status: #{e}"
end

api_instance = SwaggerClient::VulnerabilityResultApi.new
id = 789 # Integer | The identifier of the asset.
vulnerability_id = 'vulnerability_id_example' # String | The identifier of the vulnerability.
opts = { 
  body: SwaggerClient::VulnerabilityValidationResource.new # VulnerabilityValidationResource | A vulnerability validation for a vulnerability on an asset. The  validation signifies that the vulnerability has been confirmed exploitable by an external tool, such as <a target="_blank" rel="noopener noreferrer" href="https://www.metasploit.com">Metasploit</a>.
}

begin
  #Asset Vulnerability Validations
  result = api_instance.create_vulnerability_validation(id, vulnerability_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityResultApi->create_vulnerability_validation: #{e}"
end

api_instance = SwaggerClient::VulnerabilityResultApi.new
id = 789 # Integer | The identifier of the asset.
vulnerability_id = 'vulnerability_id_example' # String | The identifier of the vulnerability.
validation_id = 789 # Integer | The identifier of the vulnerability validation.


begin
  #Asset Vulnerability Validation
  result = api_instance.delete_vulnerability_validation(id, vulnerability_id, validation_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityResultApi->delete_vulnerability_validation: #{e}"
end

api_instance = SwaggerClient::VulnerabilityResultApi.new
id = 789 # Integer | The identifier of the asset.
protocol = 'protocol_example' # String | The protocol of the service.
port = 56 # Integer | The port of the service.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Asset Service Vulnerabilities
  result = api_instance.get_asset_service_vulnerabilities(id, protocol, port, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityResultApi->get_asset_service_vulnerabilities: #{e}"
end

api_instance = SwaggerClient::VulnerabilityResultApi.new
id = 789 # Integer | The identifier of the asset.
opts = { 
  page: 0, # Integer | The index of the page (zero-based) to retrieve.
  size: 10, # Integer | The number of records per page to retrieve.
  sort: ['sort_example'] # Array<String> | The criteria to sort the records by, in the format: `property[,ASC|DESC]`. The default sort order is ascending. Multiple sort criteria can be specified using multiple sort query parameters.
}

begin
  #Asset Vulnerabilities
  result = api_instance.get_asset_vulnerabilities(id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityResultApi->get_asset_vulnerabilities: #{e}"
end

api_instance = SwaggerClient::VulnerabilityResultApi.new
id = 789 # Integer | The identifier of the asset.
vulnerability_id = 'vulnerability_id_example' # String | The identifier of the vulnerability.


begin
  #Asset Vulnerability
  result = api_instance.get_asset_vulnerability(id, vulnerability_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityResultApi->get_asset_vulnerability: #{e}"
end

api_instance = SwaggerClient::VulnerabilityResultApi.new
id = 789 # Integer | The identifier of the asset.
vulnerability_id = 'vulnerability_id_example' # String | The identifier of the vulnerability.
validation_id = 789 # Integer | The identifier of the vulnerability validation.


begin
  #Asset Vulnerability Validation
  result = api_instance.get_vulnerability_validation(id, vulnerability_id, validation_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityResultApi->get_vulnerability_validation: #{e}"
end

api_instance = SwaggerClient::VulnerabilityResultApi.new
id = 789 # Integer | The identifier of the asset.
vulnerability_id = 'vulnerability_id_example' # String | The identifier of the vulnerability.


begin
  #Asset Vulnerability Validations
  result = api_instance.get_vulnerability_validations(id, vulnerability_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling VulnerabilityResultApi->get_vulnerability_validations: #{e}"
end
```

## Documentation for API Endpoints

All URIs are relative to *https://localhost:3780/*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*SwaggerClient::AdministrationApi* | [**activate_license**](docs/AdministrationApi.md#activate_license) | **POST** /api/3/administration/license | License
*SwaggerClient::AdministrationApi* | [**execute_command**](docs/AdministrationApi.md#execute_command) | **POST** /api/3/administration/commands | Console Commands
*SwaggerClient::AdministrationApi* | [**get_info**](docs/AdministrationApi.md#get_info) | **GET** /api/3/administration/info | Information
*SwaggerClient::AdministrationApi* | [**get_license**](docs/AdministrationApi.md#get_license) | **GET** /api/3/administration/license | License
*SwaggerClient::AdministrationApi* | [**get_properties**](docs/AdministrationApi.md#get_properties) | **GET** /api/3/administration/properties | Properties
*SwaggerClient::AdministrationApi* | [**get_settings**](docs/AdministrationApi.md#get_settings) | **GET** /api/3/administration/settings | Settings
*SwaggerClient::AssetApi* | [**add_asset_tag**](docs/AssetApi.md#add_asset_tag) | **PUT** /api/3/assets/{id}/tags/{tagId} | Asset Tag
*SwaggerClient::AssetApi* | [**create_asset**](docs/AssetApi.md#create_asset) | **POST** /api/3/sites/{id}/assets | Assets
*SwaggerClient::AssetApi* | [**delete_asset**](docs/AssetApi.md#delete_asset) | **DELETE** /api/3/assets/{id} | Asset
*SwaggerClient::AssetApi* | [**find_assets**](docs/AssetApi.md#find_assets) | **POST** /api/3/assets/search | Asset Search
*SwaggerClient::AssetApi* | [**get_asset**](docs/AssetApi.md#get_asset) | **GET** /api/3/assets/{id} | Asset
*SwaggerClient::AssetApi* | [**get_asset_databases**](docs/AssetApi.md#get_asset_databases) | **GET** /api/3/assets/{id}/databases | Asset Databases
*SwaggerClient::AssetApi* | [**get_asset_files**](docs/AssetApi.md#get_asset_files) | **GET** /api/3/assets/{id}/files | Asset Files
*SwaggerClient::AssetApi* | [**get_asset_service**](docs/AssetApi.md#get_asset_service) | **GET** /api/3/assets/{id}/services/{protocol}/{port} | Asset Service
*SwaggerClient::AssetApi* | [**get_asset_service_configurations**](docs/AssetApi.md#get_asset_service_configurations) | **GET** /api/3/assets/{id}/services/{protocol}/{port}/configurations | Asset Service Configurations
*SwaggerClient::AssetApi* | [**get_asset_service_databases**](docs/AssetApi.md#get_asset_service_databases) | **GET** /api/3/assets/{id}/services/{protocol}/{port}/databases | Asset Service Databases
*SwaggerClient::AssetApi* | [**get_asset_service_user_groups**](docs/AssetApi.md#get_asset_service_user_groups) | **GET** /api/3/assets/{id}/services/{protocol}/{port}/user_groups | Asset Service User Groups
*SwaggerClient::AssetApi* | [**get_asset_service_users**](docs/AssetApi.md#get_asset_service_users) | **GET** /api/3/assets/{id}/services/{protocol}/{port}/users | Asset Service Users
*SwaggerClient::AssetApi* | [**get_asset_service_web_application**](docs/AssetApi.md#get_asset_service_web_application) | **GET** /api/3/assets/{id}/services/{protocol}/{port}/web_applications/{webApplicationId} | Asset Service Web Application
*SwaggerClient::AssetApi* | [**get_asset_service_web_applications**](docs/AssetApi.md#get_asset_service_web_applications) | **GET** /api/3/assets/{id}/services/{protocol}/{port}/web_applications | Asset Service Web Applications
*SwaggerClient::AssetApi* | [**get_asset_services**](docs/AssetApi.md#get_asset_services) | **GET** /api/3/assets/{id}/services | Asset Services
*SwaggerClient::AssetApi* | [**get_asset_software**](docs/AssetApi.md#get_asset_software) | **GET** /api/3/assets/{id}/software | Asset Software
*SwaggerClient::AssetApi* | [**get_asset_tags**](docs/AssetApi.md#get_asset_tags) | **GET** /api/3/assets/{id}/tags | Asset Tags
*SwaggerClient::AssetApi* | [**get_asset_user_groups**](docs/AssetApi.md#get_asset_user_groups) | **GET** /api/3/assets/{id}/user_groups | Asset User Groups
*SwaggerClient::AssetApi* | [**get_asset_users**](docs/AssetApi.md#get_asset_users) | **GET** /api/3/assets/{id}/users | Asset Users
*SwaggerClient::AssetApi* | [**get_assets**](docs/AssetApi.md#get_assets) | **GET** /api/3/assets | Assets
*SwaggerClient::AssetApi* | [**get_operating_system**](docs/AssetApi.md#get_operating_system) | **GET** /api/3/operating_systems/{id} | Operating System
*SwaggerClient::AssetApi* | [**get_operating_systems**](docs/AssetApi.md#get_operating_systems) | **GET** /api/3/operating_systems | Operating Systems
*SwaggerClient::AssetApi* | [**get_software**](docs/AssetApi.md#get_software) | **GET** /api/3/software/{id} | Software
*SwaggerClient::AssetApi* | [**get_softwares**](docs/AssetApi.md#get_softwares) | **GET** /api/3/software | Software
*SwaggerClient::AssetApi* | [**remove_asset_tag**](docs/AssetApi.md#remove_asset_tag) | **DELETE** /api/3/assets/{id}/tags/{tagId} | Asset Tag
*SwaggerClient::AssetDiscoveryApi* | [**create_sonar_query**](docs/AssetDiscoveryApi.md#create_sonar_query) | **POST** /api/3/sonar_queries | Sonar Queries
*SwaggerClient::AssetDiscoveryApi* | [**delete_sonar_query**](docs/AssetDiscoveryApi.md#delete_sonar_query) | **DELETE** /api/3/sonar_queries/{id} | Sonar Query
*SwaggerClient::AssetDiscoveryApi* | [**get_discovery_connection**](docs/AssetDiscoveryApi.md#get_discovery_connection) | **GET** /api/3/discovery_connections/{id} | Discovery Connection
*SwaggerClient::AssetDiscoveryApi* | [**get_discovery_connections**](docs/AssetDiscoveryApi.md#get_discovery_connections) | **GET** /api/3/discovery_connections | Discovery Connections
*SwaggerClient::AssetDiscoveryApi* | [**get_sonar_queries**](docs/AssetDiscoveryApi.md#get_sonar_queries) | **GET** /api/3/sonar_queries | Sonar Queries
*SwaggerClient::AssetDiscoveryApi* | [**get_sonar_query**](docs/AssetDiscoveryApi.md#get_sonar_query) | **GET** /api/3/sonar_queries/{id} | Sonar Query
*SwaggerClient::AssetDiscoveryApi* | [**get_sonar_query_assets**](docs/AssetDiscoveryApi.md#get_sonar_query_assets) | **GET** /api/3/sonar_queries/{id}/assets | Sonar Query Assets
*SwaggerClient::AssetDiscoveryApi* | [**reconnect_discovery_connection**](docs/AssetDiscoveryApi.md#reconnect_discovery_connection) | **POST** /api/3/discovery_connections/{id}/connect | Discovery Connection Reconnect
*SwaggerClient::AssetDiscoveryApi* | [**sonar_query_search**](docs/AssetDiscoveryApi.md#sonar_query_search) | **POST** /api/3/sonar_queries/search | Sonar Query Search
*SwaggerClient::AssetDiscoveryApi* | [**update_sonar_query**](docs/AssetDiscoveryApi.md#update_sonar_query) | **PUT** /api/3/sonar_queries/{id} | Sonar Query
*SwaggerClient::AssetGroupApi* | [**add_asset_group_tag**](docs/AssetGroupApi.md#add_asset_group_tag) | **PUT** /api/3/asset_groups/{id}/tags/{tagId} | Resources and operations for managing asset groups.
*SwaggerClient::AssetGroupApi* | [**add_asset_group_user**](docs/AssetGroupApi.md#add_asset_group_user) | **PUT** /api/3/asset_groups/{id}/users/{userId} | Asset Group User
*SwaggerClient::AssetGroupApi* | [**add_asset_to_asset_group**](docs/AssetGroupApi.md#add_asset_to_asset_group) | **PUT** /api/3/asset_groups/{id}/assets/{assetId} | Asset Group Asset
*SwaggerClient::AssetGroupApi* | [**create_asset_group**](docs/AssetGroupApi.md#create_asset_group) | **POST** /api/3/asset_groups | Asset Groups
*SwaggerClient::AssetGroupApi* | [**delete_asset_group**](docs/AssetGroupApi.md#delete_asset_group) | **DELETE** /api/3/asset_groups/{id} | Asset Group
*SwaggerClient::AssetGroupApi* | [**get_agents**](docs/AssetGroupApi.md#get_agents) | **GET** /api/3/agents | Agents
*SwaggerClient::AssetGroupApi* | [**get_asset_group**](docs/AssetGroupApi.md#get_asset_group) | **GET** /api/3/asset_groups/{id} | Asset Group
*SwaggerClient::AssetGroupApi* | [**get_asset_group_assets**](docs/AssetGroupApi.md#get_asset_group_assets) | **GET** /api/3/asset_groups/{id}/assets | Asset Group Assets
*SwaggerClient::AssetGroupApi* | [**get_asset_group_search_criteria**](docs/AssetGroupApi.md#get_asset_group_search_criteria) | **GET** /api/3/asset_groups/{id}/search_criteria | Asset Group Search Criteria
*SwaggerClient::AssetGroupApi* | [**get_asset_group_tags**](docs/AssetGroupApi.md#get_asset_group_tags) | **GET** /api/3/asset_groups/{id}/tags | Asset Group Tags
*SwaggerClient::AssetGroupApi* | [**get_asset_group_users**](docs/AssetGroupApi.md#get_asset_group_users) | **GET** /api/3/asset_groups/{id}/users | Asset Group Users
*SwaggerClient::AssetGroupApi* | [**get_asset_groups**](docs/AssetGroupApi.md#get_asset_groups) | **GET** /api/3/asset_groups | Asset Groups
*SwaggerClient::AssetGroupApi* | [**remove_all_asset_group_tags**](docs/AssetGroupApi.md#remove_all_asset_group_tags) | **DELETE** /api/3/asset_groups/{id}/tags | Asset Group Tags
*SwaggerClient::AssetGroupApi* | [**remove_all_assets_from_asset_group**](docs/AssetGroupApi.md#remove_all_assets_from_asset_group) | **DELETE** /api/3/asset_groups/{id}/assets | Asset Group Assets
*SwaggerClient::AssetGroupApi* | [**remove_asset_from_asset_group**](docs/AssetGroupApi.md#remove_asset_from_asset_group) | **DELETE** /api/3/asset_groups/{id}/assets/{assetId} | Asset Group Asset
*SwaggerClient::AssetGroupApi* | [**remove_asset_group_tag**](docs/AssetGroupApi.md#remove_asset_group_tag) | **DELETE** /api/3/asset_groups/{id}/tags/{tagId} | Resources and operations for managing asset groups.
*SwaggerClient::AssetGroupApi* | [**remove_asset_group_user**](docs/AssetGroupApi.md#remove_asset_group_user) | **DELETE** /api/3/asset_groups/{id}/users/{userId} | Asset Group User
*SwaggerClient::AssetGroupApi* | [**set_asset_group_search_criteria**](docs/AssetGroupApi.md#set_asset_group_search_criteria) | **PUT** /api/3/asset_groups/{id}/search_criteria | Asset Group Search Criteria
*SwaggerClient::AssetGroupApi* | [**set_asset_group_tags**](docs/AssetGroupApi.md#set_asset_group_tags) | **PUT** /api/3/asset_groups/{id}/tags | Asset Group Tags
*SwaggerClient::AssetGroupApi* | [**set_asset_group_users**](docs/AssetGroupApi.md#set_asset_group_users) | **PUT** /api/3/asset_groups/{id}/users | Asset Group Users
*SwaggerClient::AssetGroupApi* | [**update_asset_group**](docs/AssetGroupApi.md#update_asset_group) | **PUT** /api/3/asset_groups/{id} | Asset Group
*SwaggerClient::AssetGroupApi* | [**update_asset_group_assets**](docs/AssetGroupApi.md#update_asset_group_assets) | **PUT** /api/3/asset_groups/{id}/assets | Asset Group Assets
*SwaggerClient::CredentialApi* | [**create_shared_credential**](docs/CredentialApi.md#create_shared_credential) | **POST** /api/3/shared_credentials | Shared Credentials
*SwaggerClient::CredentialApi* | [**delete_all_shared_credentials**](docs/CredentialApi.md#delete_all_shared_credentials) | **DELETE** /api/3/shared_credentials | Shared Credentials
*SwaggerClient::CredentialApi* | [**delete_shared_credential**](docs/CredentialApi.md#delete_shared_credential) | **DELETE** /api/3/shared_credentials/{id} | Shared Credential
*SwaggerClient::CredentialApi* | [**get_shared_credential**](docs/CredentialApi.md#get_shared_credential) | **GET** /api/3/shared_credentials/{id} | Shared Credential
*SwaggerClient::CredentialApi* | [**get_shared_credentials**](docs/CredentialApi.md#get_shared_credentials) | **GET** /api/3/shared_credentials | Shared Credentials
*SwaggerClient::CredentialApi* | [**update_shared_credential**](docs/CredentialApi.md#update_shared_credential) | **PUT** /api/3/shared_credentials/{id} | Shared Credential
*SwaggerClient::PolicyApi* | [**get_asset_policy_children**](docs/PolicyApi.md#get_asset_policy_children) | **GET** /api/3/assets/{assetId}/policies/{policyId}/children | Policy Rules or Groups Directly Under Policy For Asset
*SwaggerClient::PolicyApi* | [**get_asset_policy_group_children**](docs/PolicyApi.md#get_asset_policy_group_children) | **GET** /api/3/assets/{assetId}/policies/{policyId}/groups/{groupId}/children | Policy Rules or Groups Directly Under Policy Group For Asset
*SwaggerClient::PolicyApi* | [**get_asset_policy_rules_summary**](docs/PolicyApi.md#get_asset_policy_rules_summary) | **GET** /api/3/assets/{assetId}/policies/{policyId}/rules | Policy Rules For Asset
*SwaggerClient::PolicyApi* | [**get_descendant_policy_rules**](docs/PolicyApi.md#get_descendant_policy_rules) | **GET** /api/3/policies/{policyId}/groups/{groupId}/rules | Policy Rules Under Policy Group
*SwaggerClient::PolicyApi* | [**get_disabled_policy_rules**](docs/PolicyApi.md#get_disabled_policy_rules) | **GET** /api/3/policies/{policyId}/rules/disabled | Disabled Policy Rules
*SwaggerClient::PolicyApi* | [**get_policies**](docs/PolicyApi.md#get_policies) | **GET** /api/3/policies | Policies
*SwaggerClient::PolicyApi* | [**get_policies_for_asset**](docs/PolicyApi.md#get_policies_for_asset) | **GET** /api/3/assets/{assetId}/policies | Policies For Asset
*SwaggerClient::PolicyApi* | [**get_policy**](docs/PolicyApi.md#get_policy) | **GET** /api/3/policies/{policyId} | Policy
*SwaggerClient::PolicyApi* | [**get_policy_asset_result**](docs/PolicyApi.md#get_policy_asset_result) | **GET** /api/3/policies/{policyId}/assets/{assetId} | Policy Asset Result
*SwaggerClient::PolicyApi* | [**get_policy_asset_results**](docs/PolicyApi.md#get_policy_asset_results) | **GET** /api/3/policies/{policyId}/assets | Policy Asset Results
*SwaggerClient::PolicyApi* | [**get_policy_children**](docs/PolicyApi.md#get_policy_children) | **GET** /api/3/policies/{id}/children | Policy Rules or Groups Directly Under Policy
*SwaggerClient::PolicyApi* | [**get_policy_group**](docs/PolicyApi.md#get_policy_group) | **GET** /api/3/policies/{policyId}/groups/{groupId} | Policy Group
*SwaggerClient::PolicyApi* | [**get_policy_group_asset_result**](docs/PolicyApi.md#get_policy_group_asset_result) | **GET** /api/3/policies/{policyId}/groups/{groupId}/assets/{assetId} | Asset Compliance For Policy Rules Under Policy Group
*SwaggerClient::PolicyApi* | [**get_policy_group_asset_results**](docs/PolicyApi.md#get_policy_group_asset_results) | **GET** /api/3/policies/{policyId}/groups/{groupId}/assets | Assets Compliance For Policy Rules Under Policy Group
*SwaggerClient::PolicyApi* | [**get_policy_group_children**](docs/PolicyApi.md#get_policy_group_children) | **GET** /api/3/policies/{policyId}/groups/{groupId}/children | Policy Rules or Groups Directly Under Policy Group
*SwaggerClient::PolicyApi* | [**get_policy_group_rules_with_asset_assessment**](docs/PolicyApi.md#get_policy_group_rules_with_asset_assessment) | **GET** /api/3/assets/{assetId}/policies/{policyId}/groups/{groupId}/rules | Policy Rules Under Policy Group For Asset
*SwaggerClient::PolicyApi* | [**get_policy_groups**](docs/PolicyApi.md#get_policy_groups) | **GET** /api/3/policies/{policyId}/groups | Policy Groups
*SwaggerClient::PolicyApi* | [**get_policy_rule**](docs/PolicyApi.md#get_policy_rule) | **GET** /api/3/policies/{policyId}/rules/{ruleId} | Policy Rule
*SwaggerClient::PolicyApi* | [**get_policy_rule_asset_result**](docs/PolicyApi.md#get_policy_rule_asset_result) | **GET** /api/3/policies/{policyId}/rules/{ruleId}/assets/{assetId} | Asset Compliance For Policy Rule
*SwaggerClient::PolicyApi* | [**get_policy_rule_asset_result_proof**](docs/PolicyApi.md#get_policy_rule_asset_result_proof) | **GET** /api/3/policies/{policyId}/rules/{ruleId}/assets/{assetId}/proof | Policy Rule Proof For Asset
*SwaggerClient::PolicyApi* | [**get_policy_rule_asset_results**](docs/PolicyApi.md#get_policy_rule_asset_results) | **GET** /api/3/policies/{policyId}/rules/{ruleId}/assets | Assets Compliance For Policy Rule
*SwaggerClient::PolicyApi* | [**get_policy_rule_controls**](docs/PolicyApi.md#get_policy_rule_controls) | **GET** /api/3/policies/{policyId}/rules/{ruleId}/controls | Policy Rule Controls
*SwaggerClient::PolicyApi* | [**get_policy_rule_rationale**](docs/PolicyApi.md#get_policy_rule_rationale) | **GET** /api/3/policies/{policyId}/rules/{ruleId}/rationale | Policy Rule Rationale
*SwaggerClient::PolicyApi* | [**get_policy_rule_remediation**](docs/PolicyApi.md#get_policy_rule_remediation) | **GET** /api/3/policies/{policyId}/rules/{ruleId}/remediation | Policy Rule Remediation
*SwaggerClient::PolicyApi* | [**get_policy_rules**](docs/PolicyApi.md#get_policy_rules) | **GET** /api/3/policies/{policyId}/rules | Policy Rules
*SwaggerClient::PolicyApi* | [**get_policy_summary**](docs/PolicyApi.md#get_policy_summary) | **GET** /api/3/policy/summary | Policy Compliance Summaries
*SwaggerClient::PolicyOverrideApi* | [**create_policy_override**](docs/PolicyOverrideApi.md#create_policy_override) | **POST** /api/3/policy_overrides | Policy Overrides
*SwaggerClient::PolicyOverrideApi* | [**delete_policy_override**](docs/PolicyOverrideApi.md#delete_policy_override) | **DELETE** /api/3/policy_overrides/{id} | Policy Override
*SwaggerClient::PolicyOverrideApi* | [**get_asset_policy_overrides**](docs/PolicyOverrideApi.md#get_asset_policy_overrides) | **GET** /api/3/assets/{id}/policy_overrides | Asset Policy Overrides
*SwaggerClient::PolicyOverrideApi* | [**get_policy_override**](docs/PolicyOverrideApi.md#get_policy_override) | **GET** /api/3/policy_overrides/{id} | Policy Override
*SwaggerClient::PolicyOverrideApi* | [**get_policy_override_expiration**](docs/PolicyOverrideApi.md#get_policy_override_expiration) | **GET** /api/3/policy_overrides/{id}/expires | Policy Override Expiration
*SwaggerClient::PolicyOverrideApi* | [**get_policy_overrides**](docs/PolicyOverrideApi.md#get_policy_overrides) | **GET** /api/3/policy_overrides | Policy Overrides
*SwaggerClient::PolicyOverrideApi* | [**set_policy_override_expiration**](docs/PolicyOverrideApi.md#set_policy_override_expiration) | **PUT** /api/3/policy_overrides/{id}/expires | Policy Override Expiration
*SwaggerClient::PolicyOverrideApi* | [**set_policy_override_status**](docs/PolicyOverrideApi.md#set_policy_override_status) | **POST** /api/3/policy_overrides/{id}/{status} | Policy Override Status
*SwaggerClient::RemediationApi* | [**get_asset_vulnerability_solutions**](docs/RemediationApi.md#get_asset_vulnerability_solutions) | **GET** /api/3/assets/{id}/vulnerabilities/{vulnerabilityId}/solution | Asset Vulnerability Solution
*SwaggerClient::ReportApi* | [**create_report**](docs/ReportApi.md#create_report) | **POST** /api/3/reports | Reports
*SwaggerClient::ReportApi* | [**delete_report**](docs/ReportApi.md#delete_report) | **DELETE** /api/3/reports/{id} | Report
*SwaggerClient::ReportApi* | [**delete_report_instance**](docs/ReportApi.md#delete_report_instance) | **DELETE** /api/3/reports/{id}/history/{instance} | Report History
*SwaggerClient::ReportApi* | [**download_report**](docs/ReportApi.md#download_report) | **GET** /api/3/reports/{id}/history/{instance}/output | Report Download
*SwaggerClient::ReportApi* | [**generate_report**](docs/ReportApi.md#generate_report) | **POST** /api/3/reports/{id}/generate | Report Generation
*SwaggerClient::ReportApi* | [**get_report**](docs/ReportApi.md#get_report) | **GET** /api/3/reports/{id} | Report
*SwaggerClient::ReportApi* | [**get_report_formats**](docs/ReportApi.md#get_report_formats) | **GET** /api/3/report_formats | Report Formats
*SwaggerClient::ReportApi* | [**get_report_instance**](docs/ReportApi.md#get_report_instance) | **GET** /api/3/reports/{id}/history/{instance} | Report History
*SwaggerClient::ReportApi* | [**get_report_instances**](docs/ReportApi.md#get_report_instances) | **GET** /api/3/reports/{id}/history | Report Histories
*SwaggerClient::ReportApi* | [**get_report_template**](docs/ReportApi.md#get_report_template) | **GET** /api/3/report_templates/{id} | Report Template
*SwaggerClient::ReportApi* | [**get_report_templates**](docs/ReportApi.md#get_report_templates) | **GET** /api/3/report_templates | Report Templates
*SwaggerClient::ReportApi* | [**get_reports**](docs/ReportApi.md#get_reports) | **GET** /api/3/reports | Reports
*SwaggerClient::ReportApi* | [**update_report**](docs/ReportApi.md#update_report) | **PUT** /api/3/reports/{id} | Report
*SwaggerClient::RootApi* | [**resources**](docs/RootApi.md#resources) | **GET** /api/3 | Resources
*SwaggerClient::ScanApi* | [**get_scan**](docs/ScanApi.md#get_scan) | **GET** /api/3/scans/{id} | Scan
*SwaggerClient::ScanApi* | [**get_scans**](docs/ScanApi.md#get_scans) | **GET** /api/3/scans | Scans
*SwaggerClient::ScanApi* | [**get_site_scans**](docs/ScanApi.md#get_site_scans) | **GET** /api/3/sites/{id}/scans | Site Scans
*SwaggerClient::ScanApi* | [**set_scan_status**](docs/ScanApi.md#set_scan_status) | **POST** /api/3/scans/{id}/{status} | Scan Status
*SwaggerClient::ScanApi* | [**start_scan**](docs/ScanApi.md#start_scan) | **POST** /api/3/sites/{id}/scans | Site Scans
*SwaggerClient::ScanEngineApi* | [**add_scan_engine_pool_scan_engine**](docs/ScanEngineApi.md#add_scan_engine_pool_scan_engine) | **PUT** /api/3/scan_engine_pools/{id}/engines/{engineId} | Engine Pool Engines
*SwaggerClient::ScanEngineApi* | [**create_scan_engine**](docs/ScanEngineApi.md#create_scan_engine) | **POST** /api/3/scan_engines | Scan Engines
*SwaggerClient::ScanEngineApi* | [**create_scan_engine_pool**](docs/ScanEngineApi.md#create_scan_engine_pool) | **POST** /api/3/scan_engine_pools | Engine Pools
*SwaggerClient::ScanEngineApi* | [**create_shared_secret**](docs/ScanEngineApi.md#create_shared_secret) | **POST** /api/3/scan_engines/shared_secret | Scan Engine Shared Secret
*SwaggerClient::ScanEngineApi* | [**delete_scan_engine**](docs/ScanEngineApi.md#delete_scan_engine) | **DELETE** /api/3/scan_engines/{id} | Scan Engine
*SwaggerClient::ScanEngineApi* | [**delete_shared_secret**](docs/ScanEngineApi.md#delete_shared_secret) | **DELETE** /api/3/scan_engines/shared_secret | Scan Engine Shared Secret
*SwaggerClient::ScanEngineApi* | [**get_assigned_engine_pools**](docs/ScanEngineApi.md#get_assigned_engine_pools) | **GET** /api/3/scan_engines/{id}/scan_engine_pools | Assigned Engine Pools
*SwaggerClient::ScanEngineApi* | [**get_current_shared_secret**](docs/ScanEngineApi.md#get_current_shared_secret) | **GET** /api/3/scan_engines/shared_secret | Scan Engine Shared Secret
*SwaggerClient::ScanEngineApi* | [**get_current_shared_secret_time_to_live**](docs/ScanEngineApi.md#get_current_shared_secret_time_to_live) | **GET** /api/3/scan_engines/shared_secret/time_to_live | Scan Engine Shared Secret Time to live
*SwaggerClient::ScanEngineApi* | [**get_engine_pool**](docs/ScanEngineApi.md#get_engine_pool) | **GET** /api/3/scan_engine_pools/{id} | Engine Pool
*SwaggerClient::ScanEngineApi* | [**get_scan_engine**](docs/ScanEngineApi.md#get_scan_engine) | **GET** /api/3/scan_engines/{id} | Scan Engine
*SwaggerClient::ScanEngineApi* | [**get_scan_engine_pool_scan_engines**](docs/ScanEngineApi.md#get_scan_engine_pool_scan_engines) | **GET** /api/3/scan_engine_pools/{id}/engines | Engine Pool Engines
*SwaggerClient::ScanEngineApi* | [**get_scan_engine_pool_sites**](docs/ScanEngineApi.md#get_scan_engine_pool_sites) | **GET** /api/3/scan_engine_pools/{id}/sites | Engine Pool Sites
*SwaggerClient::ScanEngineApi* | [**get_scan_engine_pools**](docs/ScanEngineApi.md#get_scan_engine_pools) | **GET** /api/3/scan_engine_pools | Engine Pools
*SwaggerClient::ScanEngineApi* | [**get_scan_engine_scans**](docs/ScanEngineApi.md#get_scan_engine_scans) | **GET** /api/3/scan_engines/{id}/scans | Scan Engine Scans
*SwaggerClient::ScanEngineApi* | [**get_scan_engine_sites**](docs/ScanEngineApi.md#get_scan_engine_sites) | **GET** /api/3/scan_engines/{id}/sites | Scan Engine Sites
*SwaggerClient::ScanEngineApi* | [**get_scan_engines**](docs/ScanEngineApi.md#get_scan_engines) | **GET** /api/3/scan_engines | Scan Engines
*SwaggerClient::ScanEngineApi* | [**remove_scan_engine_pool**](docs/ScanEngineApi.md#remove_scan_engine_pool) | **DELETE** /api/3/scan_engine_pools/{id} | Engine Pool
*SwaggerClient::ScanEngineApi* | [**remove_scan_engine_pool_scan_engine**](docs/ScanEngineApi.md#remove_scan_engine_pool_scan_engine) | **DELETE** /api/3/scan_engine_pools/{id}/engines/{engineId} | Engine Pool Engines
*SwaggerClient::ScanEngineApi* | [**set_scan_engine_pool_scan_engines**](docs/ScanEngineApi.md#set_scan_engine_pool_scan_engines) | **PUT** /api/3/scan_engine_pools/{id}/engines | Engine Pool Engines
*SwaggerClient::ScanEngineApi* | [**update_scan_engine**](docs/ScanEngineApi.md#update_scan_engine) | **PUT** /api/3/scan_engines/{id} | Scan Engine
*SwaggerClient::ScanEngineApi* | [**update_scan_engine_pool**](docs/ScanEngineApi.md#update_scan_engine_pool) | **PUT** /api/3/scan_engine_pools/{id} | Engine Pool
*SwaggerClient::ScanTemplateApi* | [**create_scan_template**](docs/ScanTemplateApi.md#create_scan_template) | **POST** /api/3/scan_templates | Scan Templates
*SwaggerClient::ScanTemplateApi* | [**delete_scan_template**](docs/ScanTemplateApi.md#delete_scan_template) | **DELETE** /api/3/scan_templates/{id} | Scan Template
*SwaggerClient::ScanTemplateApi* | [**get_scan_template**](docs/ScanTemplateApi.md#get_scan_template) | **GET** /api/3/scan_templates/{id} | Scan Template
*SwaggerClient::ScanTemplateApi* | [**get_scan_templates**](docs/ScanTemplateApi.md#get_scan_templates) | **GET** /api/3/scan_templates | Scan Templates
*SwaggerClient::ScanTemplateApi* | [**update_scan_template**](docs/ScanTemplateApi.md#update_scan_template) | **PUT** /api/3/scan_templates/{id} | Scan Template
*SwaggerClient::SiteApi* | [**add_excluded_targets**](docs/SiteApi.md#add_excluded_targets) | **POST** /api/3/sites/{id}/excluded_targets | Site Excluded Targets
*SwaggerClient::SiteApi* | [**add_included_targets**](docs/SiteApi.md#add_included_targets) | **POST** /api/3/sites/{id}/included_targets | Site Included Targets
*SwaggerClient::SiteApi* | [**add_site_tag**](docs/SiteApi.md#add_site_tag) | **PUT** /api/3/sites/{id}/tags/{tagId} | Site Tag
*SwaggerClient::SiteApi* | [**add_site_user**](docs/SiteApi.md#add_site_user) | **POST** /api/3/sites/{id}/users | Site Users Access
*SwaggerClient::SiteApi* | [**create_site**](docs/SiteApi.md#create_site) | **POST** /api/3/sites | Sites
*SwaggerClient::SiteApi* | [**create_site_credential**](docs/SiteApi.md#create_site_credential) | **POST** /api/3/sites/{id}/site_credentials | Site Scan Credentials
*SwaggerClient::SiteApi* | [**create_site_scan_schedule**](docs/SiteApi.md#create_site_scan_schedule) | **POST** /api/3/sites/{id}/scan_schedules | Site Scan Schedules
*SwaggerClient::SiteApi* | [**create_site_smtp_alert**](docs/SiteApi.md#create_site_smtp_alert) | **POST** /api/3/sites/{id}/alerts/smtp | Site SMTP Alerts
*SwaggerClient::SiteApi* | [**create_site_snmp_alert**](docs/SiteApi.md#create_site_snmp_alert) | **POST** /api/3/sites/{id}/alerts/snmp | Site SNMP Alerts
*SwaggerClient::SiteApi* | [**create_site_syslog_alert**](docs/SiteApi.md#create_site_syslog_alert) | **POST** /api/3/sites/{id}/alerts/syslog | Site Syslog Alerts
*SwaggerClient::SiteApi* | [**delete_all_site_alerts**](docs/SiteApi.md#delete_all_site_alerts) | **DELETE** /api/3/sites/{id}/alerts | Site Alerts
*SwaggerClient::SiteApi* | [**delete_all_site_credentials**](docs/SiteApi.md#delete_all_site_credentials) | **DELETE** /api/3/sites/{id}/site_credentials | Site Scan Credentials
*SwaggerClient::SiteApi* | [**delete_all_site_scan_schedules**](docs/SiteApi.md#delete_all_site_scan_schedules) | **DELETE** /api/3/sites/{id}/scan_schedules | Site Scan Schedules
*SwaggerClient::SiteApi* | [**delete_all_site_smtp_alerts**](docs/SiteApi.md#delete_all_site_smtp_alerts) | **DELETE** /api/3/sites/{id}/alerts/smtp | Site SMTP Alerts
*SwaggerClient::SiteApi* | [**delete_all_site_snmp_alerts**](docs/SiteApi.md#delete_all_site_snmp_alerts) | **DELETE** /api/3/sites/{id}/alerts/snmp | Site SNMP Alerts
*SwaggerClient::SiteApi* | [**delete_all_site_syslog_alerts**](docs/SiteApi.md#delete_all_site_syslog_alerts) | **DELETE** /api/3/sites/{id}/alerts/syslog | Site Syslog Alerts
*SwaggerClient::SiteApi* | [**delete_site**](docs/SiteApi.md#delete_site) | **DELETE** /api/3/sites/{id} | Site
*SwaggerClient::SiteApi* | [**delete_site_credential**](docs/SiteApi.md#delete_site_credential) | **DELETE** /api/3/sites/{id}/site_credentials/{credentialId} | Site Scan Credential
*SwaggerClient::SiteApi* | [**delete_site_scan_schedule**](docs/SiteApi.md#delete_site_scan_schedule) | **DELETE** /api/3/sites/{id}/scan_schedules/{scheduleId} | Site Scan Schedule
*SwaggerClient::SiteApi* | [**delete_site_smtp_alert**](docs/SiteApi.md#delete_site_smtp_alert) | **DELETE** /api/3/sites/{id}/alerts/smtp/{alertId} | Site SMTP Alert
*SwaggerClient::SiteApi* | [**delete_site_snmp_alert**](docs/SiteApi.md#delete_site_snmp_alert) | **DELETE** /api/3/sites/{id}/alerts/snmp/{alertId} | Site SNMP Alert
*SwaggerClient::SiteApi* | [**delete_site_syslog_alert**](docs/SiteApi.md#delete_site_syslog_alert) | **DELETE** /api/3/sites/{id}/alerts/syslog/{alertId} | Site Syslog Alert
*SwaggerClient::SiteApi* | [**enable_shared_credential_on_site**](docs/SiteApi.md#enable_shared_credential_on_site) | **PUT** /api/3/sites/{id}/shared_credentials/{credentialId}/enabled | Assigned Shared Credential Enablement
*SwaggerClient::SiteApi* | [**enable_site_credential**](docs/SiteApi.md#enable_site_credential) | **PUT** /api/3/sites/{id}/site_credentials/{credentialId}/enabled | Site Credential Enablement
*SwaggerClient::SiteApi* | [**get_excluded_asset_groups**](docs/SiteApi.md#get_excluded_asset_groups) | **GET** /api/3/sites/{id}/excluded_asset_groups | Site Excluded Asset Groups
*SwaggerClient::SiteApi* | [**get_excluded_targets**](docs/SiteApi.md#get_excluded_targets) | **GET** /api/3/sites/{id}/excluded_targets | Site Excluded Targets
*SwaggerClient::SiteApi* | [**get_included_asset_groups**](docs/SiteApi.md#get_included_asset_groups) | **GET** /api/3/sites/{id}/included_asset_groups | Site Included Asset Groups
*SwaggerClient::SiteApi* | [**get_included_targets**](docs/SiteApi.md#get_included_targets) | **GET** /api/3/sites/{id}/included_targets | Site Included Targets
*SwaggerClient::SiteApi* | [**get_site**](docs/SiteApi.md#get_site) | **GET** /api/3/sites/{id} | Site
*SwaggerClient::SiteApi* | [**get_site_alerts**](docs/SiteApi.md#get_site_alerts) | **GET** /api/3/sites/{id}/alerts | Site Alerts
*SwaggerClient::SiteApi* | [**get_site_assets**](docs/SiteApi.md#get_site_assets) | **GET** /api/3/sites/{id}/assets | Site Assets
*SwaggerClient::SiteApi* | [**get_site_credential**](docs/SiteApi.md#get_site_credential) | **GET** /api/3/sites/{id}/site_credentials/{credentialId} | Site Scan Credential
*SwaggerClient::SiteApi* | [**get_site_credentials**](docs/SiteApi.md#get_site_credentials) | **GET** /api/3/sites/{id}/site_credentials | Site Scan Credentials
*SwaggerClient::SiteApi* | [**get_site_discovery_connection**](docs/SiteApi.md#get_site_discovery_connection) | **GET** /api/3/sites/{id}/discovery_connection | Site Discovery Connection
*SwaggerClient::SiteApi* | [**get_site_discovery_search_criteria**](docs/SiteApi.md#get_site_discovery_search_criteria) | **GET** /api/3/sites/{id}/discovery_search_criteria | Site Discovery Search Criteria
*SwaggerClient::SiteApi* | [**get_site_organization**](docs/SiteApi.md#get_site_organization) | **GET** /api/3/sites/{id}/organization | Site Organization Information
*SwaggerClient::SiteApi* | [**get_site_scan_engine**](docs/SiteApi.md#get_site_scan_engine) | **GET** /api/3/sites/{id}/scan_engine | Site Scan Engine
*SwaggerClient::SiteApi* | [**get_site_scan_schedule**](docs/SiteApi.md#get_site_scan_schedule) | **GET** /api/3/sites/{id}/scan_schedules/{scheduleId} | Site Scan Schedule
*SwaggerClient::SiteApi* | [**get_site_scan_schedules**](docs/SiteApi.md#get_site_scan_schedules) | **GET** /api/3/sites/{id}/scan_schedules | Site Scan Schedules
*SwaggerClient::SiteApi* | [**get_site_scan_template**](docs/SiteApi.md#get_site_scan_template) | **GET** /api/3/sites/{id}/scan_template | Site Scan Template
*SwaggerClient::SiteApi* | [**get_site_shared_credentials**](docs/SiteApi.md#get_site_shared_credentials) | **GET** /api/3/sites/{id}/shared_credentials | Assigned Shared Credentials
*SwaggerClient::SiteApi* | [**get_site_smtp_alert**](docs/SiteApi.md#get_site_smtp_alert) | **GET** /api/3/sites/{id}/alerts/smtp/{alertId} | Site SMTP Alert
*SwaggerClient::SiteApi* | [**get_site_smtp_alerts**](docs/SiteApi.md#get_site_smtp_alerts) | **GET** /api/3/sites/{id}/alerts/smtp | Site SMTP Alerts
*SwaggerClient::SiteApi* | [**get_site_snmp_alert**](docs/SiteApi.md#get_site_snmp_alert) | **GET** /api/3/sites/{id}/alerts/snmp/{alertId} | Site SNMP Alert
*SwaggerClient::SiteApi* | [**get_site_snmp_alerts**](docs/SiteApi.md#get_site_snmp_alerts) | **GET** /api/3/sites/{id}/alerts/snmp | Site SNMP Alerts
*SwaggerClient::SiteApi* | [**get_site_syslog_alert**](docs/SiteApi.md#get_site_syslog_alert) | **GET** /api/3/sites/{id}/alerts/syslog/{alertId} | Site Syslog Alert
*SwaggerClient::SiteApi* | [**get_site_syslog_alerts**](docs/SiteApi.md#get_site_syslog_alerts) | **GET** /api/3/sites/{id}/alerts/syslog | Site Syslog Alerts
*SwaggerClient::SiteApi* | [**get_site_tags**](docs/SiteApi.md#get_site_tags) | **GET** /api/3/sites/{id}/tags | Site Tags
*SwaggerClient::SiteApi* | [**get_site_users**](docs/SiteApi.md#get_site_users) | **GET** /api/3/sites/{id}/users | Site Users Access
*SwaggerClient::SiteApi* | [**get_sites**](docs/SiteApi.md#get_sites) | **GET** /api/3/sites | Sites
*SwaggerClient::SiteApi* | [**get_web_auth_html_forms**](docs/SiteApi.md#get_web_auth_html_forms) | **GET** /api/3/sites/{id}/web_authentication/html_forms | Web Authentication HTML Forms
*SwaggerClient::SiteApi* | [**get_web_auth_http_headers**](docs/SiteApi.md#get_web_auth_http_headers) | **GET** /api/3/sites/{id}/web_authentication/http_headers | Web Authentication HTTP Headers
*SwaggerClient::SiteApi* | [**remove_all_excluded_asset_groups**](docs/SiteApi.md#remove_all_excluded_asset_groups) | **DELETE** /api/3/sites/{id}/excluded_asset_groups | Site Excluded Asset Groups
*SwaggerClient::SiteApi* | [**remove_all_included_asset_groups**](docs/SiteApi.md#remove_all_included_asset_groups) | **DELETE** /api/3/sites/{id}/included_asset_groups | Site Included Asset Groups
*SwaggerClient::SiteApi* | [**remove_asset_from_site**](docs/SiteApi.md#remove_asset_from_site) | **DELETE** /api/3/sites/{id}/assets/{assetId} | Site Asset
*SwaggerClient::SiteApi* | [**remove_excluded_asset_group**](docs/SiteApi.md#remove_excluded_asset_group) | **DELETE** /api/3/sites/{id}/excluded_asset_groups/{assetGroupId} | Site Excluded Asset Group
*SwaggerClient::SiteApi* | [**remove_excluded_targets**](docs/SiteApi.md#remove_excluded_targets) | **DELETE** /api/3/sites/{id}/excluded_targets | Site Excluded Targets
*SwaggerClient::SiteApi* | [**remove_included_asset_group**](docs/SiteApi.md#remove_included_asset_group) | **DELETE** /api/3/sites/{id}/included_asset_groups/{assetGroupId} | Site Included Asset Group
*SwaggerClient::SiteApi* | [**remove_included_targets**](docs/SiteApi.md#remove_included_targets) | **DELETE** /api/3/sites/{id}/included_targets | Site Included Targets
*SwaggerClient::SiteApi* | [**remove_site_assets**](docs/SiteApi.md#remove_site_assets) | **DELETE** /api/3/sites/{id}/assets | Site Assets
*SwaggerClient::SiteApi* | [**remove_site_tag**](docs/SiteApi.md#remove_site_tag) | **DELETE** /api/3/sites/{id}/tags/{tagId} | Site Tag
*SwaggerClient::SiteApi* | [**remove_site_user**](docs/SiteApi.md#remove_site_user) | **DELETE** /api/3/sites/{id}/users/{userId} | Site User Access
*SwaggerClient::SiteApi* | [**set_site_credentials**](docs/SiteApi.md#set_site_credentials) | **PUT** /api/3/sites/{id}/site_credentials | Site Scan Credentials
*SwaggerClient::SiteApi* | [**set_site_discovery_connection**](docs/SiteApi.md#set_site_discovery_connection) | **PUT** /api/3/sites/{id}/discovery_connection | Site Discovery Connection
*SwaggerClient::SiteApi* | [**set_site_discovery_search_criteria**](docs/SiteApi.md#set_site_discovery_search_criteria) | **PUT** /api/3/sites/{id}/discovery_search_criteria | Site Discovery Search Criteria
*SwaggerClient::SiteApi* | [**set_site_scan_engine**](docs/SiteApi.md#set_site_scan_engine) | **PUT** /api/3/sites/{id}/scan_engine | Site Scan Engine
*SwaggerClient::SiteApi* | [**set_site_scan_schedules**](docs/SiteApi.md#set_site_scan_schedules) | **PUT** /api/3/sites/{id}/scan_schedules | Site Scan Schedules
*SwaggerClient::SiteApi* | [**set_site_scan_template**](docs/SiteApi.md#set_site_scan_template) | **PUT** /api/3/sites/{id}/scan_template | Site Scan Template
*SwaggerClient::SiteApi* | [**set_site_smtp_alerts**](docs/SiteApi.md#set_site_smtp_alerts) | **PUT** /api/3/sites/{id}/alerts/smtp | Site SMTP Alerts
*SwaggerClient::SiteApi* | [**set_site_snmp_alerts**](docs/SiteApi.md#set_site_snmp_alerts) | **PUT** /api/3/sites/{id}/alerts/snmp | Site SNMP Alerts
*SwaggerClient::SiteApi* | [**set_site_syslog_alerts**](docs/SiteApi.md#set_site_syslog_alerts) | **PUT** /api/3/sites/{id}/alerts/syslog | Site Syslog Alerts
*SwaggerClient::SiteApi* | [**set_site_tags**](docs/SiteApi.md#set_site_tags) | **PUT** /api/3/sites/{id}/tags | Site Tags
*SwaggerClient::SiteApi* | [**set_site_users**](docs/SiteApi.md#set_site_users) | **PUT** /api/3/sites/{id}/users | Site Users Access
*SwaggerClient::SiteApi* | [**update_excluded_asset_groups**](docs/SiteApi.md#update_excluded_asset_groups) | **PUT** /api/3/sites/{id}/excluded_asset_groups | Site Excluded Asset Groups
*SwaggerClient::SiteApi* | [**update_excluded_targets**](docs/SiteApi.md#update_excluded_targets) | **PUT** /api/3/sites/{id}/excluded_targets | Site Excluded Targets
*SwaggerClient::SiteApi* | [**update_included_asset_groups**](docs/SiteApi.md#update_included_asset_groups) | **PUT** /api/3/sites/{id}/included_asset_groups | Site Included Asset Groups
*SwaggerClient::SiteApi* | [**update_included_targets**](docs/SiteApi.md#update_included_targets) | **PUT** /api/3/sites/{id}/included_targets | Site Included Targets
*SwaggerClient::SiteApi* | [**update_site**](docs/SiteApi.md#update_site) | **PUT** /api/3/sites/{id} | Site
*SwaggerClient::SiteApi* | [**update_site_credential**](docs/SiteApi.md#update_site_credential) | **PUT** /api/3/sites/{id}/site_credentials/{credentialId} | Site Scan Credential
*SwaggerClient::SiteApi* | [**update_site_organization**](docs/SiteApi.md#update_site_organization) | **PUT** /api/3/sites/{id}/organization | Site Organization Information
*SwaggerClient::SiteApi* | [**update_site_scan_schedule**](docs/SiteApi.md#update_site_scan_schedule) | **PUT** /api/3/sites/{id}/scan_schedules/{scheduleId} | Site Scan Schedule
*SwaggerClient::SiteApi* | [**update_site_smtp_alert**](docs/SiteApi.md#update_site_smtp_alert) | **PUT** /api/3/sites/{id}/alerts/smtp/{alertId} | Site SMTP Alert
*SwaggerClient::SiteApi* | [**update_site_snmp_alert**](docs/SiteApi.md#update_site_snmp_alert) | **PUT** /api/3/sites/{id}/alerts/snmp/{alertId} | Site SNMP Alert
*SwaggerClient::SiteApi* | [**update_site_syslog_alert**](docs/SiteApi.md#update_site_syslog_alert) | **PUT** /api/3/sites/{id}/alerts/syslog/{alertId} | Site Syslog Alert
*SwaggerClient::TagApi* | [**create_tag**](docs/TagApi.md#create_tag) | **POST** /api/3/tags | Tags
*SwaggerClient::TagApi* | [**delete_tag**](docs/TagApi.md#delete_tag) | **DELETE** /api/3/tags/{id} | Tag
*SwaggerClient::TagApi* | [**get_tag**](docs/TagApi.md#get_tag) | **GET** /api/3/tags/{id} | Tag
*SwaggerClient::TagApi* | [**get_tag_asset_groups**](docs/TagApi.md#get_tag_asset_groups) | **GET** /api/3/tags/{id}/asset_groups | Tag Asset Groups
*SwaggerClient::TagApi* | [**get_tag_search_criteria**](docs/TagApi.md#get_tag_search_criteria) | **GET** /api/3/tags/{id}/search_criteria | Tag Search Criteria
*SwaggerClient::TagApi* | [**get_tagged_assets**](docs/TagApi.md#get_tagged_assets) | **GET** /api/3/tags/{id}/assets | Tag Assets
*SwaggerClient::TagApi* | [**get_tagged_sites**](docs/TagApi.md#get_tagged_sites) | **GET** /api/3/tags/{id}/sites | Tag Sites
*SwaggerClient::TagApi* | [**get_tags**](docs/TagApi.md#get_tags) | **GET** /api/3/tags | Tags
*SwaggerClient::TagApi* | [**remove_tag_search_criteria**](docs/TagApi.md#remove_tag_search_criteria) | **DELETE** /api/3/tags/{id}/search_criteria | Tag Search Criteria
*SwaggerClient::TagApi* | [**remove_tagged_sites**](docs/TagApi.md#remove_tagged_sites) | **DELETE** /api/3/tags/{id}/sites | Tag Sites
*SwaggerClient::TagApi* | [**set_tagged_asset_groups**](docs/TagApi.md#set_tagged_asset_groups) | **PUT** /api/3/tags/{id}/asset_groups | Tag Asset Groups
*SwaggerClient::TagApi* | [**set_tagged_sites**](docs/TagApi.md#set_tagged_sites) | **PUT** /api/3/tags/{id}/sites | Tag Sites
*SwaggerClient::TagApi* | [**tag_asset**](docs/TagApi.md#tag_asset) | **PUT** /api/3/tags/{id}/assets/{assetId} | Tag Asset
*SwaggerClient::TagApi* | [**tag_asset_group**](docs/TagApi.md#tag_asset_group) | **PUT** /api/3/tags/{id}/asset_groups/{assetGroupId} | Tag Asset Group
*SwaggerClient::TagApi* | [**tag_site**](docs/TagApi.md#tag_site) | **PUT** /api/3/tags/{id}/sites/{siteId} | Tag Site
*SwaggerClient::TagApi* | [**untag_all_asset_groups**](docs/TagApi.md#untag_all_asset_groups) | **DELETE** /api/3/tags/{id}/asset_groups | Tag Asset Groups
*SwaggerClient::TagApi* | [**untag_asset**](docs/TagApi.md#untag_asset) | **DELETE** /api/3/tags/{id}/assets/{assetId} | Tag Asset
*SwaggerClient::TagApi* | [**untag_asset_group**](docs/TagApi.md#untag_asset_group) | **DELETE** /api/3/tags/{id}/asset_groups/{assetGroupId} | Tag Asset Group
*SwaggerClient::TagApi* | [**untag_site**](docs/TagApi.md#untag_site) | **DELETE** /api/3/tags/{id}/sites/{siteId} | Tag Site
*SwaggerClient::TagApi* | [**update_tag**](docs/TagApi.md#update_tag) | **PUT** /api/3/tags/{id} | Tag
*SwaggerClient::TagApi* | [**update_tag_search_criteria**](docs/TagApi.md#update_tag_search_criteria) | **PUT** /api/3/tags/{id}/search_criteria | Tag Search Criteria
*SwaggerClient::UserApi* | [**add_user_asset_group**](docs/UserApi.md#add_user_asset_group) | **PUT** /api/3/users/{id}/asset_groups/{assetGroupId} | Asset Group Access
*SwaggerClient::UserApi* | [**add_user_site**](docs/UserApi.md#add_user_site) | **PUT** /api/3/users/{id}/sites/{siteId} | Site Access
*SwaggerClient::UserApi* | [**create_user**](docs/UserApi.md#create_user) | **POST** /api/3/users | Users
*SwaggerClient::UserApi* | [**delete_role**](docs/UserApi.md#delete_role) | **DELETE** /api/3/roles/{id} | Role
*SwaggerClient::UserApi* | [**delete_user**](docs/UserApi.md#delete_user) | **DELETE** /api/3/users/{id} | User
*SwaggerClient::UserApi* | [**get_authentication_source**](docs/UserApi.md#get_authentication_source) | **GET** /api/3/authentication_sources/{id} | Authentication Source
*SwaggerClient::UserApi* | [**get_authentication_source_users**](docs/UserApi.md#get_authentication_source_users) | **GET** /api/3/authentication_sources/{id}/users | Authentication Source Users
*SwaggerClient::UserApi* | [**get_authentication_sources**](docs/UserApi.md#get_authentication_sources) | **GET** /api/3/authentication_sources | Authentication Sources
*SwaggerClient::UserApi* | [**get_privilege**](docs/UserApi.md#get_privilege) | **GET** /api/3/privileges/{id} | Privilege
*SwaggerClient::UserApi* | [**get_privileges**](docs/UserApi.md#get_privileges) | **GET** /api/3/privileges | Privileges
*SwaggerClient::UserApi* | [**get_role**](docs/UserApi.md#get_role) | **GET** /api/3/roles/{id} | Role
*SwaggerClient::UserApi* | [**get_role_users**](docs/UserApi.md#get_role_users) | **GET** /api/3/roles/{id}/users | Users With Role
*SwaggerClient::UserApi* | [**get_roles**](docs/UserApi.md#get_roles) | **GET** /api/3/roles | Roles
*SwaggerClient::UserApi* | [**get_two_factor_authentication_key**](docs/UserApi.md#get_two_factor_authentication_key) | **GET** /api/3/users/{id}/2FA | Two-Factor Authentication
*SwaggerClient::UserApi* | [**get_user**](docs/UserApi.md#get_user) | **GET** /api/3/users/{id} | User
*SwaggerClient::UserApi* | [**get_user_asset_groups**](docs/UserApi.md#get_user_asset_groups) | **GET** /api/3/users/{id}/asset_groups | Asset Groups Access
*SwaggerClient::UserApi* | [**get_user_privileges**](docs/UserApi.md#get_user_privileges) | **GET** /api/3/users/{id}/privileges | User Privileges
*SwaggerClient::UserApi* | [**get_user_sites**](docs/UserApi.md#get_user_sites) | **GET** /api/3/users/{id}/sites | Sites Access
*SwaggerClient::UserApi* | [**get_users**](docs/UserApi.md#get_users) | **GET** /api/3/users | Users
*SwaggerClient::UserApi* | [**get_users_with_privilege**](docs/UserApi.md#get_users_with_privilege) | **GET** /api/3/privileges/{id}/users | Users With Privilege
*SwaggerClient::UserApi* | [**regenerate_two_factor_authentication**](docs/UserApi.md#regenerate_two_factor_authentication) | **POST** /api/3/users/{id}/2FA | Two-Factor Authentication
*SwaggerClient::UserApi* | [**remove_all_user_asset_groups**](docs/UserApi.md#remove_all_user_asset_groups) | **DELETE** /api/3/users/{id}/asset_groups | Asset Groups Access
*SwaggerClient::UserApi* | [**remove_all_user_sites**](docs/UserApi.md#remove_all_user_sites) | **DELETE** /api/3/users/{id}/sites | Sites Access
*SwaggerClient::UserApi* | [**remove_user_asset_group**](docs/UserApi.md#remove_user_asset_group) | **DELETE** /api/3/users/{id}/asset_groups/{assetGroupId} | Asset Group Access
*SwaggerClient::UserApi* | [**remove_user_site**](docs/UserApi.md#remove_user_site) | **DELETE** /api/3/users/{id}/sites/{siteId} | Site Access
*SwaggerClient::UserApi* | [**reset_password**](docs/UserApi.md#reset_password) | **PUT** /api/3/users/{id}/password | Password Reset
*SwaggerClient::UserApi* | [**set_two_factor_authentication**](docs/UserApi.md#set_two_factor_authentication) | **PUT** /api/3/users/{id}/2FA | Two-Factor Authentication
*SwaggerClient::UserApi* | [**set_user_asset_groups**](docs/UserApi.md#set_user_asset_groups) | **PUT** /api/3/users/{id}/asset_groups | Asset Groups Access
*SwaggerClient::UserApi* | [**set_user_sites**](docs/UserApi.md#set_user_sites) | **PUT** /api/3/users/{id}/sites | Sites Access
*SwaggerClient::UserApi* | [**unlock_user**](docs/UserApi.md#unlock_user) | **DELETE** /api/3/users/{id}/lock | Unlock Account
*SwaggerClient::UserApi* | [**update_role**](docs/UserApi.md#update_role) | **PUT** /api/3/roles/{id} | Role
*SwaggerClient::UserApi* | [**update_user**](docs/UserApi.md#update_user) | **PUT** /api/3/users/{id} | User
*SwaggerClient::VulnerabilityApi* | [**get_affected_assets**](docs/VulnerabilityApi.md#get_affected_assets) | **GET** /api/3/vulnerabilities/{id}/assets | Vulnerability Affected Assets
*SwaggerClient::VulnerabilityApi* | [**get_exploit**](docs/VulnerabilityApi.md#get_exploit) | **GET** /api/3/exploits/{id} | Exploit
*SwaggerClient::VulnerabilityApi* | [**get_exploit_vulnerabilities**](docs/VulnerabilityApi.md#get_exploit_vulnerabilities) | **GET** /api/3/exploits/{id}/vulnerabilities | Exploitable Vulnerabilities
*SwaggerClient::VulnerabilityApi* | [**get_exploits**](docs/VulnerabilityApi.md#get_exploits) | **GET** /api/3/exploits | Exploits
*SwaggerClient::VulnerabilityApi* | [**get_malware_kit**](docs/VulnerabilityApi.md#get_malware_kit) | **GET** /api/3/malware_kits/{id} | Malware Kit
*SwaggerClient::VulnerabilityApi* | [**get_malware_kit_vulnerabilities**](docs/VulnerabilityApi.md#get_malware_kit_vulnerabilities) | **GET** /api/3/malware_kits/{id}/vulnerabilities | Malware Kit Vulnerabilities
*SwaggerClient::VulnerabilityApi* | [**get_malware_kits**](docs/VulnerabilityApi.md#get_malware_kits) | **GET** /api/3/malware_kits | Malware Kits
*SwaggerClient::VulnerabilityApi* | [**get_prerequisite_solutions**](docs/VulnerabilityApi.md#get_prerequisite_solutions) | **GET** /api/3/solutions/{id}/prerequisites | Solution Prerequisites
*SwaggerClient::VulnerabilityApi* | [**get_solution**](docs/VulnerabilityApi.md#get_solution) | **GET** /api/3/solutions/{id} | Solution
*SwaggerClient::VulnerabilityApi* | [**get_solutions**](docs/VulnerabilityApi.md#get_solutions) | **GET** /api/3/solutions | Solutions
*SwaggerClient::VulnerabilityApi* | [**get_superseded_solutions**](docs/VulnerabilityApi.md#get_superseded_solutions) | **GET** /api/3/solutions/{id}/supersedes | Superseded Solutions
*SwaggerClient::VulnerabilityApi* | [**get_superseding_solutions**](docs/VulnerabilityApi.md#get_superseding_solutions) | **GET** /api/3/solutions/{id}/superseding | Superseding Solutions
*SwaggerClient::VulnerabilityApi* | [**get_vulnerabilities**](docs/VulnerabilityApi.md#get_vulnerabilities) | **GET** /api/3/vulnerabilities | Vulnerabilities
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability**](docs/VulnerabilityApi.md#get_vulnerability) | **GET** /api/3/vulnerabilities/{id} | Vulnerability
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability_categories**](docs/VulnerabilityApi.md#get_vulnerability_categories) | **GET** /api/3/vulnerability_categories | Categories
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability_category**](docs/VulnerabilityApi.md#get_vulnerability_category) | **GET** /api/3/vulnerability_categories/{id} | Category
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability_category_vulnerabilities**](docs/VulnerabilityApi.md#get_vulnerability_category_vulnerabilities) | **GET** /api/3/vulnerability_categories/{id}/vulnerabilities | Category Vulnerabilities
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability_exploits**](docs/VulnerabilityApi.md#get_vulnerability_exploits) | **GET** /api/3/vulnerabilities/{id}/exploits | Vulnerability Exploits
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability_malware_kits**](docs/VulnerabilityApi.md#get_vulnerability_malware_kits) | **GET** /api/3/vulnerabilities/{id}/malware_kits | Vulnerability Malware Kits
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability_reference**](docs/VulnerabilityApi.md#get_vulnerability_reference) | **GET** /api/3/vulnerability_references/{id} | Reference
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability_reference_vulnerabilities**](docs/VulnerabilityApi.md#get_vulnerability_reference_vulnerabilities) | **GET** /api/3/vulnerability_references/{id}/vulnerabilities | Reference Vulnerabilities
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability_references**](docs/VulnerabilityApi.md#get_vulnerability_references) | **GET** /api/3/vulnerability_references | References
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability_references1**](docs/VulnerabilityApi.md#get_vulnerability_references1) | **GET** /api/3/vulnerabilities/{id}/references | Vulnerability References
*SwaggerClient::VulnerabilityApi* | [**get_vulnerability_solutions**](docs/VulnerabilityApi.md#get_vulnerability_solutions) | **GET** /api/3/vulnerabilities/{id}/solutions | Vulnerability Solutions
*SwaggerClient::VulnerabilityCheckApi* | [**get_vulnerability_check_types**](docs/VulnerabilityCheckApi.md#get_vulnerability_check_types) | **GET** /api/3/vulnerability_checks_types | Check Types
*SwaggerClient::VulnerabilityCheckApi* | [**get_vulnerability_checks**](docs/VulnerabilityCheckApi.md#get_vulnerability_checks) | **GET** /api/3/vulnerability_checks | Checks
*SwaggerClient::VulnerabilityCheckApi* | [**get_vulnerability_checks_for_vulnerability**](docs/VulnerabilityCheckApi.md#get_vulnerability_checks_for_vulnerability) | **GET** /api/3/vulnerabilities/{id}/checks | Vulnerability Checks
*SwaggerClient::VulnerabilityCheckApi* | [**vulnerability_check**](docs/VulnerabilityCheckApi.md#vulnerability_check) | **GET** /api/3/vulnerability_checks/{id} | Check
*SwaggerClient::VulnerabilityExceptionApi* | [**create_vulnerability_exception**](docs/VulnerabilityExceptionApi.md#create_vulnerability_exception) | **POST** /api/3/vulnerability_exceptions | Exceptions
*SwaggerClient::VulnerabilityExceptionApi* | [**get_vulnerability_exception**](docs/VulnerabilityExceptionApi.md#get_vulnerability_exception) | **GET** /api/3/vulnerability_exceptions/{id} | Exception
*SwaggerClient::VulnerabilityExceptionApi* | [**get_vulnerability_exception_expiration**](docs/VulnerabilityExceptionApi.md#get_vulnerability_exception_expiration) | **GET** /api/3/vulnerability_exceptions/{id}/expires | Exception Expiration
*SwaggerClient::VulnerabilityExceptionApi* | [**get_vulnerability_exceptions**](docs/VulnerabilityExceptionApi.md#get_vulnerability_exceptions) | **GET** /api/3/vulnerability_exceptions | Exceptions
*SwaggerClient::VulnerabilityExceptionApi* | [**remove_vulnerability_exception**](docs/VulnerabilityExceptionApi.md#remove_vulnerability_exception) | **DELETE** /api/3/vulnerability_exceptions/{id} | Exception
*SwaggerClient::VulnerabilityExceptionApi* | [**update_vulnerability_exception_expiration**](docs/VulnerabilityExceptionApi.md#update_vulnerability_exception_expiration) | **PUT** /api/3/vulnerability_exceptions/{id}/expires | Exception Expiration
*SwaggerClient::VulnerabilityExceptionApi* | [**update_vulnerability_exception_status**](docs/VulnerabilityExceptionApi.md#update_vulnerability_exception_status) | **POST** /api/3/vulnerability_exceptions/{id}/{status} | Exception Status
*SwaggerClient::VulnerabilityResultApi* | [**create_vulnerability_validation**](docs/VulnerabilityResultApi.md#create_vulnerability_validation) | **POST** /api/3/assets/{id}/vulnerabilities/{vulnerabilityId}/validations | Asset Vulnerability Validations
*SwaggerClient::VulnerabilityResultApi* | [**delete_vulnerability_validation**](docs/VulnerabilityResultApi.md#delete_vulnerability_validation) | **DELETE** /api/3/assets/{id}/vulnerabilities/{vulnerabilityId}/validations/{validationId} | Asset Vulnerability Validation
*SwaggerClient::VulnerabilityResultApi* | [**get_asset_service_vulnerabilities**](docs/VulnerabilityResultApi.md#get_asset_service_vulnerabilities) | **GET** /api/3/assets/{id}/services/{protocol}/{port}/vulnerabilities | Asset Service Vulnerabilities
*SwaggerClient::VulnerabilityResultApi* | [**get_asset_vulnerabilities**](docs/VulnerabilityResultApi.md#get_asset_vulnerabilities) | **GET** /api/3/assets/{id}/vulnerabilities | Asset Vulnerabilities
*SwaggerClient::VulnerabilityResultApi* | [**get_asset_vulnerability**](docs/VulnerabilityResultApi.md#get_asset_vulnerability) | **GET** /api/3/assets/{id}/vulnerabilities/{vulnerabilityId} | Asset Vulnerability
*SwaggerClient::VulnerabilityResultApi* | [**get_vulnerability_validation**](docs/VulnerabilityResultApi.md#get_vulnerability_validation) | **GET** /api/3/assets/{id}/vulnerabilities/{vulnerabilityId}/validations/{validationId} | Asset Vulnerability Validation
*SwaggerClient::VulnerabilityResultApi* | [**get_vulnerability_validations**](docs/VulnerabilityResultApi.md#get_vulnerability_validations) | **GET** /api/3/assets/{id}/vulnerabilities/{vulnerabilityId}/validations | Asset Vulnerability Validations

## Documentation for Models

 - [SwaggerClient::Account](docs/Account.md)
 - [SwaggerClient::AdditionalInformation](docs/AdditionalInformation.md)
 - [SwaggerClient::Address](docs/Address.md)
 - [SwaggerClient::AdhocScan](docs/AdhocScan.md)
 - [SwaggerClient::AdministrationLicenseBody](docs/AdministrationLicenseBody.md)
 - [SwaggerClient::AdvisoryLink](docs/AdvisoryLink.md)
 - [SwaggerClient::Agent](docs/Agent.md)
 - [SwaggerClient::Alert](docs/Alert.md)
 - [SwaggerClient::AssessmentResult](docs/AssessmentResult.md)
 - [SwaggerClient::Asset](docs/Asset.md)
 - [SwaggerClient::AssetCreate](docs/AssetCreate.md)
 - [SwaggerClient::AssetCreatedOrUpdatedReference](docs/AssetCreatedOrUpdatedReference.md)
 - [SwaggerClient::AssetGroup](docs/AssetGroup.md)
 - [SwaggerClient::AssetHistory](docs/AssetHistory.md)
 - [SwaggerClient::AssetPolicy](docs/AssetPolicy.md)
 - [SwaggerClient::AssetPolicyAssessment](docs/AssetPolicyAssessment.md)
 - [SwaggerClient::AssetPolicyItem](docs/AssetPolicyItem.md)
 - [SwaggerClient::AssetTag](docs/AssetTag.md)
 - [SwaggerClient::AssetVulnerabilities](docs/AssetVulnerabilities.md)
 - [SwaggerClient::AuthenticationSettings](docs/AuthenticationSettings.md)
 - [SwaggerClient::AuthenticationSource](docs/AuthenticationSource.md)
 - [SwaggerClient::AvailableReportFormat](docs/AvailableReportFormat.md)
 - [SwaggerClient::BackupsSize](docs/BackupsSize.md)
 - [SwaggerClient::BadRequestError](docs/BadRequestError.md)
 - [SwaggerClient::CPUInfo](docs/CPUInfo.md)
 - [SwaggerClient::Configuration](docs/Configuration.md)
 - [SwaggerClient::ConsoleCommandOutput](docs/ConsoleCommandOutput.md)
 - [SwaggerClient::ContentDescription](docs/ContentDescription.md)
 - [SwaggerClient::CreateAuthenticationSource](docs/CreateAuthenticationSource.md)
 - [SwaggerClient::CreatedOrUpdatedReference](docs/CreatedOrUpdatedReference.md)
 - [SwaggerClient::CreatedReference](docs/CreatedReference.md)
 - [SwaggerClient::CreatedReferenceAssetGroupIDLink](docs/CreatedReferenceAssetGroupIDLink.md)
 - [SwaggerClient::CreatedReferenceCredentialIDLink](docs/CreatedReferenceCredentialIDLink.md)
 - [SwaggerClient::CreatedReferenceDiscoveryQueryIDLink](docs/CreatedReferenceDiscoveryQueryIDLink.md)
 - [SwaggerClient::CreatedReferenceEngineIDLink](docs/CreatedReferenceEngineIDLink.md)
 - [SwaggerClient::CreatedReferencePolicyOverrideIDLink](docs/CreatedReferencePolicyOverrideIDLink.md)
 - [SwaggerClient::CreatedReferenceScanIDLink](docs/CreatedReferenceScanIDLink.md)
 - [SwaggerClient::CreatedReferenceScanTemplateIDLink](docs/CreatedReferenceScanTemplateIDLink.md)
 - [SwaggerClient::CreatedReferenceUserIDLink](docs/CreatedReferenceUserIDLink.md)
 - [SwaggerClient::CreatedReferenceVulnerabilityExceptionIDLink](docs/CreatedReferenceVulnerabilityExceptionIDLink.md)
 - [SwaggerClient::CreatedReferenceVulnerabilityValidationIDLink](docs/CreatedReferenceVulnerabilityValidationIDLink.md)
 - [SwaggerClient::CreatedReferenceintLink](docs/CreatedReferenceintLink.md)
 - [SwaggerClient::Criterion](docs/Criterion.md)
 - [SwaggerClient::Database](docs/Database.md)
 - [SwaggerClient::DatabaseConnectionSettings](docs/DatabaseConnectionSettings.md)
 - [SwaggerClient::DatabaseSettings](docs/DatabaseSettings.md)
 - [SwaggerClient::DatabaseSize](docs/DatabaseSize.md)
 - [SwaggerClient::DiscoveryAsset](docs/DiscoveryAsset.md)
 - [SwaggerClient::DiscoveryConnection](docs/DiscoveryConnection.md)
 - [SwaggerClient::DiscoverySearchCriteria](docs/DiscoverySearchCriteria.md)
 - [SwaggerClient::DiskFree](docs/DiskFree.md)
 - [SwaggerClient::DiskInfo](docs/DiskInfo.md)
 - [SwaggerClient::DiskTotal](docs/DiskTotal.md)
 - [SwaggerClient::DynamicSite](docs/DynamicSite.md)
 - [SwaggerClient::EngineID](docs/EngineID.md)
 - [SwaggerClient::EnginePool](docs/EnginePool.md)
 - [SwaggerClient::EnvironmentProperties](docs/EnvironmentProperties.md)
 - [SwaggerClient::Error](docs/Error.md)
 - [SwaggerClient::ExceptionScope](docs/ExceptionScope.md)
 - [SwaggerClient::ExcludedAssetGroups](docs/ExcludedAssetGroups.md)
 - [SwaggerClient::ExcludedScanTargets](docs/ExcludedScanTargets.md)
 - [SwaggerClient::Exploit](docs/Exploit.md)
 - [SwaggerClient::ExploitSource](docs/ExploitSource.md)
 - [SwaggerClient::ExploitSourceLink](docs/ExploitSourceLink.md)
 - [SwaggerClient::Features](docs/Features.md)
 - [SwaggerClient::File](docs/File.md)
 - [SwaggerClient::Fingerprint](docs/Fingerprint.md)
 - [SwaggerClient::GlobalScan](docs/GlobalScan.md)
 - [SwaggerClient::GroupAccount](docs/GroupAccount.md)
 - [SwaggerClient::HostName](docs/HostName.md)
 - [SwaggerClient::IMetaData](docs/IMetaData.md)
 - [SwaggerClient::IncludedAssetGroups](docs/IncludedAssetGroups.md)
 - [SwaggerClient::IncludedScanTargets](docs/IncludedScanTargets.md)
 - [SwaggerClient::Info](docs/Info.md)
 - [SwaggerClient::InstallSize](docs/InstallSize.md)
 - [SwaggerClient::InstallationTotalSize](docs/InstallationTotalSize.md)
 - [SwaggerClient::InternalServerError](docs/InternalServerError.md)
 - [SwaggerClient::JVMInfo](docs/JVMInfo.md)
 - [SwaggerClient::JsonNode](docs/JsonNode.md)
 - [SwaggerClient::License](docs/License.md)
 - [SwaggerClient::LicenseLimits](docs/LicenseLimits.md)
 - [SwaggerClient::LicensePolicyScanning](docs/LicensePolicyScanning.md)
 - [SwaggerClient::LicensePolicyScanningBenchmarks](docs/LicensePolicyScanningBenchmarks.md)
 - [SwaggerClient::LicenseReporting](docs/LicenseReporting.md)
 - [SwaggerClient::LicenseScanning](docs/LicenseScanning.md)
 - [SwaggerClient::Link](docs/Link.md)
 - [SwaggerClient::Links](docs/Links.md)
 - [SwaggerClient::LocalePreferences](docs/LocalePreferences.md)
 - [SwaggerClient::MalwareKit](docs/MalwareKit.md)
 - [SwaggerClient::MatchedSolution](docs/MatchedSolution.md)
 - [SwaggerClient::MemoryFree](docs/MemoryFree.md)
 - [SwaggerClient::MemoryInfo](docs/MemoryInfo.md)
 - [SwaggerClient::MemoryTotal](docs/MemoryTotal.md)
 - [SwaggerClient::NotFoundError](docs/NotFoundError.md)
 - [SwaggerClient::OperatingSystem](docs/OperatingSystem.md)
 - [SwaggerClient::OperatingSystemCpe](docs/OperatingSystemCpe.md)
 - [SwaggerClient::PCI](docs/PCI.md)
 - [SwaggerClient::PageInfo](docs/PageInfo.md)
 - [SwaggerClient::PageOfAgent](docs/PageOfAgent.md)
 - [SwaggerClient::PageOfAsset](docs/PageOfAsset.md)
 - [SwaggerClient::PageOfAssetGroup](docs/PageOfAssetGroup.md)
 - [SwaggerClient::PageOfAssetPolicy](docs/PageOfAssetPolicy.md)
 - [SwaggerClient::PageOfAssetPolicyItem](docs/PageOfAssetPolicyItem.md)
 - [SwaggerClient::PageOfDiscoveryConnection](docs/PageOfDiscoveryConnection.md)
 - [SwaggerClient::PageOfExploit](docs/PageOfExploit.md)
 - [SwaggerClient::PageOfGlobalScan](docs/PageOfGlobalScan.md)
 - [SwaggerClient::PageOfMalwareKit](docs/PageOfMalwareKit.md)
 - [SwaggerClient::PageOfOperatingSystem](docs/PageOfOperatingSystem.md)
 - [SwaggerClient::PageOfPolicy](docs/PageOfPolicy.md)
 - [SwaggerClient::PageOfPolicyAsset](docs/PageOfPolicyAsset.md)
 - [SwaggerClient::PageOfPolicyControl](docs/PageOfPolicyControl.md)
 - [SwaggerClient::PageOfPolicyGroup](docs/PageOfPolicyGroup.md)
 - [SwaggerClient::PageOfPolicyItem](docs/PageOfPolicyItem.md)
 - [SwaggerClient::PageOfPolicyOverride](docs/PageOfPolicyOverride.md)
 - [SwaggerClient::PageOfPolicyRule](docs/PageOfPolicyRule.md)
 - [SwaggerClient::PageOfReport](docs/PageOfReport.md)
 - [SwaggerClient::PageOfScan](docs/PageOfScan.md)
 - [SwaggerClient::PageOfSite](docs/PageOfSite.md)
 - [SwaggerClient::PageOfSoftware](docs/PageOfSoftware.md)
 - [SwaggerClient::PageOfTag](docs/PageOfTag.md)
 - [SwaggerClient::PageOfUser](docs/PageOfUser.md)
 - [SwaggerClient::PageOfVulnerability](docs/PageOfVulnerability.md)
 - [SwaggerClient::PageOfVulnerabilityCategory](docs/PageOfVulnerabilityCategory.md)
 - [SwaggerClient::PageOfVulnerabilityCheck](docs/PageOfVulnerabilityCheck.md)
 - [SwaggerClient::PageOfVulnerabilityException](docs/PageOfVulnerabilityException.md)
 - [SwaggerClient::PageOfVulnerabilityFinding](docs/PageOfVulnerabilityFinding.md)
 - [SwaggerClient::PageOfVulnerabilityReference](docs/PageOfVulnerabilityReference.md)
 - [SwaggerClient::PasswordResource](docs/PasswordResource.md)
 - [SwaggerClient::Policy](docs/Policy.md)
 - [SwaggerClient::PolicyAsset](docs/PolicyAsset.md)
 - [SwaggerClient::PolicyBenchmark](docs/PolicyBenchmark.md)
 - [SwaggerClient::PolicyControl](docs/PolicyControl.md)
 - [SwaggerClient::PolicyGroup](docs/PolicyGroup.md)
 - [SwaggerClient::PolicyItem](docs/PolicyItem.md)
 - [SwaggerClient::PolicyMetadataResource](docs/PolicyMetadataResource.md)
 - [SwaggerClient::PolicyOverride](docs/PolicyOverride.md)
 - [SwaggerClient::PolicyOverrideReviewer](docs/PolicyOverrideReviewer.md)
 - [SwaggerClient::PolicyOverrideScope](docs/PolicyOverrideScope.md)
 - [SwaggerClient::PolicyOverrideSubmitter](docs/PolicyOverrideSubmitter.md)
 - [SwaggerClient::PolicyRule](docs/PolicyRule.md)
 - [SwaggerClient::PolicyRuleAssessmentResource](docs/PolicyRuleAssessmentResource.md)
 - [SwaggerClient::PolicySummaryResource](docs/PolicySummaryResource.md)
 - [SwaggerClient::Privileges](docs/Privileges.md)
 - [SwaggerClient::RangeResource](docs/RangeResource.md)
 - [SwaggerClient::ReferenceWithAlertIDLink](docs/ReferenceWithAlertIDLink.md)
 - [SwaggerClient::ReferenceWithAssetIDLink](docs/ReferenceWithAssetIDLink.md)
 - [SwaggerClient::ReferenceWithEndpointIDLink](docs/ReferenceWithEndpointIDLink.md)
 - [SwaggerClient::ReferenceWithEngineIDLink](docs/ReferenceWithEngineIDLink.md)
 - [SwaggerClient::ReferenceWithReportIDLink](docs/ReferenceWithReportIDLink.md)
 - [SwaggerClient::ReferenceWithScanScheduleIDLink](docs/ReferenceWithScanScheduleIDLink.md)
 - [SwaggerClient::ReferenceWithSiteIDLink](docs/ReferenceWithSiteIDLink.md)
 - [SwaggerClient::ReferenceWithTagIDLink](docs/ReferenceWithTagIDLink.md)
 - [SwaggerClient::ReferenceWithUserIDLink](docs/ReferenceWithUserIDLink.md)
 - [SwaggerClient::ReferencesWithAssetGroupIDLink](docs/ReferencesWithAssetGroupIDLink.md)
 - [SwaggerClient::ReferencesWithAssetIDLink](docs/ReferencesWithAssetIDLink.md)
 - [SwaggerClient::ReferencesWithEngineIDLink](docs/ReferencesWithEngineIDLink.md)
 - [SwaggerClient::ReferencesWithReferenceWithEndpointIDLinkServiceLink](docs/ReferencesWithReferenceWithEndpointIDLinkServiceLink.md)
 - [SwaggerClient::ReferencesWithSiteIDLink](docs/ReferencesWithSiteIDLink.md)
 - [SwaggerClient::ReferencesWithSolutionNaturalIDLink](docs/ReferencesWithSolutionNaturalIDLink.md)
 - [SwaggerClient::ReferencesWithTagIDLink](docs/ReferencesWithTagIDLink.md)
 - [SwaggerClient::ReferencesWithUserIDLink](docs/ReferencesWithUserIDLink.md)
 - [SwaggerClient::ReferencesWithVulnerabilityCheckIDLink](docs/ReferencesWithVulnerabilityCheckIDLink.md)
 - [SwaggerClient::ReferencesWithVulnerabilityCheckTypeIDLink](docs/ReferencesWithVulnerabilityCheckTypeIDLink.md)
 - [SwaggerClient::ReferencesWithVulnerabilityNaturalIDLink](docs/ReferencesWithVulnerabilityNaturalIDLink.md)
 - [SwaggerClient::ReferencesWithWebApplicationIDLink](docs/ReferencesWithWebApplicationIDLink.md)
 - [SwaggerClient::RemediationResource](docs/RemediationResource.md)
 - [SwaggerClient::Repeat](docs/Repeat.md)
 - [SwaggerClient::Report](docs/Report.md)
 - [SwaggerClient::ReportConfigCategoryFilters](docs/ReportConfigCategoryFilters.md)
 - [SwaggerClient::ReportConfigFiltersResource](docs/ReportConfigFiltersResource.md)
 - [SwaggerClient::ReportConfigScopeResource](docs/ReportConfigScopeResource.md)
 - [SwaggerClient::ReportEmail](docs/ReportEmail.md)
 - [SwaggerClient::ReportEmailSmtp](docs/ReportEmailSmtp.md)
 - [SwaggerClient::ReportFilters](docs/ReportFilters.md)
 - [SwaggerClient::ReportFrequency](docs/ReportFrequency.md)
 - [SwaggerClient::ReportInstance](docs/ReportInstance.md)
 - [SwaggerClient::ReportRepeat](docs/ReportRepeat.md)
 - [SwaggerClient::ReportScope](docs/ReportScope.md)
 - [SwaggerClient::ReportSize](docs/ReportSize.md)
 - [SwaggerClient::ReportStorage](docs/ReportStorage.md)
 - [SwaggerClient::ReportTemplate](docs/ReportTemplate.md)
 - [SwaggerClient::ResourcesAlert](docs/ResourcesAlert.md)
 - [SwaggerClient::ResourcesAssetGroup](docs/ResourcesAssetGroup.md)
 - [SwaggerClient::ResourcesAssetTag](docs/ResourcesAssetTag.md)
 - [SwaggerClient::ResourcesAuthenticationSource](docs/ResourcesAuthenticationSource.md)
 - [SwaggerClient::ResourcesAvailableReportFormat](docs/ResourcesAvailableReportFormat.md)
 - [SwaggerClient::ResourcesConfiguration](docs/ResourcesConfiguration.md)
 - [SwaggerClient::ResourcesDatabase](docs/ResourcesDatabase.md)
 - [SwaggerClient::ResourcesDiscoveryAsset](docs/ResourcesDiscoveryAsset.md)
 - [SwaggerClient::ResourcesEnginePool](docs/ResourcesEnginePool.md)
 - [SwaggerClient::ResourcesFile](docs/ResourcesFile.md)
 - [SwaggerClient::ResourcesGroupAccount](docs/ResourcesGroupAccount.md)
 - [SwaggerClient::ResourcesMatchedSolution](docs/ResourcesMatchedSolution.md)
 - [SwaggerClient::ResourcesPolicyOverride](docs/ResourcesPolicyOverride.md)
 - [SwaggerClient::ResourcesReportInstance](docs/ResourcesReportInstance.md)
 - [SwaggerClient::ResourcesReportTemplate](docs/ResourcesReportTemplate.md)
 - [SwaggerClient::ResourcesRole](docs/ResourcesRole.md)
 - [SwaggerClient::ResourcesScanEngine](docs/ResourcesScanEngine.md)
 - [SwaggerClient::ResourcesScanSchedule](docs/ResourcesScanSchedule.md)
 - [SwaggerClient::ResourcesScanTemplate](docs/ResourcesScanTemplate.md)
 - [SwaggerClient::ResourcesSharedCredential](docs/ResourcesSharedCredential.md)
 - [SwaggerClient::ResourcesSiteCredential](docs/ResourcesSiteCredential.md)
 - [SwaggerClient::ResourcesSiteSharedCredential](docs/ResourcesSiteSharedCredential.md)
 - [SwaggerClient::ResourcesSmtpAlert](docs/ResourcesSmtpAlert.md)
 - [SwaggerClient::ResourcesSnmpAlert](docs/ResourcesSnmpAlert.md)
 - [SwaggerClient::ResourcesSoftware](docs/ResourcesSoftware.md)
 - [SwaggerClient::ResourcesSolution](docs/ResourcesSolution.md)
 - [SwaggerClient::ResourcesSonarQuery](docs/ResourcesSonarQuery.md)
 - [SwaggerClient::ResourcesSyslogAlert](docs/ResourcesSyslogAlert.md)
 - [SwaggerClient::ResourcesTag](docs/ResourcesTag.md)
 - [SwaggerClient::ResourcesUser](docs/ResourcesUser.md)
 - [SwaggerClient::ResourcesUserAccount](docs/ResourcesUserAccount.md)
 - [SwaggerClient::ResourcesVulnerabilityValidationResource](docs/ResourcesVulnerabilityValidationResource.md)
 - [SwaggerClient::ResourcesWebFormAuthentication](docs/ResourcesWebFormAuthentication.md)
 - [SwaggerClient::ResourcesWebHeaderAuthentication](docs/ResourcesWebHeaderAuthentication.md)
 - [SwaggerClient::Review](docs/Review.md)
 - [SwaggerClient::RiskModifierSettings](docs/RiskModifierSettings.md)
 - [SwaggerClient::RiskSettings](docs/RiskSettings.md)
 - [SwaggerClient::RiskTrendAllAssetsResource](docs/RiskTrendAllAssetsResource.md)
 - [SwaggerClient::RiskTrendResource](docs/RiskTrendResource.md)
 - [SwaggerClient::Role](docs/Role.md)
 - [SwaggerClient::Scan](docs/Scan.md)
 - [SwaggerClient::ScanEngine](docs/ScanEngine.md)
 - [SwaggerClient::ScanEvents](docs/ScanEvents.md)
 - [SwaggerClient::ScanSchedule](docs/ScanSchedule.md)
 - [SwaggerClient::ScanScope](docs/ScanScope.md)
 - [SwaggerClient::ScanSettings](docs/ScanSettings.md)
 - [SwaggerClient::ScanSize](docs/ScanSize.md)
 - [SwaggerClient::ScanTargetsResource](docs/ScanTargetsResource.md)
 - [SwaggerClient::ScanTemplate](docs/ScanTemplate.md)
 - [SwaggerClient::ScanTemplateAssetDiscovery](docs/ScanTemplateAssetDiscovery.md)
 - [SwaggerClient::ScanTemplateDatabase](docs/ScanTemplateDatabase.md)
 - [SwaggerClient::ScanTemplateDiscovery](docs/ScanTemplateDiscovery.md)
 - [SwaggerClient::ScanTemplateDiscoveryPerformance](docs/ScanTemplateDiscoveryPerformance.md)
 - [SwaggerClient::ScanTemplateDiscoveryPerformancePacketsRate](docs/ScanTemplateDiscoveryPerformancePacketsRate.md)
 - [SwaggerClient::ScanTemplateDiscoveryPerformanceParallelism](docs/ScanTemplateDiscoveryPerformanceParallelism.md)
 - [SwaggerClient::ScanTemplateDiscoveryPerformanceScanDelay](docs/ScanTemplateDiscoveryPerformanceScanDelay.md)
 - [SwaggerClient::ScanTemplateDiscoveryPerformanceTimeout](docs/ScanTemplateDiscoveryPerformanceTimeout.md)
 - [SwaggerClient::ScanTemplateServiceDiscovery](docs/ScanTemplateServiceDiscovery.md)
 - [SwaggerClient::ScanTemplateServiceDiscoveryTcp](docs/ScanTemplateServiceDiscoveryTcp.md)
 - [SwaggerClient::ScanTemplateServiceDiscoveryUdp](docs/ScanTemplateServiceDiscoveryUdp.md)
 - [SwaggerClient::ScanTemplateVulnerabilityCheckCategories](docs/ScanTemplateVulnerabilityCheckCategories.md)
 - [SwaggerClient::ScanTemplateVulnerabilityCheckIndividual](docs/ScanTemplateVulnerabilityCheckIndividual.md)
 - [SwaggerClient::ScanTemplateVulnerabilityChecks](docs/ScanTemplateVulnerabilityChecks.md)
 - [SwaggerClient::ScanTemplateWebSpider](docs/ScanTemplateWebSpider.md)
 - [SwaggerClient::ScanTemplateWebSpiderPaths](docs/ScanTemplateWebSpiderPaths.md)
 - [SwaggerClient::ScanTemplateWebSpiderPatterns](docs/ScanTemplateWebSpiderPatterns.md)
 - [SwaggerClient::ScanTemplateWebSpiderPerformance](docs/ScanTemplateWebSpiderPerformance.md)
 - [SwaggerClient::ScheduledScanTargets](docs/ScheduledScanTargets.md)
 - [SwaggerClient::SearchCriteria](docs/SearchCriteria.md)
 - [SwaggerClient::Service](docs/Service.md)
 - [SwaggerClient::ServiceLink](docs/ServiceLink.md)
 - [SwaggerClient::ServiceUnavailableError](docs/ServiceUnavailableError.md)
 - [SwaggerClient::Settings](docs/Settings.md)
 - [SwaggerClient::SharedCredential](docs/SharedCredential.md)
 - [SwaggerClient::SharedCredentialAccount](docs/SharedCredentialAccount.md)
 - [SwaggerClient::Site](docs/Site.md)
 - [SwaggerClient::SiteCreateResource](docs/SiteCreateResource.md)
 - [SwaggerClient::SiteCredential](docs/SiteCredential.md)
 - [SwaggerClient::SiteDiscoveryConnection](docs/SiteDiscoveryConnection.md)
 - [SwaggerClient::SiteOrganization](docs/SiteOrganization.md)
 - [SwaggerClient::SiteSharedCredential](docs/SiteSharedCredential.md)
 - [SwaggerClient::SiteUpdateResource](docs/SiteUpdateResource.md)
 - [SwaggerClient::SmtpAlert](docs/SmtpAlert.md)
 - [SwaggerClient::SmtpSettings](docs/SmtpSettings.md)
 - [SwaggerClient::SnmpAlert](docs/SnmpAlert.md)
 - [SwaggerClient::Software](docs/Software.md)
 - [SwaggerClient::SoftwareCpe](docs/SoftwareCpe.md)
 - [SwaggerClient::Solution](docs/Solution.md)
 - [SwaggerClient::SolutionMatch](docs/SolutionMatch.md)
 - [SwaggerClient::SonarCriteria](docs/SonarCriteria.md)
 - [SwaggerClient::SonarCriterion](docs/SonarCriterion.md)
 - [SwaggerClient::SonarQuery](docs/SonarQuery.md)
 - [SwaggerClient::StaticSite](docs/StaticSite.md)
 - [SwaggerClient::Steps](docs/Steps.md)
 - [SwaggerClient::Submission](docs/Submission.md)
 - [SwaggerClient::Summary](docs/Summary.md)
 - [SwaggerClient::SwaggerDiscoverySearchCriteriaFilter](docs/SwaggerDiscoverySearchCriteriaFilter.md)
 - [SwaggerClient::SwaggerSearchCriteriaFilter](docs/SwaggerSearchCriteriaFilter.md)
 - [SwaggerClient::SyslogAlert](docs/SyslogAlert.md)
 - [SwaggerClient::Tag](docs/Tag.md)
 - [SwaggerClient::TagAssetSource](docs/TagAssetSource.md)
 - [SwaggerClient::TagLink](docs/TagLink.md)
 - [SwaggerClient::TaggedAssetReferences](docs/TaggedAssetReferences.md)
 - [SwaggerClient::Telnet](docs/Telnet.md)
 - [SwaggerClient::TokenResource](docs/TokenResource.md)
 - [SwaggerClient::UnauthorizedError](docs/UnauthorizedError.md)
 - [SwaggerClient::UniqueId](docs/UniqueId.md)
 - [SwaggerClient::UpdateId](docs/UpdateId.md)
 - [SwaggerClient::UpdateInfo](docs/UpdateInfo.md)
 - [SwaggerClient::UpdateSettings](docs/UpdateSettings.md)
 - [SwaggerClient::User](docs/User.md)
 - [SwaggerClient::UserAccount](docs/UserAccount.md)
 - [SwaggerClient::UserCreateRole](docs/UserCreateRole.md)
 - [SwaggerClient::UserEdit](docs/UserEdit.md)
 - [SwaggerClient::UserRole](docs/UserRole.md)
 - [SwaggerClient::VersionInfo](docs/VersionInfo.md)
 - [SwaggerClient::Vulnerabilities](docs/Vulnerabilities.md)
 - [SwaggerClient::Vulnerability](docs/Vulnerability.md)
 - [SwaggerClient::VulnerabilityCategory](docs/VulnerabilityCategory.md)
 - [SwaggerClient::VulnerabilityCheck](docs/VulnerabilityCheck.md)
 - [SwaggerClient::VulnerabilityCheckType](docs/VulnerabilityCheckType.md)
 - [SwaggerClient::VulnerabilityCvss](docs/VulnerabilityCvss.md)
 - [SwaggerClient::VulnerabilityCvssV2](docs/VulnerabilityCvssV2.md)
 - [SwaggerClient::VulnerabilityCvssV3](docs/VulnerabilityCvssV3.md)
 - [SwaggerClient::VulnerabilityEvents](docs/VulnerabilityEvents.md)
 - [SwaggerClient::VulnerabilityException](docs/VulnerabilityException.md)
 - [SwaggerClient::VulnerabilityFinding](docs/VulnerabilityFinding.md)
 - [SwaggerClient::VulnerabilityReference](docs/VulnerabilityReference.md)
 - [SwaggerClient::VulnerabilityValidationResource](docs/VulnerabilityValidationResource.md)
 - [SwaggerClient::VulnerabilityValidationSource](docs/VulnerabilityValidationSource.md)
 - [SwaggerClient::WebApplication](docs/WebApplication.md)
 - [SwaggerClient::WebFormAuthentication](docs/WebFormAuthentication.md)
 - [SwaggerClient::WebHeaderAuthentication](docs/WebHeaderAuthentication.md)
 - [SwaggerClient::WebPage](docs/WebPage.md)
 - [SwaggerClient::WebSettings](docs/WebSettings.md)

## Documentation for Authorization


### Basic

- **Type**: HTTP basic authentication

