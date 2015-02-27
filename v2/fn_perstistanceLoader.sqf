/*
*	@function RETR_fnc_persistenceLoader
* @author CameronHall "Retra"
* Description: To load player persistence data from their profile namespace. 
* 
* 
*/
_persistenceVarName = toArray(format["RETR_persitance_%1",getPlayerUID]);
_persitanceData = profileNamespace getVariable _persistenceVarName;
if(isNil _persitanceData) exitWith {
	diag_log format["%1 has no persitance data available for the current mission",name player];
	call RETR_fnc_persistenceSaver;
};
//Check if Data is for this mission
_missionName = getText(missionConfigFile >> "onLoadMission");
_missionIntro = getText(missionConfigFile >> "onLoadIntro");
_missionLoadName = getText(missionConfigFile >> "onLoadName");
_missionAuthor = getText(missionConfigFile >> "author");
_playerUID = (getPlayerUID player); 
_authenticationDataString = [_missionName,_missionIntro,_missionLoadName,_missionAuthor,_playerUID];
_authenticationData =  toArray str[_missionName,_missionIntro,_missionLoadName,_missionAuthor,_playerUID];
if (_persitanceData select 0 != _authenticationData) exitWith {
	profileNamespace setVariable [_persistenceData,nil];
	diag_log format["Invalid Persitance Data Loaded, %1 loaded the following data %2", name player, _authenticationDataString];
	call RETR_fnc_persistenceSaver;
};
	_positionData = call compile toString(_persitanceData select 1);
	_gearData = call compile toString(_persitanceData select 2);
	_settingsData = call compile toString(_persitanceData select 3);
	_groupData = call compile toString(_persitanceData select 4);
	_medicalStateData = call compile toString(_persitanceData select 5);
	_vehicleData = call compile toString(_persitanceData select 6);

	_hashCheck1 = _positionData select 2;
	_hashCheck2 = _gearData select (count _vehicleData - 1);
	_hashCheck3 = _settingsData select 2
	_hackCheck4 = _groupData select 1;
	_hashcheck5 = _medicalStateData select (count _medicalStateData - 1);
	_hashcheck6 = _vehicleData select 1;
};
if((_hashCheck1 && _hashCheck2 && _hashCheck3 && _hashcheck4 && _hashCheck5 && _hashCheck6) != _playerUID) exitWith {
	profileNamespace setVariable [_persistenceData,nil];
	diag_log format["%1's persistance data has been tampered with. \n Restting %1's persistence data.", name player];
	call RETR_fnc_persistenceSaver;
};
	_positionData = [_positionData select 0 select 0, _positionData select 0 select 1, _positionData select 0 select 2];
	player setPosATL _positionData;
	diag_log format["%1 spawned at exact coordinates %2",name player, _positionData];
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
