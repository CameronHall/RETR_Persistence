private ["_variable_str", "_interval"];
_variable_str = _this select 0;
_interval = _this select 1;

private ["_state_g", "_state_s"];
_state_g = [
	{
		private "_vehicle";
		_vehicle = if (vehicle player != player) then {
			vehicle player;
		} else {
			"%NULL%";
		};

		[
			_vehicle,
			assignedvehiclerole player
		];
	}
];

_state_s = [
	{
		private "_vehicle";
		_vehicle = _this select 0;

		if (typename _vehicle != "STRING") then {
			_vehicle_role = _this select 1;

			if (count _vehicle_role > 0) then {
				switch tolower(_vehicle_role select 0) do {
					case "driver": {
						_unit assignasdriver _vehicle;
						_unit moveindriver _vehicle;
					};
					case "cargo": {
						_unit assignascargo _vehicle;
						_unit moveincargo _vehicle;
					};
					case "turret": {
						private "_path";
						_path = _vehicle_role select 1;

						_unit assignasturret [_vehicle, _path];
						_unit moveinturret [_vehicle, _path];
					};
				};
			}
		};
	}
];

[_variable_str, _state_s] call nomad_fnc_restore;

private "_vm";
_vm = [_variable_str, _state_g, _interval] spawn nomad_fnc_start;
profileNamespace setvariable [_variable_str + "_vm", _vm];
