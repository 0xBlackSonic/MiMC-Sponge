pragma circom 2.0.0;

template MiMCFeistel() {
    signal input iL;
    signal input iR;
    signal input k;

    signal output oL;
    signal output oR;

    var nRounds = 20;
    var c[20] = [
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

    signal lastOutputL[nRounds + 1];
    signal lastOutputR[nRounds + 1];

    var base[nRounds];
    signal base2[nRounds];
    signal base4[nRounds];

    lastOutputL[0] <== iL;
    lastOutputR[0] <== iR;

    for(var i = 0; i < nRounds; i++) {
        base[i] = lastOutputR[i] + k + c[i];
        base2[i] <== base[i] * base[i];
        base4[i] <== base2[i] * base2[i];

        // Encoding left side and exchanging places for the next round
        lastOutputR[i + 1] <== lastOutputL[i] + base4[i] * base[i];
        lastOutputL[i + 1] <== lastOutputR[i];
    }

    oL <== lastOutputL[nRounds];
    oR <== lastOutputR[nRounds];
}

template MiMC5Sponge(nInputs) {
    signal input k;
    signal input ins[nInputs];
    signal output o;

    signal lastR[nInputs + 1];
    signal lastC[nInputs + 1];

    lastR[0] <== 0;
    lastC[0] <== 0;

    // Encryption layers
    component layers[nInputs];

    for(var i = 0; i < nInputs; i++) {
        layers[i] = MiMCFeistel();

        // Hook inputs into the actual layer
        layers[i].iL <== lastR[i] + ins[i];
        layers[i].iR <== lastC[i];
        layers[i].k <== k;

        // Hook outputs to the next layer
        lastR[i + 1] <== layers[i].oL;
        lastC[i + 1] <== layers[i].oR;
    }

    o <== lastR[nInputs];
}

component main  = MiMC5Sponge(2);