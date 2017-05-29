---
published: true
layout: post
title: "Validating XML sitemaps in node.js"
description: "How to use XML Schema (XSD) to validate your sitemap.xml in node.js"
tags: [web, seo, xml, node, javascript]
---

# Introduction
Sitemaps are a way to tell search engines which pages on your site should be crawled and how often. They are written in XML and if it's not well-formed and valid, search engines won't not be able to crawl your content. In this post I will demonstrate how to use XML schemas to validate sitemap XML files. For more information about sitemaps and sitemap index files see the [sitemap documentation](https://www.sitemaps.org/protocol.html).

# Walkthrough
We need to download the XML schema (XSD) to validate against. It's available [here](https://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd), we'll save it in it's own folder as sitemap.xsd:

``` bash
mkdir -p test/schemas
curl https://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd > test/schemas/sitemap.xsd
```

We'll use [libxmljs](https://github.com/libxmljs/libxmljs) to perform the validation:

`npm install libxmljs --save`

The validation code will live in a file called `sitemap.tests.js` and we'll assume our built sitemap is in the base of the project. Here's the folder structure:

<pre>
.
├── package.json
├── sitemap.xml
└── test
    ├── schemas
    │   └── sitemap.xsd
    └── sitemap.tests.js
</pre>

In this example I'm reading the sitemap and schema from the local file system, however the same approach could easily be used to validate a sitemap that's generated dynamically. Just call the endpoint and use libxmljs in the same way as shown here, to parse and validate it. Then you can assert on and report the results however you like.

Here's `sitemap.tests.js`:

``` javascript
const assert = require('assert');
const fs = require('fs');
const libxmljs = require('libxmljs');

// Read the sitemap and schema from the file system
// Could just as easily get these over HTTP
const sitemap = fs.readFileSync('../sitemap.xml');
const schema = fs.readFileSync('./schemas/sitemap.xsd');

// Parse the sitemap and schema
const sitemapDoc = libxmljs.parseXml(sitemap);
const schemaDoc = libxmljs.parseXml(schema);

// Perform validation
const isValid = sitemapDoc.validate(schemaDoc);

// Check results
assert.ok(isValid, sitemapDoc.validationErrors);
```

# Sitemap index files
If you're using a [sitemap index](https://www.sitemaps.org/protocol.html#index) file to link to multiple sitemap files then it's a good idea to also validate these. There is a separate schema available [here](hhttps://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd) but other than that the process is exactly the same as for the sitemap files themselves.

# Google News sitemaps
Google have their own set of extensions to the sitemap format for Google News specific information. The News specific elements are in their own XML namespace, the schema is available [here](http://www.google.com/schemas/sitemap-news/0.9/sitemap-news.xsd). We'll save it alongside the main schema.

`curl http://www.google.com/schemas/sitemap-news/0.9/sitemap-news.xsd > test/schemas/sitemap-news.xsd`

When validating a sitemap that includes both the standard and the News specific elements we need a combined XSD to validate against; we can do this by importing the News schema into the main schema.

For example given the following file layout:
<pre>
.
└── test
    ├── schemas
    │   ├── sitemap-news.xsd
    │   └── sitemap.xsd
    └── sitemap.tests.js
</pre>

We can use an `xsd:import` import element to import another XSD. The import should be a child of the `xsd:schema` element. Note that the `schemaLocation` path is relative to the working directory of the node process not the file importing it; here I am assuming that the tests are being run from the root of the project.

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema ...>
    <xsd:import
        namespace="http://www.google.com/schemas/sitemap-news/0.9"
        schemaLocation="./test/schemas/sitemap-news.xsd"/>

    ...
</xsd:schema>
```

Once you have a combined XSD you can validate the sitemap against the XSD as described above.

# Conclusion
Sitemaps are an important part of SEO for many sites and we need to make sure they are well-formed and valid. It's very straight forward to do this as part of the sites test suite.
