params ["_shell"];

_shell setVariable ["ciws_allready_targeted", false];
shell_array pushBack _shell;

if !(defense_status) then {
  [] call grad_ciws_fnc_tracking;
};
