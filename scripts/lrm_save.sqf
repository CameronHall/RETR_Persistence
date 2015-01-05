private ["_data", "_uids"];
_data = [];
_uids = lrm_player_uids;

{
	private "_pdata";
	_pdata = [];
	{
		_pdata set [count _pdata, missionnamespace getvariable _x];
	} foreach lrm_var_all_strs;

	_data set [count _data, _pdata];
} foreach _uids;

["lrmsave.txt", [_uids, _data]] call compile preprocessfilelinenumbers "scripts\sqf_save.sqf"
