if ("csQuery" in getroottable() && typeof ::csQuery == "table" )
    return;

::csQuery <- {};

IncludeScript("csQuery/QueryArray");

csQuery.SELECTOR <- {
    CLASS = 46, // .
    TARGETNAME = 35, // #
    ALL = 42, // *
    FIRST = 33 // !
}

local findBy = function(findFunction, arg) {
    local ents = [];
    for (local ent; ent = findFunction.call(Entities, ent, arg); )
    {
        ents.push(ent);
    }
    return ents;
}

local all = function() {
    local ents = [];
    for (local ent; ent = Entities.Next(ent); )
    {
        ents.push(ent);
    }
    return ents;
}

function csQuery::Find(query) : (findBy, all) {
    if (typeof query == "instance")
        return QueryArray( query );

    if (typeof query != "string" && typeof query != "integer")
        throw "The parameter's data type is invalid (Valid Types: class instance, string, char)";

    local selector = query[0];
    local body = query.slice(1);

    switch (selector) {
        case SELECTOR.CLASS:
            return QueryArray( findBy(Entities.FindByClassname, body) );
        case SELECTOR.TARGETNAME:
            return QueryArray( findBy(Entities.FindByName, body) );
        case SELECTOR.ALL:
            return QueryArray( all() );
        case SELECTOR.FIRST:
            return QueryArray( Entities.Next(null) );
        default:
            throw "The parameter has an invalid selector";
    }
}