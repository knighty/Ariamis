local Debugger = {}

local profilers = {}

function Debugger.GetProfiler(name)
	return profilers[name]
end

function Debugger.GetProfilers()
	return profilers
end

function Debugger.CreateProfilers()
	profilers = {}
	profilers.paint = game.create_profiler()
	profilers.noise = game.create_profiler()
	profilers.getTiles = game.create_profiler()
end

return Debugger