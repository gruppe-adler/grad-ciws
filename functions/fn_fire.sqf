params ["_defender", "_shell"];

_defender setVariable ["ciws_activ", true];
(gunner _defender) doWatch _shell;
private _hitChance  = getNumber (missionConfigFile >> "ciwsDefenderSetup" >> (typeOf _defender) >> "hitChance");
[
  {
    params ["_args", "_handle"];
    _args params ["_defender", "_shell", "_hitChance"];

    if (isNull _shell || isNull _defender) exitWith {
      [_handle] call CBA_fnc_removePerFrameHandler;
      _defender setVariable ["ciws_activ", false];
    };

    _defender doWatch _shell;
    [_defender, (weaponState [_defender, [0]]) select 1, [0]] call BIS_fnc_fire;

    private _destroyChance = (floor random 100);
    if (_destroyChance < _hitChance) then {
      _explosion = "HelicopterExploSmall";
      _explosionEffect = _explosion createVehicle (getPosATL _shell);
      deleteVehicle _shell;
    };
  },
  0.05,
  [_defender, _shell, _hitChance]
] call CBA_fnc_addPerFrameHandler;

[
  {
    params ["_args", "_handle"];
    _args params ["_defender", "_shell", "_hitChance"];

    if (isNull _shell || isNull _defender) exitWith {
      [_handle] call CBA_fnc_removePerFrameHandler
    };

  },
  2,
  [_defender, _shell, _hitChance]
] call CBA_fnc_addPerFrameHandler;
