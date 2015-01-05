if (count _this != 3) exitwith { assert(false); };

private ["_variable_str", "_properties", "_interval"];
_variable_str = _this select 0;
_properties = _this select 1;
_interval = _this select 2;

private "_state";
_state = [];

private "_previous";
_previous = str(profileNamespace getVariable [_variable_str, ""]);

while {true} do {
	{
		_state set [_forEachIndex, call _x];
	} foreach _properties;

	if (str(_state) != _previous) then {
		_previous = str(_state);

		profileNamespace setVariable [_variable_str, _state];
	};

	call _interval;
};
