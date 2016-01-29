# Guide to publishing pixel-tracking tag

There are a number of cases where it is useful to send data into Snowplow using a pixel-tracking tag. This is effectively a static html `<img />` tag that fetches the 1x1 pixel served by your Snowplow collector and manually passes the different data points describing the event that we wish to track on the image pixel query string. (If we were implementing a standard Snowplow tracker, it would take care of assembling the image request with the relevant querystring parameters itself for us.) Two common examples where pixel trackers are used are:

1. Tracking email open events
2. Tracking ad impression events

## Generating a pixel: an example for tracking ad impressions

We're going to walk through the process of generating our pixel tracking tag with a real-world example: we want to put together a pixel that records an ad impression event. 

The ad impression event is going to be recorded as a [custom structured event][custom-structured-event] with an event category (`se_category`) set to 'ad' and the event action (`se_action`) set to 'impression'. An [ad_context] [ad-context] will be sent with the event that records all the interesting fields related to the ad that has been viewed. The schema for the ad context can be found [here] [ad-context].

As we walk through this example, our main reference will be the [Snowplow Tracker Protocol] [snowplow-tracker-protocol]. This defines the format that the request must adhere to to be valid.

## 1. Start with our basic image pixel tag

Let's start with a basic image tag that simply gets the pixel from the Snowplow collector:

```html
<img src="https://d.hodes.com/i" />
```

## 2. Add paramters for the required fields

We need to add three required parameters to the request:

1. The tracker version `v_tracker` - set using the `tv` parameter
2. The `platform` set using the `p` parameter
3. The `event` name parameter set using the `e` parameter

For the tracker version, we can set this to any string value. Let's set it to `pixel_tracker`.

