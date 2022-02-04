#!/usr/bin/env texlua
---@diagnostic disable: lowercase-global

-- Configuration file for use with "l3build"

module = "exam-zh"

-- installfiles = {"*.sty"}
sourcefiles = {"*.sty"}
tagfiles = {"*.sty", "*-doc.tex", "CHANGELOG.md"}
-- textfiles = {"CHANGELOG.md"}
typesetfiles = {"*.tex"}

checkengines = {"pdftex"}
stdengine = "pdftex"

-- packtdszip = true
