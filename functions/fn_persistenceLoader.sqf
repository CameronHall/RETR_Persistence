/*
*	@function RETR_fnc_persistenceLoader
* 	@author CameronHall "Retra"
*	@args Define things to save ["Position","Gear","Settings","Group","Vehicle","Medical","Hash"] call RETR_fnc_persistenceLoader
* 	Input: missionData from profileNamespace 
* 	Output: Applying all the missionData from the profileNamespace, start the save function.
*/
private ["_persistenceData", "_persistenceVarName", "_varNames", "_tamperedData", "_argsArray", "_vehicleData", "_medicalData", "_missionName", "_missionIntro", "_missionLoadName", "_missionAuthor", "_playerUID", "_authenticationData", "_persitanceData", "_isHashOn", "_savingHash", "_hashDataNew", "_hashDataCompare", "_savingX", "_saving", "_i", "_xData", "_tmp", "_hashPart", "_hashX", "_hash", "_hashCheck1", "_hashCheck2", "_hashCheck3", "_hashcheck4", "_hashCheck5", "_hashCheck6", "_xSaving", "_savingPosition", "_positionData", "_gearData", "_savingSettings", "_viewDistanceData", "_terrainGridData", "_savingGroup", "_groupData", "_savingVehicle", "_vehicle", "_vehicle_role", "_unit", "_path", "_savingCSE", "_medicalStateData"];
_persistenceData = profileNamespace getVariable _persistenceVarName;
_varNames = ["Position","Gear","Settings","Group","Vehicle","Medical","Hash"];
_tamperedData = format["%1's persistence data has been tampered with. \n Resetting %1's persitence data.", name player];
_argsArray = [3,(count _vehicleData -1),2,1,(count _medicalData) -1,1];
if(isNil _persistenceData) exitWith {
	diag_log format["[Persistence] - %1 has no persitance data available for the current mission",name player];
	_this call RETR_fnc_persistenceSaver;
};
//Check if Data is for this mission
_missionName = getText(missionConfigFile >> "onLoadMission");
_missionIntro = getText(missionConfigFile >> "onLoadIntro");
_missionLoadName = getText(missionConfigFile >> "onLoadName");
_missionAuthor = getText(missionConfigFile >> "author");
_playerUID = (getPlayerUID player); 
_authenticationData =  toArray str[_missionName,_missionIntro,_missionLoadName,_missionAuthor,_playerUID];
//Compare the saved data with the current mission data
if (_persitanceData select 0 != _authenticationData) exitWith {
	profileNamespace setVariable [_persistenceData,nil];
	diag_log format["[Persistence] - %1 loaded invalid Persitance Data Loaded", name player];
	_this call RETR_fnc_persistenceSaver;
};
//Check if data hash is enabled
_isHashOn = _this select 0 find 'Hash';
if(_isHashOn != -1) then {
	missionNamespace setVariable ['_savingHash',true];
	missionNamespace setVariable ['_hashDataNew', []];
	missionNamespace setVariable ['_hashDataCompare',{_persistenceData select _isHashOn;}];
} else {
	missionNamespace setVariable ['_savingHash',false];
};
_hashDataNew = [];
//Lazier way to define variables
for "_i" from 0 to (count _this) -2 do {
	private ["_savingX","_xData","_tmp","_hashPart","_hashX"];
	_savingX = format["_saving%1",{if(isNil _this select _i) then {_varNames select _i;}else {_this select _i;};}];
	missionNamespace setVariable [_savingX,{if(isNil _this select _i) then {_varNames select _i;}else {_this select _i;};}];
	_xData = format["_%1Data",toLower _this select _i];
	_tmp = [];
	//Divide saved array data by serverSalt
	{_tmp pushBack (_x / serverSalt);} forEach _persistenceData select _i + 1;
	missionNamespace setVariable [_tmp,{call compile _persistenceData select _i + 1;}];
	//Concatonate all saved data so we can save the hash
	if(!isNil _xData && _savingHash) then {
		_hashPart = [_xData, serverHash] call RETR_fnc_dataHash;
		_hashDataNew pushBack _hashPart;
	};
	//PUID Hash Checks
	_hashX = format["_hash%1",_i];
	missionNamespace setVariable [_hashX,{_xData select (_argsArray select _i)};]; 
};
//Compare Hash
if (_hashDataCompare != _hashDataNew) exitWith {
	profileNamespace setVariable [_persistenceData,nil];
	diag_log _tamperedData;
	[_tamperedData, systemChat,nil,false, true] call BIS_fnc_MP;

};
//Check if the data we got from above is the players UID
if((_hashCheck1 && _hashCheck2 && _hashCheck3 && _hashcheck4 && _hashCheck5 && _hashCheck6) != _playerUID) exitWith {
	profileNamespace setVariable [_persistenceData,nil];
	diag_log _tamperedData;
	[_tamperedData, systemChat,nil,false, true] call BIS_fnc_MP;
	_this call RETR_fnc_persistenceSaver;
};
//If we are loading _xSaving data
if(_savingPosition) then {
	_positionData = [_positionData select 0, _positionData select 1, _positionData select 2];
	player setPosATL _positionData;
	diag_log format["[Persistence] - %1 spawned at exact coordinates %2",name player, _positionData];
	[player, _gearData] call aero_fnc_set_loadout;
	diag_log format["[Persistence] - %1 recieved the following gear %2",name player, _gearData];
};
if(_savingSettings) then {
	setViewDistance _viewDistanceData;
	setTerrainGrid _terrainGridData;
	diag_log format ["%1's terrain and view distance settings are %2",name player, _terrainGridData];
};
if(_savingGroup) then {
	player joinAsSilent _groupData;
	diag_log format ["%1 assigned to %2", name player, _groupData];
};
if(_savingVehicle) then {
	if !(isNil _vehicleData) then {
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
};
if (_savingCSE) then {
	[player, _medicalStateData] call cse_fnc_setAllSetVariables;
};