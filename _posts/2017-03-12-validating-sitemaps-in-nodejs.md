---
published: true
layout: post
title: "Validating XML sitemaps in node.js"
description: "How to use XML Schema (XSD) to validate your sitemap.xml in node.js"
tags: [web, seo, xml, node, javascript]
---

# Introduction
Sitemaps are a way to provide search engines with the info about which pages on your site should be crawled and how often. Sitemaps use XML and if this is not valid, search engines may not be able to crawl your content. In this post I will demonstrate how to use XML schemas to validate sitemap XML files to prevent such issues. For more information about sitemaps and sitemap index files see [sitemap documentation](https://www.sitemaps.org/protocol.html).

# Walkthrough
First we need to download the XML schema (XSD) to validate against. It's available [here](https://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd), we'll save it as sitemap.xsd:

`curl https://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd > sitemap.xsd`

We'll use [libxmljs](https://github.com/libxmljs/libxmljs) to perform the validation:

`npm install libxmljs`

In this example I'm reading the sitemap and schema from the local file system, however this approach can just as easily be used to validate a sitemap that is generated dynamically. Just call the endpoint and use libxmljs in the same way shown here, to parse and validate it. Then you can assert on and report the results however you like.

``` javascript
const fs = require('fs');
const libxmljs = require('libxmljs');

// Read the sitemap and schema from the file system
// Could just as easily get these over HTTP
const sitemap = fs.readFileSync('./sitemap.xml');
const schema = fs.readFileSync('./sitemap.xsd');

// Parse the sitemap and schema
const sitemapDoc = libxmljs.parseXml(sitemap);
const schemaDoc = libxmljs.parseXml(schema);

// Perform validation
const isValid = sitemapDoc.validate(schemaDoc);

// Check results
if (isValid) {
    console.log('Sitemap is valid');
} else {
    console.log('Sitemap is invalid');
    console.log(sitemapDoc.validationErrors);
}
```

# Sitemap index files
If you are using a sitemap index file to link to multiple sitemap files then it's a good idea to also validate these. There is a separate schema available [here](hhttps://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd) but other than that the process is exactly the same as for the sitemap files themselves. You can save the schema down using the following snippet:

`curl https://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd > siteindex.xsd`

