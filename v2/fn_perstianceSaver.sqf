// [[authenticate],[mapsquare,[player pos]],[gear],[misc],group,radio,[vehicle status],cse]
// Authenticate [_missionName,_missionIntro,_missionLoadName,_missionAuthor,_playerUID]
// Map Square [_mapData, [_positionData]]
// Gear 
// Misc
_persistenceVarName = str(toArray(format["RETR_persitance_%1",getPlayerUID]));
_persistenceData = profileNamespace getVariable _persistenceVarName;
//Define array if it doesn't exist
if (isNil _persistenceData) then {
	_persistenceData = ["authenticate","position","gear","misc","group",nil,"cse"];
};
//Authentication Principals
_missionName = getText(missionConfigFile >> "onLoadMission");
_missionIntro = getText(missionConfigFile >> "onLoadIntro");
_missionLoadName = getText(missionConfigFile >> "onLoadName");
_missionAuthor = getText(missionConfigFile >> "author");
_playerUID = (getPlayerUID player); 
//Data to save
with profileNamespace do {
	_persistenceVarName select 0 =  toArray str[_missionName,_missionIntro,_missionLoadName,_missionAuthor,_playerUID];
};
//Saving Position Loop
while _savingPosition do {
	_positionData = getPosATL player;
	_positionDataArray = toArray str[_positionData,_playerUID];
	sleep 10;
};
while _savingGear do {
	_gearData = [player, ["repetitive"]] call aero_fnc_get_loadout;
	_gearData = toArray str(_gearData pushBack _playerUID);
	sleep 10;
};
while _savingSettings do {
	_settingsData = toArray str[viewDistance, {if (isNil "terraindetail") then { 1; } else { terraindetail;},_playerUID];
	sleep 900;
};
while _savingGroup do {
	_groupData = toArray str[group player,_playerUID];
		sleep 180;
};
while _savingVehicleState do {
	if (vehicle player != player) then {
		while true do {
			_vehicleData = toArray str[assignedVehicleRole player,_playerUID];
			sleep 10;
		};
	};
};
while _savingCSE do {
	_medicalData = player call cse_fnc_getAllSetVariables;
	_medicalData = toArray str(_medicalData pushBack _playerUID);
	sleep 5;
};
//Hash and save the Data
while true do {
	with profileNamespace do {
		if (_savingPosition) then {
			_persistenceVarName select 1 = _positionDataArray;
		};
		if (_savingGear) then {
			_persistenceVarName select 2 = _gearData;
		};
		if (_savingSettings) then {
			_persistenceVarName select 3 = _settingsData;
		};
		if (_savingGroups) then {
			_persistenceVarName select 4 = _groupData;
		};
		if (_savingVehicleState) then {
			_persistenceVarName select 5 = _vehicleData;
		};
		if (_savingMedicalData) then {
			_persistenceVarName select 6 = _medicalData;
		};
	};
};


