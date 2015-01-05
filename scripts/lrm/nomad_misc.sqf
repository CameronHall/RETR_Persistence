private ["_variable_str", "_interval"];
_variable_str = _this select 0;
_interval = _this select 1;

private ["_state_g", "_state_s"];
_state_g = [
	{ viewdistance; },
	{ if (isnil "terraindetail") then { 1; } else { terraindetail; }; }
];

_state_s = [
	{ setviewdistance _this; },
	{
		setterraingrid ((-10 * _this + 50) max 1);
		terraindetail = _this;
	}
];

[_variable_str, _state_s] call nomad_fnc_restore;

private "_vm";
_vm = [_variable_str, _state_g, _interval] spawn nomad_fnc_start;
profilenamespace setvariable [_variable_str + "_vm", _vm];
