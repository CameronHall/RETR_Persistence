// [[authenticate],[mapsquare,[player pos]],[gear],[misc],group,radio,[vehicle status],cse]
// Authenticate [_missionName,_missionIntro,_missionLoadName,_missionAuthor,_playerUID]
// Map Square [_gridPostionData, [_positionData]]
// Gear 
// Misc
waitUntil {getPlayerUID != "" && player == player};
_persistanceVarName = format ["RETR_persitance_%1",getPlayerUID];
_persistanceData = profileNamespace getVariable _persistanceVarName;
_missionName = getText(missionConfigFile >> "onLoadMission";
_missionIntro = getText(missionConfigFile >> "onLoadIntro"
_missionLoadName = getText(missionConfigFile >> "onLoadName";
_missionAuthor = getText(missionConfigFile >> "author";
_playerUID = (getPlayerUID player);
_authenticationData =  [_missionName,_missionIntro,_missionLoadName,_missionAuthor,_playerUID];
_persistanceData select 0 setVariable ["authentication",_authenticationData];
_mapSquare = player mapGridPosition;
_pos = getPosATL player;
_persistanceData = select 1 setVariable ["position", [_mapSquare,_pos]];
_gear = [player, ["repetitive"]] call aero_fnc_get_loadout;
_persistanceData select 2 setVariable ["gear",_gear];
_settings = [viewDistance, {if (isNil "terraindetail") then { 1; } else { terraindetail;}];
_persistanceData select 3 setVariable ["settings",_settings];
_group = group player;
_persistanceData select 4 setVariable ["group",_group];
private "_vehicle";
_vehicle = if (vehicle player != player) then {
	vehicle player;
} else {
	"%NULL%";
};

[
	_vehicle,
	assignedVehicleRole player
];
_persistanceData select 5 setVariable ["vehicle", _vehicle];
_medicalStatus = player call cse_fnc_getAllSetVariables;
_persistanceData select 6 setVariable ["CSE", _medicalStatus];


