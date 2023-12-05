// Copyright (C) 2023  Egon Willighagen
// License: MIT

// groovy createMarkdown.groovy *.json

import groovy.json.JsonSlurper
import groovy.io.FileType

println """<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<urlset
      xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"http://www.sitemaps.org/schemas/sitemap/0.9
      http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\">
"""

def list = []

def dir = new File("docs/service")
dir.eachFileRecurse (FileType.FILES) { file ->
  if (file.name.endsWith(".json") && file.name != "template.json") {
    list << file
  }
}
list = list.sort()

list.each { file ->
  fileContents = file.text
  def data = new JsonSlurper().parseText(fileContents)
  println """<url>
  <loc>https://cloud.vhp4safety.nl/service/${data.id}.html</loc>
  <priority>1.00</priority>
  <changefreq>weekly</changefreq>
</url>"""
}

println """</urlset>"""
