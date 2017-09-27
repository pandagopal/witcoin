pragma solidity 0.4.15;


import "./WitCoin.sol";


contract WitcoinPlatform {

    address WitcoinAddress;
    uint256 t = 10;
    address WitsReceiver;
    address WitcoinClub;
    event info(string txt, uint256 value);

    struct wit {
        address[4] citations;
        uint256 reputation;
    }

    mapping (address => wit) wits;

    function WitcoinPlatform(address a) {
        WitcoinAddress = a;
        WitsReceiver = 0xf1f42f995046E67b79DD5eBAfd224CE964740Da3;
        WitcoinClub = 0xcFe984B059De5fBFd8875e4A7e7A16298721B823;
    }

    function register(address witaddress, address author, address c1, address c2, address c3, address c4, uint256 fee, uint witcoins) {
        uint maxCitations = fee;
        uint maxLevel = witcoins;

        //paga taxa registra al registrador.
        WitCoin coin = WitCoin(WitcoinAddress);
        coin.transferFrom(author, msg.sender, 100000000); // 1 W

        //paga el reward a les citacions.
        rewardCitations(author, 50000000, maxLevel, maxCitations); // 0.5 W

        //si tot correcte guardo el registre.
        wits[witaddress] = wit({citations : [c1,c2,c3,c4], reputation : 100});

        // Creacio moneda
        uint256 generatedWitcoins = AcknowledgementValidation();
    }

    function rewardCitations(address author, uint256 amount, uint level, uint citations){

        WitCoin coin = WitCoin(WitcoinAddress);

        if (level != 0) {
            for (uint i = 0; i < citations; i++) {
                //coin.transferFrom(author, WitsReceiver, amount);
                coin.transfereixBarat(author, WitsReceiver, amount);
                rewardCitations(author, amount, level - 1, citations);
            }
        }
    }

    function log(uint256 value) returns(uint256) {
        uint256 x = value * 1000000;
        uint256 LOG = 0;
        while (x >= 1500000) {
            LOG = LOG + 405465;
            x = x * 2 / 3;
        }
        x = x - 1000000;
        uint256 y = x;
        uint256 i = 1;
        while (i < 10){
            LOG = LOG + (y / i);
            i = i + 1;
            y = y * x / 1000000;
            LOG = LOG - (y / i);
            i = i + 1;
            y = y * x / 1000000;
        }
        info("log", LOG);
        return LOG / 1000000;
    }

    function e(uint256 value) returns(uint256) {
        uint256 result;
        result = 3 ** value;
        return result;
    }

    function AcknowledgementValidation()public returns (uint256) {
        WitCoin coin = WitCoin(WitcoinAddress);
        address payingAccount = msg.sender;
        uint256 c = 10 ** 9;
        uint256 k = 1;
        uint256 n = k*e(t);
        uint256 kn = n / c;
        //uint256 generatedWitcoins = (10 ** coin.decimals())/log(kn);
        uint256 generatedWitcoins = 100000000; // 1 witcoin

        //info("log10", log(10));
        //info("log100", log(100));
        //info("log1000", log(1000));
        info("t", t);
        info("n", n);
        info("kn", kn);
        info("generatedWitcoins", generatedWitcoins);

        t = t + 1;
        supply(generatedWitcoins);
        return generatedWitcoins;
    }

    function supply(uint256 witcoins) {
        uint f1 = 10;
        uint f2 = 40;
        uint f3 = 40;
        uint f4 = 10;

        uint q1 = witcoins * f1 / 100;
        uint q2 = witcoins * f2 / 100;
        uint q3 = witcoins * f3 / 100;
        uint q4 = witcoins - q1 - q2 - q3;

        // Miner reward
        address miner = block.coinbase;
        supplyWitcoins(miner, q1);

        // Community reward
        supplyWitcoins(WitcoinClub, q2);

        // Registrars reward
        supplyRegistrars(q3);

        // Dividends
        supplyDividends(q4);
    }

    function supplyWitcoins(address to, uint256 amount) {
        WitCoin coin = WitCoin(WitcoinAddress);
        coin.mint(to, amount);
    }

    function supplyRegistrars(uint256 amount) {
        address registrar = msg.sender;
        supplyWitcoins(registrar, amount);
    }

    function supplyDividends(uint256 amount) {
        address witsowner = 0xf1f42f995046E67b79DD5eBAfd224CE964740Da3;
        supplyWitcoins(witsowner, amount);
    }

}