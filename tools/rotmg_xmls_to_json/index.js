var { xml2json } = require('xml-js');
var { parseString } = require('xml2js');
var fs = require('fs')


const fileToParse = "/dat1"


function xmlToJsonFile () {
    fs.readFile(__dirname + fileToParse + ".xml", function(err, data) {
        // const log = xml2json(data, { sanitize: true })
        parseString(data, (err, result) => {
            if (!err) {
                fs.writeFile(__dirname + fileToParse + ".json", JSON.stringify(result), { encoding: "utf-8" }, (err) => {
                    if (!err) {
                        console.log("No error")
                    }
                })
            } else console.log(err)
        })
    });
}