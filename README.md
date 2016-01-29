Event Dictionary
================

Dafuq
-----

1. Create a schema ([here's an example](https://github.com/PactCoffee/pact-event-dictionary/blob/master/schemas/com.example_company/example_event/jsonschema/1-0-0))
2. Download [schema guru](https://github.com/snowplow/schema-guru?_sp=44dbe9a530cc476d.1436355830779)
3. Run schema-guru against your new schemas to output jsonpaths and sql tabel definitions: `path/to/schema-guru-0.4.0 ddl --with-json-paths path/to/schema`
4. 
