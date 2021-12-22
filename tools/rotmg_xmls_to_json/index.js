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

function newData () {
    fs.readFile(__dirname + fileToParse + ".json", { encoding : "utf-8" }, function(err, data) {
        let parsed = JSON.parse(data).Object
        let classes = {}
        Object.keys(parsed).forEach((index) => {
            if (Object.keys(classes).findIndex((v) => v == parsed[index].Class) == -1 && typeof(parsed[index].Class) !== "undefined") {
                let newObj = {} 
                Object.keys(parsed[index]).forEach(objKey => {
                    if (objKey === "$") {
                        Object.keys(parsed[index][objKey]).forEach(o => {
                            newObj[o] = parsed[index][objKey][o]
                        })
                    }
                    else {
                        if ( parsed[index][objKey] == "") { newObj[objKey] = true }
                        else if (typeof(parsed[index][objKey]) == "object" ) {
                            if ( parsed[index][objKey]["_"] !== null && parsed[index][objKey]["_"] !== undefined) {
                                if (parsed[index][objKey]["_"] == "0" || parsed[index][objKey]["_"] == "100") {
                                    newObj[objKey] = {
                                        default : parsed[index][objKey]["_"],
                                        max : parsed[index][objKey]["$"]
                                    }
                                } else {
                                    newObj[objKey] = {}
                                    newObj[objKey][
                                        parsed[index][objKey]["_"]
                                    ] = parsed[index][objKey]["$"]
                                }
                            }
                        }
                        else {
                            newObj[objKey] = parsed[index][objKey]
                        }
                    }
                })
                classes[parsed[index].Class] = [newObj]
            } else if (Object.keys(classes).findIndex((v) => v == parsed[index].Class) !== -1) { 
                let newObj = {} 
                Object.keys(parsed[index]).forEach(objKey => {
                    if (objKey === "$") {
                        Object.keys(parsed[index][objKey]).forEach(o => {
                            newObj[o] = parsed[index][objKey][o]
                        })
                    }
                    else {
                        if ( parsed[index][objKey] == "") { newObj[objKey] = true }
                        else if (typeof(parsed[index][objKey]) == "object" ) {
                            if ( parsed[index][objKey]["_"] !== null && parsed[index][objKey]["_"] !== undefined) {
                                if (parsed[index][objKey]["_"] == "0") {
                                    newObj[objKey] = {
                                        default : parsed[index][objKey]["_"],
                                        max : parsed[index][objKey]["$"]
                                    }
                                } else {
                                    newObj[objKey] = {}
                                    newObj[objKey][parsed[index][objKey]["_"]] = parsed[index][objKey]["$"]
                                }
                            }
                        }
                        else {
                            newObj[objKey] = parsed[index][objKey]
                        }
                    }
                })
                classes[parsed[index].Class].push(newObj)
            }
        })

        Object.keys(classes).forEach((cls) => {
            fs.writeFile(__dirname + "/bin/" + cls + ".json", JSON.stringify(classes[cls], null, 2), { encoding: "utf-8" }, (err) => {
                if (!err) {
                    console.log("success")
                } else {
                    console.err(err)
                }
            })
        })
    });
}

newData()