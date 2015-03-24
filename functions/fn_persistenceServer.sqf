/*
* @function RETR_fnc_persistenceServer
* @author CameronHall "Retra"
* @args none
* Input: Static defined vars, ["mission","serverSalt","hashData","date"] 
* Output: Saves above to profileNamespace
*/
if !(isServer) exitWith {diag_log "[Persistence] - This function is designed for servers only.";};
private ['_persistenceData','_varNames','_loadData','_missionIntro','_missionAuthor','_missionLoadName','_argsArray'];
_persistenceData = profileNamespace getVariable "RETR_persistenceServer";
_varNames = ["mission","serverSalt","hash","date"];
_loadData = "";
_missionData = [];
if (isNil "_persistenceData") then {//RETR_persistence has never been run
	profileNameSpace setVariable ["RETR_persistenceServer",_varNames];
	_persistenceData = profileNamespace getVariable "RETR_persistenceServer";
	for "_i" from 0 to (count _persistenceData) -1 do {
		private "_xData";
		_xData = format["_%1Data", _varNames select _i];
		missionNamespace setVariable [_xData,"placeholder"];
	};
	_loadData = false;
} else { //RETR_persistence has been run
	for "_i" from 0 to (count _persistenceData) -1 do {//Fetch data
		_xData = format["_%1Data", _varNames select _i];
		missionNamespace setVariable [_xData,_persistenceData select _i];
	};
	_loadData = true;
};
_missionName = getText(missionConfigFile >> "onLoadMission");
_missionIntro = getText(missionConfigFile >> "onLoadIntro");
_missionLoadName = getText(missionConfigFile >> "onLoadName");
_missionAuthor = getText(missionConfigFile >> "author");
_missionDataCurrent = [_missionName,_missionIntro,_missionLoadName,_missionAuthor];

//If no data has been saved 
if (!_loadData) then {
	//Data to save
	serverSalt = floor(random 1000);
	serverHash = ceil(random 1000);
	publicVariable "serverSalt";
	publicVariable "serverHash";
	waitUntil{!isNil "serverSalt" && !isNil "serverHash";};
	_argsArray = [_missionDataCurrent, serverSalt, serverHash, date];
	for "_i" from 0 to (count _argsArray) -2 do {
		_persistenceVarX = _persistenceData select _i;
		profileNamespace setVariable [_persistenceVarX,_argsArray select _i];
	};
} else {//If data exists then load it
	//If data is not for the current mission then delete saved data and restart the function
	waitUntil{!isNil "_missionData"};
<<<<<<< HEAD
	if !(_missionDataCurrent isEqualTo _missionData) exitWith {
=======
	if(_missionDataCurrent isEqualTo _missionData) exitWith {
>>>>>>> origin/master
		profileNameSpace setVariable ["RETR_persistenceServer",nil];
		call RETR_fnc_persistenceServer;
	};
	serverSalt = _serverSaltData;
	publicVariable "serverSalt";
	serverHash = serverHashData;
	publicVariable "serverHash";
	setDate _dateData;
};
//Update date once per hour
while {true} do {
	with profileNamespace do {
     _persistenceVarX = _persistenceData select 3;
    _persistenceVarX = date;
};
	sleep 3600;
};
