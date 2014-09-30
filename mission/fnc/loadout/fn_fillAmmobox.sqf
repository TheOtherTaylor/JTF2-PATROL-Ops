private["_cache","_rank","_timer"];

_cache = _this select 0;
_data = [];

waitUntil {!isNull player};

player reveal _cache;

while {alive _cache} do {

	_data = call PO3_fnc_getCfgPO3Loadout;

	if(isNil "_data") exitWith{};

	_class = player getVariable ["PO3_VAR_roleAttribute","Rifleman"];
	_rank = rank player;
	_timer = 30;

	{deleteVehicle _x} foreach nearestObjects [position _cache,["WeaponHolder"],50];

	clearMagazineCargo _cache;
	clearWeaponCargo _cache;
	clearItemCargo _cache;
	clearBackpackCargo _cache;

//	_magazinecapacity  = 300 max ( (getNumber (configFile >> "CfgVehicles" >> typeOf _cache >> "transportMaxMagazines")) min 1400);

//	{ _cache addWeaponCargo [_x, 1]; } foreach (_data select 0);
//	{ _cache addMagazineCargo [_x, 20]; } foreach (_data select 1);
//	{ _cache addItemCargo [_x, 1]; } foreach (_data select 2);
//	{ _cache addBackpackCargo [_x, 1]; } foreach (_data select 3);
//	{ _cache addItemCargo [_x, 1]; } foreach (_data select 4);
//	{ _cache addItemCargo [_x, 1]; } foreach (_data select 5);
	
	// Remove all the virtual things from the box
	[_cache, ([_cache] call BIS_fnc_getVirtualBackpackCargo)] call BIS_fnc_removeVirtualBackpackCargo;
	[_cache, ([_cache] call BIS_fnc_getVirtualItemCargo)] call BIS_fnc_removeVirtualItemCargo;
	[_cache, ([_cache] call BIS_fnc_getVirtualMagazineCargo)] call BIS_fnc_removeVirtualMagazineCargo;
	[_cache, ([_cache] call BIS_fnc_getVirtualWeaponCargo)] call BIS_fnc_removeVirtualWeaponCargo;
	
	// Add all of the new virtual items we want in the box.
	[_cache, _data select 0] call BIS_fnc_addVirtualWeaponCargo;
	[_cache, _data select 1] call BIS_fnc_addVirtualMagazineCargo;
	[_cache, _data select 2] call BIS_fnc_addVirtualItemCargo;
	[_cache, _data select 3] call BIS_fnc_addVirtualBackpackCargo;
	[_cache, _data select 4] call BIS_fnc_addVirtualItemCargo;

	// Mark the object as an arsenal object
	["AmmoboxInit", [_cache, false, {true}]] call BIS_fnc_arsenal;

	waitUntil { sleep 10; _timer = _timer - 1; !(rank player == _rank && _timer > 0 && _class == player getVariable ["PO3_VAR_roleAttribute","Rifleman"]) };
};
