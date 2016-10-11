#!/usr/bin/env bash

apm starred --json > starred.json;
node -e 'const fs = require("fs"); let result = ""; JSON.parse(fs.readFileSync("starred.json")).forEach(function(item) { result += item.name + "\n"; }); fs.writeFile("starred.list", result)';
apm unstar `cat starred.list`;
apm star --installed;
rm starred.json starred.list;