For the platform, this needs to be one of the six values listed in the [tracker protocol] (https://github.com/snowplow/snowplow/wiki/snowplow-tracker-protocol#1-common-parameters-platform-and-event-independent). Let's set it to `web`.

For the event name - we want to record our event as a custom structured event, so this needs to be set to `se`. (You can view a list of valid values on the [tracker protocol doc](/snowplow/wiki/snowplow-tracker-protocol#3-snowplow-events)).

That gives us the following pixel:

 ```html
<img src="https://d.hodes.com/i?tv=pixel_tracker&p=web&e=se" />
```

## 3. Add our custom structured event parameters

We can set up to five differnet fields when we record [custom structured events](https://github.com/snowplow/snowplow/wiki/snowplow-tracker-protocol#event). In this example we only want to set the category and action.

We set the category using the `se_ca` parameter, and make this `ad`.

We set the action using the `se_ac` parameter, and make this `impression`.

This gives us the following tag:

 ```html
<img src="https://d.hodes.com/i?tv=pixel_tracker&p=web&e=se&se_ca=ad&se_ac=impression" />
```

## 4. Add the custom context

With any Snowplow event, you can send an array of custom contexts. In this example, we're only going to send a single context: the [ad_context] [ad-context].

First, let's create our self-describing contexts json. Note that we are not going to hardcode the values of the different fields in the JSON - instead we'll use the liquid templating provided by the Sizmek ad server:

```json
{
	"schema": "iglu:com.snowplowanalytics.snowplow/contexts/jsonschema/1-0-0",
	"data": [
		{
			"schema": "iglu:com.findly/ad_context/jsonschema/1-0-0",
			"data": {
				"campaignName": {{campaignName}},
				"publisherName": {{publisherName}},
				"sectionName": {{sectionName}},
				"placementName": {{placementName}},
				"placementClassification1": {{placementClassification1}},
				"placementClassification2": {{placementClassification2}},
				"placementClassification3": {{placementClassification3}},
				"placementClassification4": {{placementClassification4}},
				"placementClassification5": {{placementClassification5}},
				"adName": {{adName}},
				"adClassification1": {{adClassification1}},
				"adClassification2": {{adClassification2}},
				"adClassification3": {{adClassification3}},
				"adClassification4": {{adClassification4}},
				"adClassification5": {{adClassification5}},
				"adFormat": {{adFormat}},
				"campaignId": {{campaignId}},
				"placementId": {{placementId}},
				"adId": {{adId}},
				"keywordId": {{keywordId}},
				"isClick": {{isClick}},
				"userId": {{userId}},
				"lineId": {{lineId}},
				"siteId": {{siteId}},
				"versionId": {{versionId}},
				"versionIdsonAd": {{versionIdsonAd}},
				"advertiserName": {{advertiserName}},
				"advertiserId": {{advertiserId}}
			}
		}
	]
}
```

Now we need to append the above JSON to the image tag on the co query string. Before we do that, though, we need to:

1. Remove the whitespace
2. URL encode the JSOn

Let's start by removing the whitespace:

```json
%7B"schema":"iglu:com.snowplowanalytics.snowplow/contexts/jsonschema/1-0-0","data":[%7B"schema":"iglu:com.findly/ad_context/jsonschema/1-0-0","data":%7B"campaignName":{{campaignName}},"publisherName":{{publisherName}},"sectionName":{{sectionName}},"placementName":{{placementName}},"placementClassification1":{{placementClassification1}},"placementClassification2":{{placementClassification2}},"placementClassification3":{{placementClassification3}},"placementClassification4":{{placementClassification4}},"placementClassification5":{{placementClassification5}},"adName":{{adName}},"adClassification1":{{adClassification1}},"adClassification2":{{adClassification2}},"adClassification3":{{adClassification3}},"adClassification4":{{adClassification4}},"adClassification5":{{adClassification5}},"adFormat":{{adFormat}},"campaignId":{{campaignId}},"placementId":{{placementId}},"adId":{{adId}},"keywordId":{{keywordId}},"isClick":{{isClick}},"userId":{{userId}},"lineId":{{lineId}},"siteId":{{siteId}},"versionId":{{versionId}},"versionIdsonAd":{{versionIdsonAd}},"advertiserName":{{advertiserName}},"advertiserId":{{advertiserId}}}}]%7D
```

Now let's URL encode the tag. Note that we need to URL encode the curly braces for the JSON, but leave the double curly braces used in the liquid templating tag. That leaves us with:


```json
%7B"schema":"iglu:com.snowplowanalytics.snowplow/contexts/jsonschema/1-0-0","data":[%7B"schema":"iglu:com.findly/ad_context/jsonschema/1-0-0","data":%7B"campaignName":{{campaignName}},"publisherName":{{publisherName}},"sectionName":{{sectionName}},"placementName":{{placementName}},"placementClassification1":{{placementClassification1}},"placementClassification2":{{placementClassification2}},"placementClassification3":{{placementClassification3}},"placementClassification4":{{placementClassification4}},"placementClassification5":{{placementClassification5}},"adName":{{adName}},"adClassification1":{{adClassification1}},"adClassification2":{{adClassification2}},"adClassification3":{{adClassification3}},"adClassification4":{{adClassification4}},"adClassification5":{{adClassification5}},"adFormat":{{adFormat}},"campaignId":{{campaignId}},"placementId":{{placementId}},"adId":{{adId}},"keywordId":{{keywordId}},"isClick":{{isClick}},"userId":{{userId}},"lineId":{{lineId}},"siteId":{{siteId}},"versionId":{{versionId}},"versionIdsonAd":{{versionIdsonAd}},"advertiserName":{{advertiserName}},"advertiserId":{{advertiserId}}%7D%7D]%7D
```

Finally we append the above JSON onto our tag:

```html
<img src="https://d.hodes.com/i?tv=pixel_tracker&p=web&e=se&se_ca=ad&se_ac=impression&co=%7B"schema":"iglu:com.snowplowanalytics.snowplow/contexts/jsonschema/1-0-0","data":[%7B"schema":"iglu:com.findly/ad_context/jsonschema/1-0-0","data":%7B"campaignName":{{campaignName}},"publisherName":{{publisherName}},"sectionName":{{sectionName}},"placementName":{{placementName}},"placementClassification1":{{placementClassification1}},"placementClassification2":{{placementClassification2}},"placementClassification3":{{placementClassification3}},"placementClassification4":{{placementClassification4}},"placementClassification5":{{placementClassification5}},"adName":{{adName}},"adClassification1":{{adClassification1}},"adClassification2":{{adClassification2}},"adClassification3":{{adClassification3}},"adClassification4":{{adClassification4}},"adClassification5":{{adClassification5}},"adFormat":{{adFormat}},"campaignId":{{campaignId}},"placementId":{{placementId}},"adId":{{adId}},"keywordId":{{keywordId}},"isClick":{{isClick}},"userId":{{userId}},"lineId":{{lineId}},"siteId":{{siteId}},"versionId":{{versionId}},"versionIdsonAd":{{versionIdsonAd}},"advertiserName":{{advertiserName}},"advertiserId":{{advertiserId}}%7D%7D]%7D" />
```

And our tag is ready to deploy!

## Testing the tag

Once the tag is ready, deploy it in a development environment. Then check your data pipeline to see:

1. That the data is coming through into Redshift
2. Check the bad rows buckets, specifically `s3://snowplow-findly-enrichment-output/enriched/bad` and `s3://snowplow-findly-enrichment-output/shredded/bad` to see if the data is hitting the pipeline but not successfully being processed. The error messages recorded in the bad rows should help identify what steps are required to fix the issue.

[custom-structured-event]: https://github.com/snowplow/snowplow/wiki/canonical-event-model#customstruct
[ad-context]: /snowplow-proservices/findly-event-dictionary/tree/master/schemas/com.findly/ad_context/jsonschema
[snowplow-tracker-protocol]: https://github.com/snowplow/snowplow/wiki/snowplow-tracker-protocol