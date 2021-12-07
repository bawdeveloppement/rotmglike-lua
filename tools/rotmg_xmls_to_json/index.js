var { xml2json } = require('xml-js');
var { parseString } = require('xml2js');
var fs = require('fs')


const fileToParse = "/dat1"


function xmlToJsonFile () {
    fs.readFile(__dirname + fileToParse + ".xml", function(err, data) {
        // const log = xml2json(data, { sanitize: true })
        parseString(data, (err, result) => {
            if (!err) {
                let newObj = {
                    Object: [

                    ]
                }
                result.Objects.Object.forEach(ob => {
                    let no = {}
                    Object.keys(ob).forEach(o => {
                        if (Array.isArray(ob[o])) {
                            if (typeof ob[o][0] === "object") {
                                let nx = {}
                                Object.keys(ob[o][0]).forEach(x => {
                                    if (Array.isArray(ob[o][0][x])) {
                                        nx[x] = ob[o][0][x][0]
                                    } else {
                                        nx[x] = ob[o][0][x]
                                    }
                                })
                                no[o] = nx
                            } else no[o] = ob[o][0]
                        } else no[o] = ob[o]
                    })
                    newObj.Object.push(no)
                })
                fs.writeFile(__dirname + fileToParse + ".json", JSON.stringify(newObj), { encoding: "utf-8" }, (err) => {
                    if (!err) {
                        console.log("No error")
                    }
                })
            } else console.log(err)
        })
    });
}

xmlToJsonFile()