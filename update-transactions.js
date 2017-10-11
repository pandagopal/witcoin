let request = require('request');

let BitcoinParser = require("./lib/BitcoinParser.js");
let BitcoinCashParser = require("./lib/BitcoinCashParser.js");
let LitecoinParser = require("./lib/LitecoinParser.js");
let DashParser = require("./lib/DashParser.js");
let BancorParser = require("./lib/BancorParser.js");
let AragonParser = require("./lib/AragonParser.js");

var getSpecificParser = function(coin){
    var parser;
    if (coin === "BTC") {
        parser = new BitcoinParser();
    } else if (coin === "BCH") {
        parser = new BitcoinCashParser();
    } else if (coin === "LTC") {
        parser = new LitecoinParser();
    } else if (coin === "DASH") {
        parser = new DashParser();
    } else if (coin === "BNT") {
        parser = new BancorParser();
    } else if (coin === "ANT") {
        parser = new AragonParser();
    }
    return parser;
};

var getTransactions = function(coin){
    var parser = getSpecificParser(coin);

    request(parser.getAdrApiUrl(), function (error, response, body, callback) {
        if (body === "Not found" || body === "{}") {
            console.log("ERROR");
        } else if (!error && response.statusCode === 200) {
            var parsed = JSON.parse(body);

            var txs = parser.getTransactions(parsed);

            // console.log(txs);
            console.log(coin + ": " + txs.length);
            console.log(txs[0]);

        } else {
            console.log("ERROR");
        }
    });
};

// Bitcoin

getTransactions("BTC");
getTransactions("BCH");
getTransactions("LTC");
getTransactions("DASH");
getTransactions("BNT");
getTransactions("ANT");
