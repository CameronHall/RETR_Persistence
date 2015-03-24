/*
* @function RETR_fnc_persistenceSaver
* @author CameronHall "Retra"
* @args Define things to save ["Position","Gear","Settings","Group","Vehicle","Medical","Hash"] call RETR_fnc_persistenceLoader
* Input: [missionData, positionData, gearData, settingData, groupData, vehicleData, medicalData, hashData]
* Output: Saves data to profileNamespace in array same as above.
*/
diag_log "[Persistence] - PERSISTENCE SAVER INITIALISED...";
diag_log format["[Persistence] - Saving %1",_this];
private ["_persistenceVarName", "_persistenceData", "_varNames", "_savingX", "_saving", "_i", "_xData", "_missionName", "_missionIntro", "_missionLoadName", "_missionAuthor", "_playerUID", "_missionCheck", "_savingPosition", "_tmp", "_positionData", "_savingGear", "_gearData", "_savingSettings", "_settingsData", "_savingGroup", "_groupData", "_savingVehicle", "_vehicleData", "_savingMedical", "_medicalData", "_savingHash", "_hashPart", "_hashData", "_persistenceVarX"];
_persistenceVarName = format["RETR_persistence_%1",getPlayerUID player];
_persistenceData = profileNamespace getVariable _persistenceVarName;
_varNames = ["Position","Gear","Settings","Group","Vehicle","Medical","Hash"];
//Define array if it doesn't exist
if (isNil "_persistenceVarName") then {
	_persistenceData = ["authenticate","position","gear","misc","group",nil,"cse"];
	profileNameSpace setVariable [_persistenceVarName,_persistenceData];
};
//Lazier way to define variables
for "_i" from 0 to (count _varNames) -1 do {
	private ["_savingX","_xData"];
	_savingX = format["_saving%1",{if(isNil {_this select _i}) then {_varNames select _i;}else {_this select _i;};}];
	missionNamespace setVariable [_savingX,{if(isNil {_this select _i}) then {_varNames select _i;}else {_this select _i;};}];
	_xData = format["_%1Data",toLower _varNames select _i];
	missionNamespace setVariable [_xData, []];
};

