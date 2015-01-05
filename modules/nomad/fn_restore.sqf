if (count _this != 2) exitwith { assert(false); };

private ["_variable_str", "_setters"];
_variable_str = _this select 0;
_setters = _this select 1;

if (not isnil _variable_str) then {
	{
		_x call (_setters select _foreachindex);
	} foreach (profileNamespace getVariable _variable_str);
};
