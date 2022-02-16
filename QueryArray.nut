if ( !("csQuery" in getroottable()) || typeof ::csQuery != "table" )
    throw "csQuery not found. Make sure you are not directly referencing this script, instead reference csQuery.nut";

class csQuery.QueryArray {
    constructor(_entArray){
        entArray = _entArray;
    }

    entArray = null;

    function Each(callback) {
        foreach (ent in entArray) {
            callback.call(this, ent)
        }
        return this;
    }

    function EachWithIndex(callback) {
        for (local i = 0; i < entArray.len(); i++) {
            callback.call(this, i, entArray[i])
        }
        return this;
    }

    function SetKeyValue(key, value) {
        // Credits to samisalreadytaken @ https://github.com/samisalreadytaken/vs_library/blob/4729726bb4506d6d93db913633cbdec6a4d07ac8/src/vs_entity.nut#L281
        switch (typeof value)
        {
            case "bool":
            case "integer":
                this.Each(function(ent) : (key, value)
                {
                    ent.__KeyValueFromInt( key, value.tointeger() );
                });
                break;

            case "float":
                this.Each(function(ent) : (key, value)
                {
                    ent.__KeyValueFromFloat( key, value );
                });
                break;

            case "string":
                this.Each(function(ent) : (key, value)
                {
                    ent.__KeyValueFromString( key, value );
                });
                break;

            case "Vector":
                this.Each(function(ent) : (key, value)
                {
                    ent.__KeyValueFromVector( key, value );
                });
                break;

            case "null":
                break;

            default:
                throw "Invalid input type: " + typeof value;
        }
        return this;
    }

    function Hide() {
        this.SetKeyValue("rendermode", 10);
        this.SetKeyValue("solid", 0);
        return this;
    }

    function Show(rendermode = 0, collisions = 6) {
        this.SetKeyValue("rendermode", rendermode);
        this.SetKeyValue("solid", collisions);
        return this;
    }

    function EntFire(action, value = "", delay = 0.0, activator = null, caller = null) {
        this.Each(function (entity) : (action, value, delay, activator , caller) {
            EntFireByHandle(entity, action, value, delay, activator, caller);
        })
        return this;
    }

    function On(output, callback, id) {
        this.Each(function (ent) : (output, callback, id) {
            ent.ValidateScriptScope();
            local scope = ent.GetScriptScope();
            scope[id] <- callback;
            ent.ConnectOutput( output, id );
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
    
    function SetData(key, value) {
        this.Each(function (ent) : (key, value) {
            ent.ValidateScriptScope();
            local scope = ent.GetScriptScope();
            if (!("customData" in scope))
                scope.customData <- {};
            scope.customData[key] <- value;
        });
        return this;
    }

    function GetData(key) {
        return getData(false, key)
    }

    function GetAllData() {
        return getData(true);
    }

    function getData(returnAll, key = null) {
        local env = { key = key, returnAll = returnAll, data = [] }
        this.Each(function (ent) {
            ent.ValidateScriptScope();
            local scope = ent.GetScriptScope();
            if (!("customData" in scope))
                throw "Data table has not been created";

            if (returnAll == true)
                data.push(scope.customData);
            else 
                data.push(scope.customData[key]);
        }.bindenv(env));
        return env.data;
    }

    function Length() {
        return entArray.len();
    }

    function Get(index) {
        return QueryArray([entArray[index]]);
    }

    function GetFirst() {
        return QueryArray([entArray[0]]);
    }

    function Eq(index) {
        return entArray[index];
    }

    function EqFirst() {
        return entArray[0];
    }
}
