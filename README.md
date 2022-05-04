# csQuery

An attempt at creating a jQuery-like library for CS:GO's Vscript API. Is it really useful? Maybe not... You will have to find out.

## Instructions

1. Download ***csQuery.nut*** from the latest stable release and place it in `csgo/scripts/vscripts`.

2. Reference it in a script. Referencing it multiple time will not impact performance.
   Example: `IncludeScript("csQuery")`

3. You can start ~~thinking about how stupid this idea is~~ using csQuery!

## Getting Started

Just like in the inspiration of this library, in order to do stuff with entities you first need to select these entities.
There are 4 selectors:

- `.`: Classname
- `#`: Targetname
- `*`: Everything
- `!`: First

```squirrel
local texts = csQuery.Find(".point_worldtext");
local text_1 = csQuery.Find("#text_1");
local all = csQuery.Find('*');
local first = csQuery.Find('!');
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

// Set the given KeyValue.
QueryArray SetKeyValue(string key, object value);

// Hides the entities by setting their rendermodes to 10 (Don't render) and, if not asked otherwise, solidity to 0 (Not solid).
QueryArray Hide(bool removeCollisions = true);
// Shows the entities by setting their rendermodes and collisionmodes to the default/given ones.
QueryArray Show(int rendermode = 0, int collisions = 6);

// Fires the given input (action) of the entities passing several optional parameters if given.
QueryArray EntFire(string action, string value = "", float delay = 0.0, CBaseEntity activator = null, CBaseEntity caller = null);

// Starts listening for the given output. In case it fires, the callback is called. The id is used to stop listening.
QueryArray On(string output, function callback, string id);
// Stops listening to the given output. The callback removed is the one identified with the id.
QueryArray Off(string output, string id);

// Saves the given value under the given key in the first entity's scope. 
// NOTE: Data saved will be stored throughout the entire match.
QueryArray SaveData(string key, object value);
// Returns whether data under the given key has already been stored in the first entity's scope.
bool HasData(string key);
// Returns the value under the given key in the first entity's scope. 
// NOTE: Will throw an exception if SaveData() has not been used at all.
object GetData(string key);
// Returns a table which contains all data stored in the first entity's scope through SaveData().
// NOTE: Will throw an exception if SaveData() has not been used at all.
table GetData();

// The passed function is used as a test for each entity in the array. `this` (environment object) is the current entity.
QueryArray Filter(function fltr);

// Precaches each model in the array. Don't worry, each model is precached only once.
QueryArray PrecacheModels(string[] models);

// Returns the number of entities in the array.
int Length();

// Returns the CBaseEntity handle of the entity with the given index.
QueryArray Get(int index);
// Returns a QuerryArray with only the entity with the given index.
CBaseEntity Eq(int index);
// Returns a QuerryArray with only the first entity (typically worldspawn).
CBaseEntity First();
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
