private ["_variable_str", "_interval"];
_variable_str = _this select 0;
_interval = _this select 1;

private ["_state_g", "_state_s"];
_state_g = [
	{ time; }
];

_state_s = [
	{
		private "_dt";
		_dt = time - _this;

		if (_dt > 300) then {
			if (player distance (leader player) < 300) exitwith {};

			private "_action";
			_action = player addaction ["<t color='#FF0000'>OPTIONAL: Spawn on group</t>", {
				titleText ["You remember where you are...", "BLACK IN", 10];

				player setposATL ([leader player, 10] call CBA_fnc_randPos);
			}];

			_action spawn {
				sleep 60;

				player removeaction _this;
			};
		};
	}
];

[_variable_str, _state_s] call nomad_fnc_restore;

private "_vm";
_vm = [_variable_str, _state_g, _interval] spawn nomad_fnc_start;
profileNamespace setvariable [_variable_str + "_vm", _vm];
