private ["_uid", "_init"];
_uid = _this select 0;
_init = _this select 1;

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

private "_new";
_new = isnil lrm_core_str;

if (_new) then {
	player call lrm_init_script;
};

private "_fnc_death";
_fnc_death = {
	private "_deaths";
	_deaths = missionnamespace getvariable [lrm_deaths_str, 0];
	missionnamespace setvariable [lrm_deaths_str, _deaths + 1];
	publicvariable lrm_deaths_str;

	// reset all other stats
	{
		missionnamespace setvariable [_x, nil];
		publicvariable _x;
	} foreach lrm_var_strs;
};

private "_fnc_respawn";
_fnc_respawn = {
	private "_uid";
	_uid = (getplayeruid player);

	private "_deaths";
	_deaths = missionnamespace getvariable [lrm_deaths_str, 0];

	if (_deaths >= lrm_max_deaths) then {
		if (_uid in debuggers) exitwith {
			systemchat "You should be MIA.";
		};

		// post the FB message
		[1, "[SITREP]: " + (name player) + " is MIA.", { _this call pipethru_fnc_message; }] call RMM_fnc_MPe;

		systemchat "You are MIA.";
		endmission "end2";
	} else {
		player call lrm_init_script;
	}
};

private "_deaths";
_deaths = missionnamespace getvariable [lrm_deaths_str, 0];
if (_deaths >= lrm_max_deaths) exitwith _fnc_respawn;

missionnamespace setvariable [lrm_deaths_str, _deaths];
publicvariable lrm_deaths_str;

lrm_uid_pveh = _uid;
publicvariableserver "lrm_uid_pveh";

[lrm_core_str, { sleep 3; }] execvm "scripts\lrm\nomad_core.sqf";
[lrm_gear_str, { sleep 5; }] execvm "scripts\lrm\nomad_gear.sqf";
[lrm_misc_str, { sleep 20; }] execvm "scripts\lrm\nomad_misc.sqf";
[lrm_radio_str, { sleep 60; }] execvm "scripts\lrm\nomad_radio.sqf";
[lrm_team_str, { sleep 30; }] execvm "scripts\lrm\nomad_team.sqf";
[lrm_vehicle_str, { sleep 5; }] execvm "scripts\lrm\nomad_vehicle.sqf";

player addeventhandler ["killed", _fnc_death];
player addeventhandler ["respawn", _fnc_respawn];
