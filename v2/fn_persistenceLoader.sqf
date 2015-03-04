/*
*	@function RETR_fnc_persistenceLoader
* 	@author CameronHall "Retra"
* 	Input: missionData from profileNamespace 
* 	Output: Applying all the missionData from the profileNamespace, start the save function.
*/
_persistenceVarName = toArray(format["RETR_persitance_%1",getPlayerUID]);
_persistenceData = profileNamespace getVariable _persistenceVarName;
_varNames = ["Position","Gear","Settings","Group","Vehicle","Medical","Hash"];
_tamperedData = format["%1's persistence data has been tampered with. \n Resetting %1's persitence data.", name player];

if(isNil _persistenceData) exitWith {
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
//Check if data hash is enabled
_isHashOn = _this select 0 find 'Hash';
if(_isHashOn != -1) then {
	missionNamespace setVariable ['_savingHash',true];
	missionNamespace setVariable ['_hashDataNew', []];
	missionNamespace setVariable ['_hashDataCompare', (_persistenceData select) select _isHashOn];
	missionNamespace setVariable ['_hashDataNew',[]];
} else {
	missionNamespace setVariable ['_savingHash',false];
};

//Lazier way to define variables
for "_i" from 0 to (count _this select 0) -2 do {
	if (isNil _this select _i) then {// In case no arguments are defined when the script is called eg. call RETR_fnc_persistenceSaver
		_savingX = format["_saving%1",_this select _i];
		missionNamespace setVariable [_tmp, _this select _i];
	};
	_xData = format["_%1Data",toLower _this select _i];
	missionNamespace setVariable [_tmp, call compile _persistenceData select _i];
	if(!isNil _xData && (_savingHash)) then {
		_hashPart = [_xData, serverHash] call RETR_fnc_dataHash;
		_hashDataNew pushBack _hashPart;
	};
};
//Compare Hash
if (_hashDataCompare != _hashDataNew) exitWith {
	profileNamespace setVariable [_persistenceData,nil];
	diag_log _tamperedData;
};
//PUID Hash Checks
_hashCheck1 = _positionData select 3;
_hashCheck2 = _gearData select (count _vehicleData - 1);
_hashCheck3 = _settingsData select 2
_hackCheck4 = _groupData select 1;
_hashcheck5 = _medicalData select (count _medicalData) -1;
_hashcheck6 = _vehicleData select 1;
//Check if the data we got from above is the players UID
if((_hashCheck1 && _hashCheck2 && _hashCheck3 && _hashcheck4 && _hashCheck5 && _hashCheck6) != _playerUID) exitWith {
	profileNamespace setVariable [_persistenceData,nil];
	diag_log _tamperedData;
	call RETR_fnc_persistenceSaver;
};
	_positionData = [_positionData select 0, _positionData select 1, _positionData select 2];
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
