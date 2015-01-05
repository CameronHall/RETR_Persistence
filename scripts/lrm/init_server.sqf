lrm_player_uids = [];

"lrm_uid_pveh"  addpublicvariableeventhandler {
	private "_uid";
	_uid = _this select 1;

	if (!(_uid in lrm_player_uids)) then {
		lrm_player_uids = lrm_player_uids + [_uid];
		publicvariable "lrm_player_uids";
	};
};
