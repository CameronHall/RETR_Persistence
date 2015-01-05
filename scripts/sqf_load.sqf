private "_open";
_open = [_this, "r"] call cstdio_fnc_fopen;

if (not _open) exitwith {};

[0, "SEEK_END"] call cstdio_fnc_fseek;

private "_filesize";
_filesize = call cstdio_fnc_ftell;
[0, "SEEK_SET"] call cstdio_fnc_fseek;

private "_str";
_str = "";

private "_r";
_r = 0;

while {_r < _filesize} do {
	_str = _str + (128 call cstdio_fnc_fread);
	_r = _r + 128;
};

call cstdio_fnc_fclose;

// return the parsed SQF
call compile _str;
