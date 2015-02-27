/*
*	@function RETR_fnc_persitanceLoader
* @author CameronHall "Retra"
* Description: To load player persistance data from their profile namespace. 
* 
* 
*/
_persistanceVarName = toArray(format["RETR_persitance_%1",getPlayerUID]);
_persistanceVarName toArray(_persistanceVarName + toArray(netID));
_persitanceData = profileNamespace getVariable _persistanceVarName;
if(isNil (_persitanceData)) exitWith {
	diag_log format["%1 has no persitance data available for the current mission",name player];
};
//Decrypt - Authenitcation
_persistanceVarName = toArray(format["RETR_persitance_%1",getPlayerUID]);
_persistanceVarName str(toArray(_persistanceVarName + toArray(netID));
_persistanceData = profileNamespace getVariable _persistanceVarName;
_missionName = toArray(getText(missionConfigFile >> "onLoadMission"));
_missionIntro = toArray(getText(missionConfigFile >> "onLoadIntro"));
_missionLoadName = toArray(getText(missionConfigFile >> "onLoadName"));
_missionAuthor = t oArray(getText(missionConfigFile >> "author"));
_playerUID = toArray(getPlayerUID player); 
_netID = toArray(netID player);
_authenticationData =  toArray[_missionName,_missionIntro,_missionLoadName,_missionAuthor,_playerUID,_netID];
if (_persitanceData select 0 != _authenticationData) then {
	profileNamespace setVariable [_persistanceData,nil];
} else {
	diag_log format["Invalid Persitance Data Loaded, player loaded the following data %1", _authenticationData];
	_positionData = [_persitanceData select 1 select 1 select 0, _persitanceData select 1 select 1 select 1, _persitanceData select 1 select 1 select 2];
	_gridPostionData = _persitanceData select 1 select 0;
	_gearData = _persitanceData select 2;
	_viewDistanceData = _persitanceData select 3 select 0;
	_terrainGridData = _persitanceData select 3 select 1;
	_groupData = _persitanceData select 4;
	_medicalStateData = _persitanceData select 5;
	player setPosATL _positionData;
	diag_log format["%1 spawned at grid postion %2, exact coordinates %3",name player,_gridPostionData, _positionData];
	[player, _gearData] call aero_fnc_set_loadout;
	diag_log format["%1 recieved the following gear %2",name player, _gearData];
	setViewDistance _viewDistanceData;
	setTerrainGrid _terrainGridData;
	diag_log format ["%1's terrain and view distance settings are %2",name player, _terrainGridData];
	player joinAsSilent _groupData;
	diag_log format ["%1 assigned to %2", name player, _groupData];
	if !(isNull (_persitanceData select 5)) then {
		diag_log format ["%1 is in a vehicle, assigning slot", name player];
		private "_vehicle";
		_vehicle = _this select 0;
		if (typeName _vehicle != "STRING") then {
			_vehicle_role = _this select 1;
			if (count _vehicle_role > 0) then {
				switch toLower(_vehicle_role select 0) do {
					case "driver": {
						_unit assignAsDriver _vehicle;
						_unit moveinDriver _vehicle;
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
	};
	[player, _medicalStateData] call cse_fnc_setAllSetVariables;
};





