params ["_vehicle"];

_vehicle addEventHandler ["Fired", {
  [_this select 6] call grad_ciws_fnc_eventHandler;}
];
