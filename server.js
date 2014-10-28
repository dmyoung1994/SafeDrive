var express = require('express')
var app = express()
var http = require("http");
var bodyParser = require('body-parser');
var util = require('util');
var parseString = require('xml2js').parseString;
var request = require('request');
var https = require('https');


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var zwID = "X1-ZWz1b2jhvv9mh7_7x5fi";
var router = express.Router(); 

function testArea(pTax){
    var avg = 2;
    var upper = 5;
    if (pTax > avg && pTax < upper){
        return "average";
    } else if (pTax > upper) {
        return "good";
    } else {
        return "bad";
    }
}

function sendMessage(messageSend) {
   var accountSid = 'ACb4e26bcd24bdc02059d34887b7af9b62';
   var authToken = "20bced3d63dcd74b4c4892e488d3d425";
   var client = require('twilio')(accountSid, authToken, { host: "api-twilio-com-46cnn6h5kepd.runscope.net"});
    
   client.messages.create({
           body: messageSend,
           to: "+15034101905",
           from: "+16203309770"
   }, function(err, message) {
           console.log(err);
           process.stdout.write(message.sid);
   });
}

function getCrimeData(lat, lon, hollaback) {
    var url = "https://jgentes--crime--data--v1-p-mashape-com-46cnn6h5kepd.runscope.net/crime";
        url += "?lat="+ lat +"&long="+lon;
        url += "&enddate=12%2F30%2F2014";
        url += "&startdate=1%2F1%2F2014";
    var options = {
        url: url,
        headers: {
            "X-Mashape-Key": "kCIVHhYPVumshJ07uidCQMOyFsREp1a6eOljsnP99YXCReDOVV"
        }
    };
    
    function crimeCallback(error, response, body) {
        if (!error && response.statusCode === 200) {
            var info = JSON.parse(body);
            var length = info.length;
            var shortResp = [];
            var counter = 0;
            for (var crime in info) {
                if (counter < 10) {
                    shortResp.push(info[crime])
                }
                counter++;
            }
            hollaback(shortResp, length);
        }
    }
    request(options, crimeCallback);

}

router.get('/crime', function(req,res) {
    var lat = req.query.lat;
    var lon = req.query.lng;
    var crime = getCrimeData(lat,lon, function (crime, num) {
        if (crime) {
            res.json({status:200,message:crime, totalCrime:num});
        } else {
             res.status(400).json({status: 400, message: "No Data Found"});
        }
    });
});

router.get('/hoods', function (req, res) {
    var zip = req.query.zip;
    var url = "http://www.zillow.com/webservice/GetDemographics.htm";
        url += "?zws-id="+zwID;
        url += "&zip="+zip;
    var request = http.get(url,function(response){
        var xml = "";
        response.on('data', function(chunk){
            xml += chunk.toString();
        });
        response.on('end', function(){
            parseString(xml, function (err, result) {
                if (result["Demographics:demographics"]) {
                    try {
                     var locPrice = result["Demographics:demographics"]["response"][0]["pages"][0]["page"][0]["tables"][0]["table"][0]["data"][0]["attribute"][13]["values"][0]["zip"][0]["value"][0]["_"];
                     var natPrice = result["Demographics:demographics"]["response"][0]["pages"][0]["page"][0]["tables"][0]["table"][0]["data"][0]["attribute"][13]["values"][0]["nation"][0]["value"][0]["_"];
                     var locZillowIndex = result["Demographics:demographics"]["response"][0]["pages"][0]["page"][0]["tables"][0]["table"][0]["data"][0]["attribute"][0]["values"][0]["zip"][0]["value"][0]["_"];
                     var natZillowIndex = result["Demographics:demographics"]["response"][0]["pages"][0]["page"][0]["tables"][0]["table"][0]["data"][0]["attribute"][0]["values"][0]["nation"][0]["value"][0][    "_"];
                    } catch(err) {
                        console.log(err);
                        res.status(400).json({status: 400, message: "No Data Found"});
                        return;
                    }
                } else {
                    res.status(400).json({status: 400, message: "No Data Found"});
                    return;
                }

                var index = parseInt(locPrice) / parseInt(natPrice);
                var affIndex = parseInt(locZillowIndex) / parseInt(natZillowIndex); 
                if (isNaN(index)) {
                    res.status(400).json({status: 400, message: "No Data Found"});
                } else {
                    var totalIndex = 0;
                    if(affIndex > 0 && index > 0) totalIndex = (affIndex + index)/2;
                    if (affIndex > (2 * index)) totalIndex = affIndex;
                    var area = testArea(totalIndex);
                    if (area === 0) {
                        res.status(400).json({status: 400, message: "No Data Found"});
                    }
                    var message = "WARNING: The area you are in has been determined to be " + area + ". Be safe!";
                    if (area === "bad") {
                        sendMessage(message);
                    }
                    res.json({status: 200, message: area});
                }
            });
        });
    });
});

router.get('/geocode', function(req,res){
    var lat = req.query.lat;
    var lng = req.query.lng;
    
    var url = "https://montanaflynn-geocoder.p.mashape.com/reverse?";
        url += "latitude="+lat+"&longitude="+lng;
    var options = {
        url: url,
        headers: {
            "X-Mashape-Key": "kCIVHhYPVumshJ07uidCQMOyFsREp1a6eOljsnP99YXCReDOVV"
        }
    }

    function zipCB(error, response, body) {
        if (!error && response.statusCode === 200) {
            body = JSON.parse(body);
            var zip = body["zip"];
            res.json({status:200, zip: zip});
        }
    }

    request(options, zipCB);
});

router.get('/mojio', function(req, res) {
    var mojioBase = "https://api-moj-io-46cnn6h5kepd.runscope.net/";
    var loginUrl = mojioBase + "v1/Login/b42fa8fd-61fc-4efc-9e64-a1b92d9bca9d?secretkey=35253dd5-d8cd-40b1-9aec-7ac29fd275e3&userOrEmail=dmyoung&password=!Rottench33se!&minutes=3600";
    request.post({
          url: loginUrl,
    }, function(error, response, body){
        body = JSON.parse(body);
        var appID = body["_id"];
        var userID = body["UserId"];
        vUrl = mojioBase + "v1/Vehicles?user=" + userID;
        var options = {
            url: vUrl,
            headers: {
                MojioAPIToken: appID
            }
        }
        request.get(options, function(error, response, body){
            body = JSON.parse(body);
            var locations = body["Data"][0]["LastLocation"];
            var lat = locations["Lat"];
            var lng = locations["Lng"];
            var crime = getCrimeData(lat,lng, function (crime, num) {
                if (crime) {
                res.json({status:200,message:crime, totalCrime:num,location:{lat:lat,lng:lng}});
                    if (num > 0) {
                        sendMessage("WARNING: There have been "+num+" reported crimes in your area. Be Careful!");
                    }
                } else {
                    res.status(400).json({status: 400, message: "No Data Found"});
                }
            });
        });
    });
});

app.use('/api', router);

app.listen(3000);
console.log("Running on port 3000");