//Authentication Principals
_missionName = getText(missionConfigFile >> "onLoadMission");
_missionIntro = getText(missionConfigFile >> "onLoadIntro");
_missionLoadName = getText(missionConfigFile >> "onLoadName");
_missionAuthor = getText(missionConfigFile >> "author");
_playerUID = (getPlayerUID player); 
_missionCheck = _persistenceVarName select 0;
//Data to save
with profileNamespace do {
	_missionCheck = toArray str[_missionName,_missionIntro,_missionLoadName,_missionAuthor,_playerUID];
};
//Data collection loops
while {_savingPosition} do {
	private ["_tmp","_positionData"];
	_tmp = getPosATL player;
	diag_log format["[Persistence] - %1's position has been saved to a variable", name player];
	_tmp = _tmp pushBack _playerUID;
	_tmp = toArray str _tmp;
	{_positionData pushBack (_x * serverSalt);} forEach _tmp;
	diag_log format["[Persistence] - %1's position has been encrypted", name player];
	sleep 2;
};
while {_savingGear} do {
	private ["_tmp","_gearData"];
	_tmp = [player, ["repetitive"]] call aero_fnc_get_loadout;
	diag_log format["[Persistence] - %1's gear has been saved to a variable", name player];
	_tmp = toArray str[_tmp, _playerUID];
	{_gearData pushBack (_x * serverSalt);} forEach _tmp;
	diag_log format["[Persistence] - %1's gear has been encrypted", name player];
	sleep 10;
};
while {_savingSettings} do {
	private ["_tmp","_settingsData"]; 
	_tmp = toArray str[viewDistance, {if (isNil "terraindetail") then { 1; } else { terraindetail;},_playerUID];
	diag_log format["[Persistence] - %1's settings has been saved to a variable", name player];
	{_settingsData pushBack (_x * serverSalt);} forEach _tmp;
	diag_log format["[Persistence] - %1's settings has been encrypted", name player];
	sleep 900;
};
while {_savingGroup} do {
	private ["_tmp","_groupData"]; 
	_tmp = [group player, _playerUID];
	diag_log format["[Persistence] - %1's group has been saved to a variable", name player];
	{_groupData pushBack (_x * serverSalt);} forEach _tmp;
	diag_log format["[Persistence] - %1's group has been encrypted", name player];
	sleep 180;
};
while {_savingVehicle} do {
	private ["_tmp","_vehicleData"]; 
	if (vehicle player != player) then {
		while {true} do {
			_tmp = toArray str[assignedVehicleRole player,_playerUID];
			diag_log format["[Persistence] - %1's vehicle position has been saved to a variable", name player];
			{_vehicleData pushBack (_x * serverSalt);} forEach _tmp;
			diag_log format["[Persistence] - %1's group has been encrypted", name player];
			sleep 8;
		};
	} else {
		_tmp = toArray str(_vehicleData = nil);
		diag_log format["[Persistence] - %1's vehicle position has been saved to a variable", name player];
		{_vehicleData * serverSalt);} forEach _tmp;
		diag_log format["[Persistence] - %1's group has been encrypted", name player];
	};
	sleep 10;
};
while {_savingMedical} do {
<<<<<<< HEAD
    private ["_tmp","_medicalData"];
    _tmp = player call cse_fnc_getAllSetVariables;
    diag_log format["[Persistence] - %1's medical state has been saved to a variable", name player];
    _medicalData = toArray str[_medicalData, _playerUID];
    {_medicalData pushBack (_x * serverSalt);} forEach _tmp;
    diag_log format["[Persistence] - %1's medical state has been encrypted", name player];
    sleep 2;
=======
	private ["_tmp","_medicalData"];
	_tmp = player call cse_fnc_getAllSetVariables;
	{_medicalData pushBack (_x * serverSalt);} forEach _tmp;
	_medicalData = toArray str[_medicalData, _playerUID];
	sleep 2;
>>>>>>> origin/master
};
while {_savingHash} do {
  	for "_i" from 0 to (count _varNames) -2 do {
  		private ["_xData","_savingX"];
		_xData = format["_%1Data",toLower _varNames select _i];
		_savingX = format["_saving%1",_varNames select _i];
		if(_savingX) then {
			_hashPart = [_xData, serverHash] call RETR_fnc_dataHash;
			_hashData pushBack _hashPart;
		};
	};
	sleep 2;
};

//Save the Data
while {true} do {
	with profileNamespace do {
		for "_i" from 0 to (count _varNames) -1 do {
			private ["_xData","_savingX","_persistenceDataX"];
			_xData = format["_%1Data",toLower _varNames select _i];
			_savingX = format["_saving%1",_varNames select _i];
			_persistenceVarX = _persistenceVarName select _i + 1;// +1 so we don't overwrite the authentication data
			if(_savingX && _xData != _persistenceVarX) then {// make sure we aren't overwriting the same thing
				_persistenceVarX = reverse _xData;
				diag_log format["[Persistence] - %1 was saved to %2's profileNamespace", _xData, name player];
			};
		};
	/*
	if (_i != 0) then {
		_count = _count + count _xData;
	} else {
		_count = count _xData;
	};
	private ['_count','_cVar'];
	_count = 0;
	_count = [_persistenceVarName,_count];
	_cVar = find [_persistenceVarName];
	if(_cVar == -1) then {
		RETR_persitance_server pushBack [_persistenceVarName,_count]
		publicVariable "RETR_persitance_server";
	} else {
		_cVar = (RETR_persitance_server select _cVar) select 1;
		RETR_persitance_server set[_cVar,_count];
		publicVariable "RETR_persitance_server";
	};
	*/
	sleep 2;
};
