if ( !("csQuery" in getroottable()) || typeof ::csQuery != "table" )
    throw "csQuery not found. Make sure you are not directly referencing this script, instead reference csQuery.nut";

class csQuery.QueryArray {
    constructor(_entArray) {
        if (typeof _entArray == "array") {
            entArray = _entArray;
            return;
        }
            
        if (typeof _entArray == "weakref") {
            entArray = [ _entArray ];
            return;
        }
            
        throw "The parameter's data type is invalid (Valid Types: array, weak reference)";
    }

    entArray = null;

    function Each(callback) {
        foreach (ent in entArray) {
            callback.call(this, ent);
        }
        return this;
    }

    function EachWithIndex(callback) {
        for (local i = 0; i < entArray.len(); i++) {
            callback.call(this, i, entArray[i]);
        }
        return this;
    }

    function SetKeyValue(key, value) {
        this.Each(function (ent) : (key, value) {
            switch (typeof value)
            {
                case "bool":
                case "integer":
                    ent.__KeyValueFromInt( key, value.tointeger() );
                    break;

                case "float":
                    ent.__KeyValueFromFloat( key, value );
                    break;

                case "string":
                    ent.__KeyValueFromString( key, value );
                    break;

                case "Vector":
                    ent.__KeyValueFromVector( key, value );
                    break;

                default:
                    throw "Invalid input type: " + typeof value;
            }
        });
        return this;
    }

    function Hide(removeCollisions = true) {
        this.SetKeyValue("rendermode", 10);
        if (removeCollisions == true)
            this.SetKeyValue("solid", 0);
        return this;
    }

    function Show(rendermode = 0, collisions = 6) {
        this.SetKeyValue("rendermode", rendermode);
        if (collisions)
            this.SetKeyValue("solid", collisions);
        return this;
    }

    function EntFire(action, value = "", delay = 0.0, activator = null, caller = null) {
        this.Each(function (entity) : (action, value, delay, activator , caller) {
            EntFireByHandle(entity, action, value, delay, activator, caller);
        })
        return this;
    }

    function On(output, callback, id = null) {
        this.Each(function(ent) : (output, callback, id) {
            ent.ValidateScriptScope();
            local scope = ent.GetScriptScope();
            local _id = id; // Free variables are read-only

            if (_id == null)
                _id = UniqueString("OutputID_");

            scope[_id] <- callback;
            ent.ConnectOutput( output, _id );
        })
        return this;
    }

    function Off(output, id) {
        this.Each(function (ent) : (output, id) {
            ent.DisconnectOutput( output, id )
            local scope = ent.GetScriptScope();
            delete scope[id];
        });
        return this;
    }
    
    function SaveData(key, value) {
        local ent = this.Get(0);
        ent.ValidateScriptScope();
        local scope = ent.GetScriptScope();
        if (!("customData" in scope))
            scope.customData <- {};
        scope.customData[key] <- value;
        return this;
    }

    function HasData(key) {
        local ent = this.Get(0);
        ent.ValidateScriptScope();
        local scope = ent.GetScriptScope();

        if ("customData" in scope && key in scope.customData)
            return true;

        return false;
    }

    function GetData(key = null) {
        local ent = this.Get(0);
        ent.ValidateScriptScope();
        local scope = ent.GetScriptScope();

        if (!("customData" in scope))
            throw "Data table has not been created";

        if (key)
            return scope.customData[key];
        else 
            return scope.customData;
    }

    function Filter(fltr) {
        local approvedEntities = [];
        this.Each(function (ent) : (fltr, approvedEntities) {
            if ( fltr.call(ent) )
                approvedEntities.push(ent);
        });
        return csQuery.QueryArray(approvedEntities);
    }

    function PrecacheModels(models) {
        foreach(model in models){
            this.Get(0).PrecacheModel(model);
        }
        return this;
    }

    function Length() {
        return entArray.len();
    }

    function Eq(index) {
        return csQuery.QueryArray(entArray[index]);
    }

    function First() {
        return csQuery.QueryArray(entArray[0]);
    }

    function Get(index) {
        return entArray[index];
    }
}