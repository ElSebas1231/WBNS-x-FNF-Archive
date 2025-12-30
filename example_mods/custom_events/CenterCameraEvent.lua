function onEvent(name,v1,v2)
	if name == "CenterCameraEvent" then
		if v1 ~= "on" and v1 ~= "off" then
			v1 = "on"
		end
		if v2 == "" then
			v2 = "700, 450"
		end
		local drain = split(v2, ",")
		if v1 == 'on' then
			function onUpdate()
				triggerEvent('Camera Follow Pos', tonumber(drain[1]), tonumber(drain[2]))
			end
		end
		if v1 == 'off' then
			function onUpdate()
				triggerEvent('Camera Follow Pos', '', '')
			end
		end
	end
end
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, tostring(match));
    end
    return result;
end