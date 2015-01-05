private "_open";
_open = [_this select 0, "w"] call cstdio_fnc_fopen;

if (not _open) exitwith { false; };

(str (_this select 1)) call cstdio_fnc_fwrite;
call cstdio_fnc_fclose;
true;
