require("config")
m = {}



-- Table functions lua badly lacks
function m.append(_table, item)
	_table[#_table + 1] = item
end

function m.extend(_table, extension)
	for i = 1, #extension do
			_table[#_table + 1] = extension[i]
	end
end

function m.count(_table, item)
	local count = 0
	for i = 1, #_table do 
		count = count + ((_table[i] == item) and 1 or 0)
	
	end
	return count

end


function m.remove(_table, item)
	newtable = {}
	for i = 1, #_table do
		if(_table[i] ~= item) then newtable[#newtable + 1] = _table[i] end
	
	end
	
	for i = 1, #_table do
		if(i <= #newtable) then
			_table[i] = newtable[i]
			
		else
			_table[i] = nil
		end
	end

end

function m.tableindex(_table, start, _end)
	local index = {}
	for i = start, (_end > 0 and _end or #_table + _end) do
		index[#index + 1] = _table[i]
		
	end
	return index
end

function m.foreach(_table, _function, step)
	if(not step) then step = 1 end
	
	local start  = 1;
	local _end   = #_table;
	if(step < 1) then
		start, _end = _end, start
	end
		
	for i = start, _end, step do
		_function(_table[i])
	end
	
end

-- Other semi-useful stuff
function prettyprinter(_table, indent)
	local tabindent =  string.rep("  ", indent)
	print (tabindent.."{")
	for i = 1, #_table do
		if(type(_table[i]) == type({}) and _table[i][1]) then
			prettyprinter(_table[i], indent + 1)
		
		else
			print(tabindent .." "..i..": ".. tostring(_table[i]))
			
		end
	end
	print (tabindent.."}")
end



function m.prettyprinter(_table)
	prettyprinter(_table, 0)
end

function m.safecall(func, errmsg)
	success, result = pcall(func)
	if(not success) then
		print(config.STR_NoticeSeparator)
		print(errmsg)
		if(result.msg) then result = result.msg end
		
		print("EXC: "..result)
		if(not config.SYS_debug) then
			error(result)
		end
		result = nil
	end
	
	return success, result
end

-- Found on the internets here: http://lua-users.org/wiki/CopyTable. 
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function m.deepcopy(orig) return deepcopy(orig) end

function m.listdir(dir)
	if not config.SYS_dircmd then return {} end
	if not dir then dir = "" end
	
	result = io.popen(string.format(config.SYS_dircmd, dir)):read("*a"):split()
	if(#result > 0) then
		x, y = result[1]:find(config.F_separator)
		if(x) then
			-- Absolute path is evil
			newresult = {}
			for i = 1, #result do
				splitpath = split(result[i], config.F_separator)
				newresult[i] = splitpath[#splitpath]
			end
			result = newresult

		end
	end
	return result
end




return m



