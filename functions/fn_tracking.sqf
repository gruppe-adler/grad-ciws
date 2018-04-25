if !(isServer) exitwith {};
if (defender_array isEqualTo []) exitWith {};

defense_status = true;
{
  _x setVariable ["ciws_activ", false];
}forEach defender_array;

[
  {
    params ["_args", "_handle"];

    if (shell_array isEqualTo []) then {
      defense_status = false;
      [_handle] call CBA_fnc_removePerFrameHandler;
    };

    {
      switch (true) do {
        case (isNull _x || !(canFire _x) ) : {
          defender_array deleteAt _forEachIndex;
        };
        case (_x getVariable "ciws_activ") : {};
        default {

          private _defender = _x;
          private _minRange   = getNumber (missionConfigFile >> "ciwsDefenderSetup" >> (typeOf _defender) >> "minRange");
          private _maxRange   = getNumber (missionConfigFile >> "ciwsDefenderSetup" >> (typeOf _defender) >> "maxRange");

          private _shellArray = [0,9999999999999999];
          {
            if (isNull _x) then {
              shell_array deleteAt _forEachIndex;
            }else{
              private _distance = _defender distance _x;
              if (_distance > _minRange && _distance < _maxRange && ((_shellArray select 1) > _distance) && !(_x getVariable ["ciws_allready_targeted", false])) then {
                _shellArray = [_x, _distance];
              };
            };
          }forEach shell_array;

          if !(_shellArray isEqualTo [0,9999999999999999]) then {
            (_shellArray select 0) setVariable ["ciws_allready_targeted", true];
            [_defender, (_shellArray select 0)] call grad_ciws_fnc_fire;
          };
        };
      };
    }forEach defender_array;
  },
  2,
  []
] call CBA_fnc_addPerFrameHandler;
