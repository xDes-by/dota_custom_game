function indexOf(arr,var)
    for k,v in pairs(arr) do
        if v == var then
            return k
        end
    end
    return false
end

function indexOfStringInVar(arr,var)
    for k,v in pairs(arr) do
        if string.find(var, v) then
            return k
        end
    end
    return false
end
