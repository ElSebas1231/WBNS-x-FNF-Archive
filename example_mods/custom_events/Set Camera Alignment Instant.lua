local camX = 1265;
local camY = 50;
local camX2 = 2100;
local camY2 = 50;
local camX3= 1600;
local camY3= 50;

function onEvent(name, value1, value2)
if name == 'Set Camera Alignment Instant' then
	if value1 == '0' and value2 == '2' then  
	  setProperty('cameraSpeed', 3)
     triggerEvent('Camera Follow Pos',camX,camY)
    end
    if value1 == '1' and value2 == '2' then  
	  setProperty('cameraSpeed', 3);
	  triggerEvent('Camera Follow Pos',camX2,camY2)
    end
    if value1 == '0.5' and value2 == '2' then  
	  setProperty('cameraSpeed', 3);
	  triggerEvent('Camera Follow Pos',camX3,camY3)
    end
    if value1 == '' and value2 == '2' then  
	  setProperty('cameraSpeed', 1);
    end
    end
    end