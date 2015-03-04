/*
* @function RETR_fnc_persistenceSaver
* @author CameronHall "Retra"
* Input: none.
* Output: Saves data to profileNamespace.
*/
private ["_persistenceVarName","_persistenceData","_missionName","_missionIntro","_missionLoadName","_missionAuthor","_playerUID","_positionData","_gearData","_settingsData","_groupData","_vehicleData","_medicalData","_savingPosition","_savingGear","_savingSettings","_savingGroup","_savingVehicle","_savingMedical","_tmp"];
_persistenceVarName = str(toArray(format["RETR_persitance_%1",getPlayerUID]));
_persistenceData = profileNamespace getVariable _persistenceVarName;
_varNames = ["Position","Gear","Settings","Group","Vehicle","Medical","Hash"];
//Define array if it doesn't exist
if (isNil _persistenceVarName) then {
	_persistenceData = ["authenticate","position","gear","misc","group",nil,"cse"];
	profileNameSpace setVariable [_persistenceVarName,_persistenceData];
};

//Lazier way to define variables
for "_i" from 0 to (count _varNames) -1} do {
	if (isNil _this select _i) then {// In case no arguments are defined when the script is called eg. call RETR_fnc_persistenceSaver
		_tmp = format["_saving%1",_varNames select _i];
		missionNamespace setVariable [_tmp, true];
	} else {//If it is defined then assign the bool value to a variable [true, true, true, true] call RETR_fnc_perstistenceSaver
		_tmp = format["_saving%1",_varNames select _i]; 
		missionNamespace setVariable [_tmp, _this select _i;];
	};
	_tmp = format["_%1Data",toLower _varNames select _i];
	missionNamespace setVariable [_tmp, []];
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
	_tmp = getPosATL player;
	_tmp = _tmp pushBack _playerUID;
	_tmp = toArray str _tmp;
	{_positionData pushBack (_x * serverSalt);} forEach _tmp
};
while {_savingGear} do {
	_tmp = [player, ["repetitive"]] call aero_fnc_get_loadout;
	_tmp = toArray str(_gearData pushBack _playerUID);
	{_gearData pushBack (_x * serverSalt);} forEach _tmp;
	sleep 10;
};
while {_savingSettings} do {
	_tmp = toArray str[viewDistance, {if (isNil "terraindetail") then { 1; } else { terraindetail;},_playerUID];
	{_settingsData pushBack (_x * serverSalt);} forEach _tmp;
	sleep 900;
};
while {_savingGroup} do {
	_tmp = [group player, _playerUID];
	{_groupData pushBack (_x * serverSalt);} forEach _tmp;
	sleep 180;
};
while {_savingVehicle} do {
	if (vehicle player != player) then {
		while {true} do {
			_tmp = toArray str[assignedVehicleRole player,_playerUID];
			{_vehicleData pushBack (_x * serverSalt);} forEach _tmp;
			sleep 10;
		};
	};
};
while {_savingMedical} do {
	_tmp = player call cse_fnc_getAllSetVariables;
	_medicalData = toArray str(_medicalData pushBack _playerUID);
	{_medicalData pushBack (_x * serverSalt);} forEach _tmp;
	sleep 2;
};
while {_savingHash} do {
  	for "_i" from 0 to (count _varNames) -2 do {
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
	private ['_xData','_savingX','_persistenceVarX','_count','_cVar'];
	_count = 0;
	for "_i" from 0 to (count _varNames) -1 do {
		_xData = format["_%1Data",toLower _varNames select _i];
		_savingX = format["_saving%1",_varNames select _i];
		_persistenceVarX = _persistenceVarName select _i;
		if(_savingX && (_xData != _persistenceVarX)) then {
			_persistenceVarX = reverse _xData;
		};
		if (_i != 0) then {
			_count = _count + count _xData;
		} else {
			_count = count _xData;
		};
	};
	/*_count = [_persistenceVarName,_count];
	_cVar = find [_persistenceVarName];
	if(_cVar == -1) then {
		RETR_persitance_server pushBack [_persistenceVarName,_count]
		publicVariable "RETR_persitance_server";
	} else {
		_cVar = (RETR_persitance_server select _cVar) select 1;
		RETR_persitance_server set[_cVar,_count];
		publicVariable "RETR_persitance_server";
	};*/
};


