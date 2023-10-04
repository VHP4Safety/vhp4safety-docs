// Copyright (C) 2023  Egon Willighagen
// License: MIT

// groovy createMarkdown.groovy *.json

import groovy.json.JsonSlurper

templateFile = "template.md"

def getData(data, selector) {
  if (selector.contains(".")) {
    index = selector.indexOf(".")
    first = selector.substring(0,index)
    second = selector.substring(index+1)
    if (data[first]) {
      return getData(data[first], second)
    } else {
      return null
    }
  } else {
    if (data[selector]) {
      return data[selector]
    } else {
      return null
    }
  }
}

def process(line, data, selector) {
  return processRich(line, data, selector, null)
}

def processRich(line, data, selector, expanding) {
  toReplace = "%" + selector + "%"
  if (selector.endsWith(".noExpand")) {
    content = getData(data, selector.substring(0, selector.indexOf(".noExpand")))
  } else {
    content = getData(data, selector)
  }
  if (content == null) return line.replaceAll(toReplace, "")
  if (expanding != null) content = expanding.replaceAll(toReplace, content)
  return line.replaceAll(toReplace, content)
}


args.each { dataFile ->
if (dataFile != "template.json") {
  fileContents = new File(dataFile).text
  def data = new JsonSlurper().parseText(fileContents)

  outputFile = new File(data.id + ".md")
  outputFile.text = ""

  lines = new File(templateFile).readLines()
  lines.each { String line ->
    if (line.contains("%id%")) { line = process(line, data, "id") }
    if (line.contains("%service%")) { line = process(line, data, "service") }
    if (line.contains("%url%")) { line = process(line, data, "url") }
    if (line.contains("%doi%")) { line = processRich(line, data, "doi", "[https://doi.org/%doi%](https://doi.org/%doi%)") }
    if (line.contains("%description%")) { line = process(line, data, "description") }
    if (line.contains("%screenshot%")) { line = processRich(line, data, "screenshot", "![screenshot of %service%](https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/service/%screenshot% \"Click on the image to go to the service\")")}
    if (line.contains("%provider.name%")) { line = process(line, data, "provider.name") }
    if (line.contains("%provider.url%")) { line = processRich(line, data, "provider.url", "([%provider.url%](%provider.url%))") }
    if (line.contains("%provider.contact.name%")) { line = process(line, data, "provider.contact.name") }
    if (line.contains("%provider.contact.email%")) { line = process(line, data, "provider.contact.email") }
    if (line.contains("%access.login%")) { line = process(line, data, "access.login") }
    if (line.contains("%access.API%")) { line = process(line, data, "access.API") }
    if (line.contains("%access.packages.R%")) { line = processRich(line, data, "access.packages.R", ", [R package](%access.packages.R%)") }
    if (line.contains("%access.packages.Python%")) { line = processRich(line, data, "access.packages.Python", ", [Python](%access.packages.Python%)") }
    if (line.contains("%instance.type%")) { line = process(line, data, "instance.type") }
    if (line.contains("%instance.vhp-platform%")) { line = process(line, data, "instance.vhp-platform") }
    if (line.contains("%instance.url%")) { line = process(line, data, "instance.url") }
    if (line.contains("%instance.version%")) { line = process(line, data, "instance.version") }
    if (line.contains("%instance.license%")) { line = process(line, data, "instance.license") }
    if (line.contains("%instance.TRL%")) { line = process(line, data, "instance.TRL") }
    if (line.contains("%instance.source%")) { line = processRich(line, data, "instance.source", "[%instance.source%](%instance.source%)") }
    if (line.contains("%instance.docker%")) { line = processRich(line, data, "instance.docker", "[%instance.docker%](%instance.docker%)") }
    if (line.contains("%ELIXIR.biotools%")) { line = processRich(line, data, "ELIXIR.biotools", "[https://bio.tools/%ELIXIR.biotools%](https://bio.tools/%ELIXIR.biotools%)") }
    if (line.contains("%ELIXIR.tess%")) { line = processRich(line, data, "ELIXIR.tess", "[https://tess.elixir-europe.org/search?q=%ELIXIR.tess%](https://tess.elixir-europe.org/search?q=%ELIXIR.tess%)") }
    if (line.contains("%ELIXIR.tess.noExpand%")) { line = process(line, data, "ELIXIR.tess.noExpand") }
    outputFile << line + "\n"
  }
}
}
