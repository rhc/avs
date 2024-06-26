# SwaggerClient::ScanSchedule

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**assets** | [**ScheduledScanTargets**](ScheduledScanTargets.md) |  | [optional] 
**duration** | **String** | Specifies the maximum duration the scheduled scan is allowed to run. Scheduled scans that do not complete within specified duration will be paused. The scan duration are represented by the format &#x60;\&quot;P[n]DT[n]H[n]M\&quot;&#x60;. In these representations, the [n] is replaced by a value for each of the date and time elements that follow the [n].The following table describes each supported value:  | Value | Description |  | ---------- | ---------------- |  | P | The duration designator. It must be placed at the start of the duration representation. |  | D | The day designator that follows the value for the number of days. |  | T | The time designator that precedes the time portion of the representation. |  | H | The hour designator that follows the value for the number of hours. |  | M | The minute designator that follows the value for the number of minutes. |  For example, &#x60;\&quot;P5DT10H30M\&quot;&#x60; represents a duration of \&quot;5 days, 10 hours, and 30 minutes\&quot;. Each duration designator is optional; however, at least one must be specified and it must be preceded by the &#x60;\&quot;P\&quot;&#x60; designator.   | [optional] 
**enabled** | **BOOLEAN** | Flag indicating whether the scan schedule is enabled. | 
**id** | **Integer** | The identifier of the scan schedule. | [optional] 
**links** | [**Array&lt;Link&gt;**](Link.md) |  | [optional] 
**next_runtimes** | **Array&lt;String&gt;** | List the next 10 dates in the future the schedule will launch.  | [optional] 
**on_scan_repeat** | **String** | Specifies the desired behavior of a repeating scheduled scan when the previous scan was paused due to reaching is maximum duration. The following table describes each supported value:  | Value | Description |  | ---------- | ---------------- |  | restart-scan | Stops the previously-paused scan and launches a new scan if the previous scan did not complete within the specified duration. If the previous scheduled scan was not paused, then a new scan is launched. |  | resume-scan | Resumes the previously-paused scan if the previous scan did not complete within the specified duration. If the previous scheduled scan was not paused, then a new scan is launched. |   | 
**repeat** | [**Repeat**](Repeat.md) |  | [optional] 
**scan_engine_id** | **Integer** | The identifier of the scan engine to be used for this scan schedule. If not set, the site&#x27;s assigned scan engine will be used. | [optional] 
**scan_name** | **String** | A user-defined name for the scan launched by the schedule. If not explicitly set in the schedule, the scan name will be generated prior to the scan launching. Scan names must be unique within the site&#x27;s scan schedules. | [optional] 
**scan_template_id** | **String** | The identifier of the scan template to be used for this scan schedule. If not set, the site&#x27;s assigned scan template will be used. | [optional] 
**start** | **String** | The scheduled start date and time. Date is represented in ISO 8601 format. Repeating schedules will determine the next schedule to begin based on this date and time. | 

