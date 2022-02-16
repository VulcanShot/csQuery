if ( !("csQuery" in getroottable()) || typeof ::csQuery != "table" )
    ::csQuery <- {};

IncludeScript("csgoQuery/QueryArray")

csQuery.SELECTOR <- {
    CLASS = 46, // .
    TARGETNAME = 35, // #
    ALL = 42 // *
}

function csQuery::Find(query) {
    if (typeof query == "instance") {
        return QueryArray([query]);

    if (typeof query != "string" && typeof query != "integer") {
        throw "The parameter's data type is invalid (Valid Types: class instance, string, char)"

    local _selector = query[0];
    local body = query.slice(1);
    local output;

    switch (_selector) {
        case SELECTOR.CLASS:
            output = FindBy(Entities.FindByClassname, body);
            break;
        case SELECTOR.TARGETNAME:
            output = FindBy(Entities.FindByName, body);
            break;
        case SELECTOR.ALL:
            if (body == "*") {
                output = First();
                break;
            } 
            output = Next();
            break;
        default:
            throw "The parameter has an invalid selector"
    }

    return QueryArray(output);
}

function csQuery::FindBy(findFunction, arg) {
    local ents = [];
    for (local ent; ent = findFunction.call(Entities, ent, arg); )
    {
        ents.push(ent);
    }
    return ents;
}

function csQuery::Next() {
    local ents = [];
    for (local ent; ent = Entities.Next(ent); )
    {
        ents.push(ent);
    }
    return ents;
}

function csQuery::First() {
    local ents = [];
    ents.push(Entities.Next(null));
    return ents;
}