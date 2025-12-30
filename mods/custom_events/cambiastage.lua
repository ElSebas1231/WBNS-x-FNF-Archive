function onEvent(name,v1,v2)
    if name == 'cambiastage' then
        if v1 == 'aquino' then
            cantaaquino = true
            cantaduxo = false
            cantaloco = false
        end
        if v1 == 'loco' or v1 == 'locochon' then
            cantaaquino = false
            cantaduxo = false
            cantaloco = true
        end
        if v1 == 'duxo' then
            cantaaquino = false
            cantaduxo = true
            cantaloco = false
        end
        if v1 == 'nadie' then
            cantaaquino = false
            cantaduxo = false
            cantaloco = false
        end
    end
end