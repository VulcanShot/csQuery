if ("csQuery" in getroottable() && typeof ::csQuery == "table" )
    return;

::csQuery <- {};

IncludeScript("csQuery/QueryArray")

csQuery.SELECTOR <- {
    CLASS = 46, // .
    TARGETNAME = 35, // #
    ALL_OR_FIRST = 42 // *
}

function csQuery::Find(query) {
    if (typeof query == "instance")
        return QueryArray([query]);

    if (typeof query != "string" && typeof query != "integer")
        throw "The parameter's data type is invalid (Valid Types: class instance, string, char)"

    local _selector = query[0];
    local body = query.slice(1);
    local output;

    switch (_selector) {
        case SELECTOR.CLASS:
            output = findBy(Entities.FindByClassname, body);
            break;
        case SELECTOR.TARGETNAME:
            output = findBy(Entities.FindByName, body);
            break;
        case SELECTOR.ALL_OR_FIRST:
            if (body == "*") {
                output = first();
                break;
            }
            output = next();
            break;
        default:
            throw "The parameter has an invalid selector"
    }

    return QueryArray(output);
}

local findBy = function(findFunction, arg) {
    local ents = [];
    for (local ent; ent = findFunction.call(Entities, ent, arg); )
    {
        ents.push(ent);
    }
    return ents;
}

local next = function() {
    local ents = [];
    for (local ent; ent = Entities.Next(ent); )
    {
        ents.push(ent);
    }
    return ents;
}

local first = function() {
    return [ Entities.Next(null) ];
}