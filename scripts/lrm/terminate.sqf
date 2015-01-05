{
	private "_vm_str";
	_vm_str = _x + "_vm";

	private "_vm";
	_vm = profileNamespace getvariable _vm_str;

	terminate _vm;
} foreach [lrm_core_str, lrm_gear_str, lrm_misc_str, lrm_radio_str, lrm_team_str, lrm_vehicle_str];
