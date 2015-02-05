private ["_uid","_fnc_respawn"];
_uid = _this select 0;
lrm_init_script = _this select 1;

lrm_core_str = "lrm_core_" + _uid;
lrm_deaths_str = "lrm_deaths_" + _uid;
lrm_gear_str = "lrm_gear_" + _uid;
lrm_misc_str = "lrm_misc_" + _uid;
lrm_radio_str = "lrm_radio_" + _uid;
lrm_team_str = "lrm_team_" + _uid;
lrm_vehicle_str = "lrm_vehicle_" + _uid;

lrm_var_all_strs = [
	lrm_core_str,
	lrm_deaths_str,
	lrm_gear_str,
	lrm_misc_str,
	lrm_radio_str,
	lrm_team_str,
	lrm_vehicle_str
];

lrm_var_strs = [
	lrm_core_str,
	lrm_gear_str,
	lrm_misc_str,
	lrm_radio_str,
	lrm_team_str,
	lrm_vehicle_str
];

lrm_init_script = _init;
lrm_max_deaths = 10;

if (isNil lrm_core_str) then {
	player call lrm_init_script;
};

private "_fnc_respawn";
_fnc_respawn = {

	private "_deaths";
	_deaths = missionNamespace getVariable [lrm_deaths_str, 0];

	if (missionNamespace getVariable [lrm_deaths_str, 0] >= lrm_max_deaths) then {
		if (getPlayerUID player in debuggers) exitWith {
			systemChat "You should be MIA.";
		};
		systemChat "You are MIA.";
		endMission "end2";
	} else {
		player call lrm_init_script;
	}
};
if ((missionNamespace getVariable [lrm_deaths_str, 0]) >= lrm_max_deaths) exitWith _fnc_respawn;

missionNamespace setVariable [lrm_deaths_str, _deaths];
publicvariable lrm_deaths_str;

lrm_uid_pveh = _uid;
publicVariableServer "lrm_uid_pveh";

[lrm_core_str, { sleep 3; }] execVM "scripts\lrm\nomad_core.sqf";
[lrm_gear_str, { sleep 5; }] execVM "scripts\lrm\nomad_gear.sqf";
[lrm_misc_str, { sleep 20; }] execVM "scripts\lrm\nomad_misc.sqf";
[lrm_radio_str, { sleep 60; }] execVM "scripts\lrm\nomad_radio.sqf";
[lrm_team_str, { sleep 30; }] execVM "scripts\lrm\nomad_team.sqf";
[lrm_vehicle_str, { sleep 5; }] execVM "scripts\lrm\nomad_vehicle.sqf";

player addEventHandler ["Killed", {
		private "_deaths";
		_deaths = missionNamespace getVariable [lrm_deaths_str, 0];
		missionNamespace setVariable [lrm_deaths_str, _deaths + 1];
		publicVariable lrm_deaths_str;

		// reset all other stats
		{
			missionNamespace setVariable [_x, nil];
			publicVariable _x;
		} forEach lrm_var_strs;
}];
player addEventHandler ["Respawn", _fnc_respawn];
