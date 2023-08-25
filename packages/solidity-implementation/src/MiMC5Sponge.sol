// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Hasher {
    uint256 p = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    uint256[20] c = [
        0,
        106817110799769433093218245423871844717059833683452559466196112354004638572498,
        84255324824758778243920689261768054268226603835992097862981564101503393631449,
        37197502047088319755447032783014359157651485250083660539303816043345813047711,
        32663483869350569457441108253326666697207255573603065306759678212807797608657,
        77949981596831327030843275836056163759930345566858706468497257143337701635082,
        48008708032837997889055358250659021109935598563956572847846081057442579963924,
        78151704570921477873127137133941054666810713605170453966535534917554089394478,
        15348534912154501649990460011781534533170346398475899082484059257946895286096,
        18970395545469280351107608050419345078001347302157351944399526916015227829188,
        22679761981509195336998531649239086318015246397079256509235559663628925312795,
        35586271636152612797214292674565595612070971867022205208695270681460796375740,
        61221530312118325840150771247903849929566155139377953764663614207837924324144,
        103286633200621620507248023416367379780460418287112807675789453707427940506967,
        24475696250073834857397447409849709457582056151188669376174099629191337376327,
        27312551529750852384898501883128611829852368515804657815211432516406859346379,
        23581290894526212408203595224199706484202370309378983986329426965760228181458,
        103691616112549261464497394142126612171833073254702145237603537411191373654519,
        110981869723234407281789291191816098797715721518483276773393741342066687223795,
        9200945872320684290134711189807383509743942292509394373376250231750977697727
    ];

    function MiMC5Feistel(uint256 _iL, uint256 _iR, uint256 _k) internal view returns (uint256 oL, uint256 oR) {
        uint8 nRounds = 20;

        uint256 lastL = _iL;
        uint256 lastR = _iR;

        uint256 mask;
        uint256 mask2;
        uint256 mask4;
        uint256 temp;

        for (uint8 i = 0; i < nRounds; i++) {
            mask = addmod(lastR, _k, p);
            mask = addmod(mask, c[i], p);
            mask2 = mulmod(mask, mask, p);
            mask4 = mulmod(mask2, mask2, p);
            mask = mulmod(mask4, mask, p);

            temp = lastR;
            lastR = addmod(lastL, mask, p);
            lastL = temp;
        }

        oL = lastL;
        oR = lastR;
    }

    function MiMC5Sponge(uint256[2] memory _ins, uint256 _k) external view returns (uint256 h) {
        uint256 lastR = 0;
        uint256 lastC = 0;

        for (uint8 i = 0; i < _ins.length; i++) {
            lastR = addmod(lastR, _ins[i], p);
            (lastR, lastC) = MiMC5Feistel(lastR, lastC, _k);
        }

        h = lastR;
    }
}
