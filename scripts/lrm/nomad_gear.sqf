private ["_variable_str", "_interval"];
_variable_str = _this select 0;
_interval = _this select 1;

private ["_state_g", "_state_s"];
_state_g = [
	{ [player, ["repetitive"]] call aero_fnc_get_loadout; }
];

_state_s = [
	{ [player, _this, []] call aero_fnc_set_loadout; }
];

[_variable_str, _state_s] call nomad_fnc_restore;

private "_vm";
_vm = [_variable_str, _state_g, _interval] spawn nomad_fnc_start;
profileNamespace setvariable [_variable_str + "_vm", _vm];
