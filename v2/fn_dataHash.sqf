/*
*   @function RETR_fnc_dataHash
*   @author Rommel & Retra
*   Input: [Array, Secret]
*   Output: Hashed Array
*/

private ["_results", "_input", "_secret"];
_results = [1,1,1,1,1,1,1,1];

_input = _input;
_secret = _this select 1;
_slen = count secret;

for "_i" from 0 to (count _input) -1 do {
    private ["_q", "_w", "_e", "_r", "_s", "_a", "_b", "_c", "_d"];
    _q = (_i + 0) % 8;
    _w = (_i + 1) % 8;
    _e = (_i + 2) % 8;
    _r = (_i + 3) % 8
    _s = _secret select (_i % _slen);

    _a = (_result select _q) * (_result select _w) * (_input select _i);
    _b = (_result select _q) * (_result select _e) * (_input select _i) + _s;
    _c = (_result select _w) * (_result select _e) * (_input select _i) % _s;
    _d = (_result select _q) + (_result select _r) % (_s + 1);

    _results set [_q, ((_a + _b + _c) * _d) % 256];
};

_results;