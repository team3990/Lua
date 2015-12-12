m = {}
m.name = "moo foo"

direction = true -- In. Out = false
startloop      = 0
function m.init(_direction)
	direction = _direction[1] -- Oui ou non
	startloop = autocounter + 1 -- Si vers l'extérieur, il utilisera le nombre de tours pour s'arreter. Sinon, il utilisera la switch bidon.
	if(_direction) then m.name = "Ramasser le ballon" 
	else m.name = "Evacuer le ballon" end
	
end

function m.body()
	print("IN RAMASSEUR BODY :DD")
	MoteurRamasseur = config.OUT_RamasseurSpeed
	if(not direction) then
		MoteurRamasseur = -MoteurRamasseur
	
	end
	
end


function m.isdone()
	cond = ((direction and RamasseurSwitch) or (not direction and (autocounter - startloop) > config.VAL_RamasseurLoops))
	if cond then 
		MoteurRamasseur = 0 
		if(RamasseurSwitch) then 
			print ("Switch active, ballon a l'interieur")
			
		else
			print ("Ballon a l'exterieur")
		
		end
	end
	return cond
end

return m