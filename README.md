Event Dictionary
================

Creating schemas, jsonpaths, and sql table definitions
------------------------------------------------------

1. Create a schema ([here's an example](https://github.com/PactCoffee/pact-event-dictionary/blob/master/schemas/com.example_company/example_event/jsonschema/1-0-0))
2. Download [schema guru](https://github.com/snowplow/schema-guru?_sp=44dbe9a530cc476d.1436355830779)
3. Run schema-guru against your new schemas to output jsonpaths and sql table definitions: `path/to/schema-guru-0.4.0 ddl --with-json-paths path/to/schema`


Uploading it all to our iglu
----------------------------

1. Get an S3 access key and secret key
1. `npm install`
1. Upload schemas & jsonpaths `env ACCESS_KEY=yourKey SECRET_KEY=yourSecretKey npm run upload`



## Event Tracking in Topnotes
### What:
In topnotes we have two main types of event. Page view events and structured events. 

Page view events happen when a route changes. I.e. / -> /about (even ?decaf=true -> ?decaf=false) -< maybe!!

We have three consumers of events: 
- Google Analytics
- Snowplow
- Gootgle Tag Manager

A structured event follows the event language of Google Analytics: https://support.google.com/analytics/answer/1033068?hl=en#Anatomy
```
struct(
  category, {  
    action
    label
    property
    value 
    contexts
  }
)
```

### Category
A category is a name that you supply as a way to group objects that you want to track. For example 'orders'.
```
Category: "Orders" (Subscriptions, Gifts, Shop)
Action: "change_date" (change_coffee, asap, skip, cancel)
Label: "subscription" (store)
```

This way you can see at a top level how many people have interacted with orders.  Broken down, how many changed the date of an order or how many of those orders where subscription orders vs adhoc orders.


### Actions
This is typically used to name the type of event in a particular category. They are commonly tied to button clicks. For the Shop category they might include: 
- add_to_basket
- remove_from_basket
- increment_basket
- decrement_basket
- view_product_photo

*All actions are listed independently from their parent categories.* This provides you with another useful way to segment the event data for your reports.
*A unique event is determined by a unique action name.* You can use duplicate action names across categories, but this can affect how unique events are calculated. See the suggestions below and the Implicit Count section for more details.

### Label
Labels provide context to the event. For example a product name or sku, an order id etc. 
```
Category: "Shop"
Action: "add_to_basket"
Label: "Hario V60"

Category: "Shop"
Action: "add_to_basket"
Label: "Stovetop"
```

*All labels are listed independently from their parent categories and actions.* This provides you with another useful way to segment the event data for your reports.
*A unique event is determined in part by a unique label name.* You can use duplicate label names across categories and actions, but this can affect how unique events are calculated. See the suggestions below and the Implicit Count section for more details.

### Value (optional)
Note: Value is an integer.
The value is interpretted as a number that can be summed in reports. It does not always need to be a currency. 
The use of value in the Shop maybe different to it's use in the orders page
```
Category: "Shop"
Action: "add_to_basket"
Label: "Hario V60"
Value: 699 (£)
```
```
Catergory: "Orders"
Label: "change_date"
Value: -5 (days)
```





