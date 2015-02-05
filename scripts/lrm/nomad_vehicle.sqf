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
			assignedVehicleRole player
		];
	}
];

_state_s = [
	{
		private "_vehicle";
		_vehicle = _this select 0;

		if (typeName _vehicle != "STRING") then {
			_vehicle_role = _this select 1;

			if (count _vehicle_role > 0) then {
				switch toLower(_vehicle_role select 0) do {
					case "driver": {
						_unit assignAsDriver _vehicle;
						_unit moveInDriver _vehicle;
					};
					case "cargo": {
						_unit assignAsCargo _vehicle;
						_unit moveInCargo _vehicle;
					};
					case "turret": {
						private "_path";
						_path = _vehicle_role select 1;

						_unit assignAsTurret [_vehicle, _path];
						_unit moveInTurret [_vehicle, _path];
					};
				};
			}
		};
	}
];

[_variable_str, _state_s] call nomad_fnc_restore;

private "_vm";
_vm = [_variable_str, _state_g, _interval] spawn nomad_fnc_start;
profileNamespace setVariable [_variable_str + "_vm", _vm];
