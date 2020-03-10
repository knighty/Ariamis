local EventManager = {}

EventManager.classes = {}
EventManager.functions = {}

function EventManager.RegisterClass( className, class )
	if EventManager.classes[className] == nil then
		local classDefinition = {
			class = class,
			functions = {}
		}
		
		-- For every function, create a table entry that maps the function to a function definition
		-- Also create an entry in the class definition so we can map back to the function
		for key,variable in pairs(class) do		
			if type(variable) == "function" then
				local functionDefinition = { className = className, functionName = key }
				classDefinition.functions[key] = variable
				EventManager.functions[variable] = functionDefinition
			end
		end
		
		EventManager.classes[className] = classDefinition
	end
end

-- Handle a callback
-- Parameters are supplied in the order of parameters passed to this function then the ones set up with the callback
function EventManager.HandleCallback( callback, parameters )
	local fn = EventManager.classes[callback[1][1]].functions[callback[1][2]]
	
	-- Make sure we always have a parameters table
	if parameters == nil then
		parameters = {}
	end
	
	-- Append the "upvalues" on the callback to the parameters table as we cant `unpack` twice in a function call
	if callback[2] ~= nil then
		for _,p in pairs(callback[2]) do
			parameters[#parameters + 1] = p
		end
	end
	
	fn( unpack(parameters) )
end

function EventManager.CreateCallback( fn, parameters )
	-- Find the function name
	local functionDefinition = EventManager.functions[fn]
	return {		
		{ functionDefinition.className, functionDefinition.functionName },
		parameters
	}
end

return EventManager