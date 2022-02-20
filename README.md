# csQuery

An attempt at creating a jQuery-like library for CS:GO's Vscript API. Is it really useful? Maybe not... You will have to find out.

## Instructions

1. Download ***csQuery.nut*** from the latest stable release and place it in `csgo/scripts/vscripts`.

2. Reference ***csQuery.nut*** in a script. Referencing it multiple time will not impact performance.
   Example: `IncludeScript("csQuery")` (note that if you place it in a folder, the parameter would be `"folder/csQuery"`)

3. You can start ~~thinking about how stupid this idea is~~ using csQuery!

## Getting Started

Just like in the inspiration of this library, in order to do stuff with entities you first need to select these entities.
There are 3 (or 4) selectors:

- `.`: Classname
- `#`: Targetname
- `*`: Everything
- `**`: First

```squirrel
local texts = csQuery.Find(".point_worldtext");
local text_1 = csQuery.Find("#text_1");
local first = csQuery.Find("**");
local all = csQuery.Find("*");
```

In addition, you can also pass a `CBaseEntity` instance as the argument.

```squirrel
local player = csQuery.Find(activator);
```

## Functions

```cs
// Calls the callback for every entity. The callback will be pased the CBaseEntity as an argument.
QueryArray Each(function callback);
// Calls the callback for every entity. The callback will be pased the CBaseEntity and the index of it in the array as an argument.
QueryArray EachWithIndex(function callback);

// Set the given KeyValue to the given Value
QueryArray SetKeyValue(string key, object value);

// Hides the entities by setting their rendermodes to 10 (Don't render) and, if not asked otherwise, solidity to 0 (Not solid)
QueryArray Hide(bool removeCollisions = true);
// Shows the entities by setting their rendermodes and collisionmodes to the default/given ones
QueryArray Show(int rendermode = 0, int collisions = 6);

// Fires the given input (action) of the entities passing several optional parameters if given.
QueryArray EntFire(string action, string value = "", float delay = 0.0, CBaseEntity activator = null, CBaseEntity caller = null);

// Starts listening for the given output. In case it fires, the callback is called. The id is used to stop listening.
QueryArray On(string output, function callback, string id);
// Stops listening to the given output. The callback removed is the one identified with the id
QueryArray Off(string output, string id);

// Data functions not recommended when dealing with multiple entities
// Saves the given value with the given identification (key). IMPORTANT: Data saved will 'live' throughout all rounds.
QueryArray SaveData(string key, object value);
// Returns Whether data under the given key has already been stored. Will not throw an exception if SaveData() has never been used before.
bool HasData(string key);
// Returns an array of objects which match with the given key. Will throw an exception if SaveData() has never been used before.
object[] GetData(string key);
// Returns an array of tables which contain all data stored through SaveData(). Will throw an exception if SaveData() has never been used before.
table[] GetAllData();

// Precaches each model in the array. Don't worry, each model is precached only once
QueryArray PrecacheModels(string[] models);

// Returns the number of entities in the array
int Length();

// Returns a QuerryArray with only the entity with the given index
QueryArray Get(int index);
// Returns a QuerryArray with only the first entity in the array
QueryArray GetFirst();
// Returns the handle of the entity with the given index
CBaseEntity Eq(int index);
// Returns the handle of the first entity in the array
CBaseEntity EqFirst();
```

## Examples

```squirrel
csQuery.Find(".point_worldtext").SetKeyValue("message", "Hello World");

csQuery.Find("#my_trigger_once").On("OnTrigger", function() {
    printl("My trigger has been triggered!")
}, "FooBar");

// Note that you can chain any of the functions together (except the ones which do not return `QueryArray`).
csQuery.Find("#my_prop_dynamic").Hide().SetKeyValue("skin", 1);
```
