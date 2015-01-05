#define execnow call compile preprocessfilelinenumbers

private "_parsed";
_parsed = "lrmsave.txt" execnow "scripts\sqf_load.sqf";

private ["_uids", "_data"];
_uids = _parsed select 0;
_data = _parsed select 1;

{
	private "_pdata";
	_pdata = _data select _foreachindex;

	{
		missionnamespace setvariable [_x, _pdata select _foreachindex];
		publicvariable _x;
	} foreach lrm_var_all_strs;
} foreach _uids;

[2, [], {
	execnow "scripts\lrm\terminate.sqf";

	[
		(getplayeruid player),
		lrm_init_script
	] execnow "scripts\lrm\init_player.sqf";
}] call RMM_fnc_MPe;

lrm_player_uids = _uids;
publicvariable "lrm_player_uids";
