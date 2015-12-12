Wrapper Lua, par Olivier Lalonde.

1) Pour ce qui est du (des) fichier(s) de commandes
	test.txt.  Chaque commande prend une ligne, dans la syntaxe suivante:
		->[module] [arguments]
		
	Pour l'instant, les arguments ne peuvent �tre que des nombres (entiers, floats, etc.) et des bool�ens, et �a devrait amplement suffire.
	
	Les commandes sont ex�cut�es dans l'ordre. 
	Il existe �galement quelques hacks pour faire des choses plus compliqu�es.
	1.1) Commandes parall�les
		Syntaxe:
			->*[module] [arguments]
		Sont initialis�es en m�me temps que la commande non parall�le la plus proche par en haut.  Donc:
	
			foo 115
			*foobar 22
			*foobarbar 23
			foo2 116
			
		Ici, foo sera ex�cut�.  foobar et foobarbar seront ex�cut�s en m�me temps.  Quand foo sera fini, foo2 embarquera, m�me si foobar et foobarbar roulent toujours.
		
		Comme leur nom l'indique, une fois initialis�es, les commandes parall�les sont enti�rement ind�pendantes des commandes lin�aires.  � la fin du fichier de commandes, 
		si les actions lin�aires sont termin�es mais il reste des commandes parall�les, le programme se terminera. 
		
	1.2) Commandes concurrentes
		Syntaxe:
			->&([module] [arguments]) ([module2] [arguments2])
		
		M�me principe que les commandes parall�les (module1 et module2 seront tous les deux ex�cut�s), mais la commande est trait�e comme lin�aire. Donc:
			&(foo 115) (foobar 666)
			foo2 13
		
		foo et foobar seront ex�cut�s simultan�ment, mais foo2 ne sera pas ex�cut� tant que les deux ne seront pas finis. 
		
	1.3) A ne pas faire
		Mon parseur (qui est fait 100% maison) est quand m�me vraiment sketch.  Donc, choses � �viter:
			foo 10 // 10 tours
			*foobar 22 // 22 tours
			foobar 23 // 23 tours
			
		Ici, le deuxi�me foobar sera appel� alors que le premier roule toujours.  Dans ce cas sp�cifique, il ignorerait le deuxi�me, mais si ce code
		continuait avec une autre commande parall�le, cela d�clencherait une apocalypse nucl�aire.  
		
		De plus, il supporte tr�s mal les commandes nest�es.  Donc, pas de &(foo2)(&(foo3)(foo4)), �a d�truirait tout.  
		
		Je crois qu'il est assez correct, mais quoi que ce soit de malhonn�te risque de le briser assez s�rieusement.
		
2) �crire des commandes
	Super simple.  Il faut d'abord cr�er un fichier lua, et faire la proc�dure habituelle: D�clarer une table, la retourner � la fin du fichier
    (constituant le module). Tout ce qui doit �tre export� doit �tre d�clar� comme faisant partie de cette table. Exemple:
	
	// foo.lua
		local m = {}
		m.patate = "Miam miam des patates"
		return m
		
	// foo2.lua
		require "foo"
		print(foo.patate) // Miam miam des patates
		
	Les fonctions qui doivent �tre d�finies dans votre programme sont:
		- init(Argtable) o� Argtable est une table des arguments pars�s.  Sera appel� une seule fois, apr�s la cr�ation du module.
		- body()         Appel� � chaque tour si isended() retourne false.
		- IsDone()       Retourne bool. Si vrai, commande est consid�r�e comme finie.
	
	Les variables accessibles (celles qui seront cr��es, sett�es et lues par le programme C++) sont:
		- MoteurVitesse   (float)
		- MoteurRotation  (float)
		- MoteurBras      (float)
		- MoteurRamasseur (float)
		- distance        (float)
		- autocounter     (int)
		- RamasseurSwitch (bool)
		- EstFini         (bool)
		
		
		