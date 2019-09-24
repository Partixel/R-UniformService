local LoaderModule = require( game:GetService( "ServerStorage" ):FindFirstChild( "LoaderModule" ) and game:GetService( "ServerStorage" ).LoaderModule:FindFirstChild( "MainModule" ) or 03593768376 )( "Uniformed" )

require( game:GetService( "ServerStorage" ):FindFirstChild( "MenuLib" ) and game:GetService( "ServerStorage" ).MenuLib:FindFirstChild( "MainModule" ) or 3717582194 ) -- MenuLib

LoaderModule( script:WaitForChild( "MenuModules" ), game:GetService( "ServerStorage" ):WaitForChild( "MenuModules" ) )

require( game:GetService( "ServerStorage" ):FindFirstChild( "ThemeUtil" ) and game:GetService( "ServerStorage" ).ThemeUtil:FindFirstChild( "MainModule" ) or 2230572960 )

script.Name = "Uniformed"

script.Parent = game:GetService( "ServerStorage" )

return {
	
	[ 165491 ] = {
		
		Name = "The Robloxian Army  TRA",
		
		[ 1 ] = { Recruit = { 109854903, 109855017 }, Arctic = { 318456562, 318456895 }, Desert = { 264697486, 264697589 } },
		
		[ 2 ] = { Private = { 109854738, 109855017 } },
		
		[ 3 ] = { PFC = { 109854682, 109855017 } },
		
		[ 4 ] = { LanceCorporal = { 109854506, 109855017 } },
		
		[ 5 ] = { Corporal = { 109854560, 109855017 } },
		
		[ 6 ] = { Sergeant = { 109854423, 109855017 } },
		
		[ 7 ] = { StaffSergeant = { 109854241, 109855017 } },
		
		[ 8 ] = { Officer2k18 = { 1498061109, 1498063495 }, Officer = { 206770664, 206776798 } },
		
		[ 13 ] = { HRFormal = { 206185073, 206185233 }, HRBattle = { 206184539, 206184790 } }
		
	},
	
	[ 1059575 ] = {
		
		Name = "The Robloxian Army Developers TRAD",
		
		DivisionOf = 165491,
		
		{ { 398245511, 398245716 }, Gray = { 398018105, 398018131 }, Old = { 258663820, 258663857 } }
		
	},
	
	[ 4621565 ] = {
		
		Name = "The Robloxian Army Valkyrie Unit",
		
		DivisionOf = 165491,
		
		[ 2 ] = { { 2818975075, 2693327473 } }
		
	},
	
	[ 7013 ] = {
		
		Name = "The Roblox Assault Team",
		
		[ 1 ] = { Conscript = { 158230530, 158230887 } },
		
		[ 2 ] = { Soldier = { 158231026, 158231053 } },
		
		[ 8 ] = { Justicar = { 158231077, 158231090 } },
		
		[ 11 ] = { Admiral = { 182972284, 182816984 } },
		
	},
	
	[ 199219 ] = {
		
		Name = "Vortex Security",
		
		{ { 313550382, 313550507 } }
		
	},
	
	[ 700663 ] = {
		
		Name = "Vortex Security Stormtroopers (VS)",
		
		DivisionOf = 199219,
		
		{ { 333852983, 333853170 } }
		
	},
	
	[ 2673756 ] = {
		
		Name = "Vortex Security: Imperial Fists",
		
		DivisionOf = 199219,
		
		{ { 339322200, 339322106 } }
		
	},
	
	[ 2715765 ] = {
		
		Name = "Vortex Security: Kytheriian Sentinels",
		
		DivisionOf = 199219,
		
		{ { 333852983, 333853170 } }
		
	},
	
	[ 790907 ] = {
		
		Name = "Alpha Authority",
			
		{ { 338561708, 338561765 }, Cloak = { 338561708, 338561754 }, DoubleCloak = { 338561708, 345735841 }, Armour = { 338561708, 338561765 }, CloakArmour = { 338561708, 338561754 }, DoubleCloakArmour = { 338561708, 345735841 } }
		
	},
	
	[ 53272 ] = {
		
		Name = "WIJ",
		
		[ 190 ] = { Trooper = { 98096776, 98096789 } },
		
		[ 194 ] = { Lieutenant = { 98096816, 98096836 } }
		
	},
	
	[ 368615 ] = {
		
		Name = "WIJ High Command",
		
		DivisionOf = 53272,
		
		{ { 98096816, 98096836 } }
		
	},
	
	[ 879644 ] = {
		
		Name = "WIJ Officer Council",
		
		DivisionOf = 53272,
		
		{ { 98096816, 98096836 } }
		
	},
	
	[ 275587 ] = {
		
		Name = "WIJ Shock Troopers",
		
		DivisionOf = 53272,
		
		{ { 98096900, 98096927 } }
		
	},
	
	[ 2732679 ] = {
		
		Name = "Federation of Arcadia",
		
		[ 8 ] = { Combat = { 339946298, 339946342 } },
		
		[ 50 ] = { JrOfficer = { 371741885, 371742142 } },
		
		[ 60 ] = { Officer = { 347043260, 347043323 } }
		
	},
	
	[ 72321 ] = {
		
		Name = "The First Encounter Assault Recon",
		
		[ 0 ] = { { 271968095, 234178874 }, OldPants = { 271968095, 271968109 } },
		
		[ 1 ] = { Recruit = { nil, nil, 100306322 } },
		
		[ 3 ] = { Private = { nil, nil, 100306961 } },
		
		[ 5 ] = { Corporal = { nil, nil, 100308605 } },
		
		[ 7 ] = { Specialist = { nil, nil, 100331365 } },
		
		[ 11 ] = { Sergeant = { nil, nil, 100367706 } },
		
		[ 14 ] = { Lieutenant = { nil, nil, 100368191 } },
		
		[ 18 ] = { Captain = { nil, nil, 100368524 } },
		
		[ 22 ] = { Major = { nil, nil, 100368844 } },
		
		[ 50 ] = { Officer = { nil, nil, 100369352 } },
		
		[ 55 ] = { [ "Lieutenant Colonel" ] = { nil, nil, 1090538399 } }
		
	},
	
	[ 2630153 ] = {
		
		Name = "Vaktovian Army Corps: Entrance Program",
		
		[ 1 ] = { Level1 = { 283699616, 271892764 } },
		
	},
	
	[ 28356 ] = {
		
		Name = "R.A.A",
		
		[ 25 ] = { Combat = { 190104316, 189395091 } },
		
		[ 150 ] = { Captain = { 236133264, 236135440 } },
		
		[ 240 ] = { Admiralty = { 266303879, 266303925 } }
		
	},
	
	[ 334531 ] = {
		
		Name = "V O I D",
		
		{ Locust = { 230073178, 230073197 }, Savage = { 299558789, 299558848 } }
		
	},
	
	[ 2629076 ] = {
		
		Name = "Orion Offensive",
		
		[ 1 ] = { Combat = { 313674961, 313675010 } },
		
		[ 14 ] = { Officer = { 324963146, 325001062 } }
		
	},
	
	[ 83255 ] = {
		
		Name = "Alversian Peoples' Navy",
		
		{ { 244849072, 244849114 } }
		
	},
	
	[ 164096 ] = {
		
		Name = "Frost Mage Clan",
		
		{ { 443123752, 443123885 }, TShirt = { nil, nil, 458729936 } }
		
	},
	
	[ 2639839 ] = {
		
		Name = "The Genenexus Army",
		
		[ 1 ] = { Enlist = {463831581, 463831720  } },
		
		[ 6 ] = { Lieutenant = { 377607093, 377607208 } }
		
	},

	[ 222233 ] = {
		
		Name = "U.E.R.F",
		
		[ 23 ] = { Enlist = { 327824569, 327824889 } },
		
		[ 254 ] = { Command = { 327841606, 327841951 } }
		
	},
	
	[ 527239 ] = {
		
		Name = "Warriors of Robloxia Faction [W.R.F]",
		
		[ 2 ] = { LR = { 196121320, 196121463} },
		
		[ 130 ] = { MRO = { 334646050, 334646097 } },
		
		[ 177 ] = { HRO = { 196126964, 196127005 } }
		
	},
	
	[ 831055 ] = {
		
		Name = "|| Tʜᴇ BLACK COBRA Lᴇɢɪᴏɴ ||",
		
		{ { 113040165, 113040186 } }
		
	},
	
	[ 2882663 ] = {
		
		Name = "Kingdom of Aevia",
		
		{ { 464852310, 464569140 } }
		
	},
	
	[ 2831572 ] = {
		
		Name = "Vanguard Federation",
		
		{ { 443864709, 443858928 } }
		
	},
	
	[ 1113130 ] = {
		
		Name = "The Zenus Legion",
		
		{ { 388519186, 388519383 } }
		
	},
	
	[ 2625691 ] = {
		
		Name = "Lynx Empire",
		
		{ { 466355131, 466355337 } }
		
	},
	
	[ 327626 ] = {
		
		Name = "Green Gods",
		
		[ 1 ] = { LR= { 135683190, 135723731 } },
		
		[ 7 ] = { MR= { 119171204, 119171237 } },
		
		[ 146 ] = { HR = { 119170635, 119170714 } }
		
	},
	
	[ 2736187 ] = {
		
		Name = "Frostbyte Brigade",
		
		{ { 443634322, 443634810 } }
		
	},
	
	[ 2620979 ] = {
		
		Name = "The Spade Armament",
		
		{ [ 1 ] = { 282224769, 282224992 }, Winter = { 373458095, 373458372 } }
		
	},
	
	[ 2645745 ] = {
		
		Name = "Combat Ready Organization",
		
		{ Covert = { 402413587, 402413648 }, Overt = { 402413709, 402413753 } }
		
	},
	
	[ 2891322 ] = {
		
		Name = "H I T M A R K E R",
		
		{ { 460001895, 460002016 }, Variant = { 460001983, 460002016 } }
		
	},
	
	[ 462500 ] = {
		
		Name = "Elite Delta Army",
		
		[ 10 ] = { LR = { 180347919, 180348076 }, LRVariant = { 396486056, 396486518 } },
		
		[ 80 ] = { MR = { 180347951, 180348076 } },
		
		[ 140 ] = { HR = { 180347863, 180348026}, HRVariant = { 396486240, 180348026 } }
		
	},
	
	[ 2531950 ] = {
		
		Name = "Arcerian Regime",
		
		[ 1 ]  = { { 231825478, 231825498 } } ,
		
		[ 150 ] = { Officer = { 229290405, 229295272 } }
		
	},
	
	[ 2583155 ] = {
		
		Name = "Venom Supremacy",
		
		{ { 452217425, 452361701 } }
		
	},
	
	[ 667765 ] = {
		
		Name = "Forfox Army",
		
		{ { 153941378, 153941522 }, Winter = { 152322022, 152322491 }, Formal = { 170564557, 170564625 } }
		
	},
	
	[ 2889945 ] = {
		
		Name = "The Zarixian Dominion",
		
		{ { 472078735, 472078818 } }
		
	},
	
	[ 1146466 ] = {
		
		Name = "Audrex Empire",
		
		{ { 168266910, 168268610 } }
		
	},
	
	[ 1039845 ] = {
		
		Name = "The Chivalrous Dominance",
		
		[ 1 ] = { LR = { 403621520, 403621762 } },
		
		[ 20 ] = { Officer = { 403621026, 403621245 } },
		
	},
	
	[ 72043 ] = {
		
		Name = "John's Cobras",
		
		{ { 402411525, 402411579 } }
		
	},
	
	[ 2532333 ] = {
		
		Name = "Warband",
		
		{ { 468770632, 468754845 } }
		
	},
	
	[ 2843089 ] = {
		
		Name = "Arvorian Confederation",
		
		{ { 420844739, 420858878} }
		
	},
	
	[ 2750556 ] = {
		
		Name = "Super Mutant Unity",
		
		[ 3 ] = { Grub = { 347706662, 347706984 } },
	
		[ 5 ] = { Skirmisher = { 347706818, 347706984 } },
	
		[ 100 ] = { Behemoth = { 348392940, 347706984 } },
		
	},
	
	[ 951138 ] = {
		
		Name = "Chronim",
		
		{ { 467675254, 467675418} }
		
	},
	
	[ 2876469 ] = {
		
		Name = "Mercury Imperium",
		
		{ { 469748390, 469748511} }
		
	},
	
	[ 2535389 ] = {
		
		Name = "ReaΩvers",
		
		{ { 393432019, 238370884 } }
		
	},
	
	[ 1061252 ] = {
		
		Name = "Warsaw",
		
		[ 1 ] = { Signifier = { 467639132, 467638452 } },
	
		[ 70 ] = { Specter = { 467640623, 467638452 } },
	
		[ 100 ] = { Centurion = { 467640013, 467638452 } },
	
		[ 200 ] = { Sentinel = { 467636920, 467638452 } },
		
	},
	
	[  778092 ] = {
		
		Name = "Terran Cohort",
		
		[ 1 ] = { LR = { 460607518, 460607849 } },
		
		[ 9 ] = { HR = { 347722445 , 347722597 } }
		
	},
	
	[ 509569 ] = {
		
		Name = "Shadow Syndicate",
		
		{ { 161829005, 161829057 } }
		
	},
	
	[ 2554104 ] = {
		
		Name = "The Mortem Coalition",
		
		[ 1 ] = { LR = { 417901201, 417901282 } },
		
		[ 249 ] = { HR = { 362638476, 362638501 } }
		
	},
	
	[ 644644 ] = {
		
		Name = "The Alphian Empire",
		
		[ 10 ] = { Enlist = { 469716424, 469715441 } },
		
		[ 70 ] =  { Sergeant = { 469730098, 469715441 } },
		
		[ 120 ] = { Colonel = { 469717030, 469715158 } },
		
		[ 150 ] = { General = { 469724264, 469715158 } }
		
	},
	
	[ 294160 ] = {
		
		Name = "Starlite Corporation",
		
		[ 4 ] = { Cadet = { 330058092, 330058184 } },
		
		[ 10 ] = { Private = { 333503058, 333496095 } },
		
		[ 240 ] = { Colonel = { 147607566, 333496095 } }
	
	},
	
	[ 2743332 ] = {
		
		Name = "OutBound",
		
		{ { 452767065, 452772940 } }
		
	},
	
	[ 447301 ] = {
		
		Name = "X-101st Legion Main Army",
		
		{ Closed = { 162625651, 162626673 }, Open = { 435759611, 435759689 } }
		
	},
	
	[ 1182963 ] = {
		
		Name = "Cat Soldiers",
		
		[ 1 ] = { LR = { 264347828, 264348394 } },
		
		[ 9 ] = { MR = { 374917800, 374918375 } },
		
		[ 249 ] = { HR = { 255000189, 255000263 } }
		
	},
	
	[ 1146315 ] = {
		
		Name = "Roblox Empyrean Legion",
		
		{ { 473235938, 473236044 } }
		
	},
	
	[ 85654 ] = {
		
		Name = "Nightfall Clan ",
		
		{ Combat = { 154427077, 154427134 }, Specialty = { 224748987, 224749035 } }
		
	},
	
	[ 2654474 ] = {
		
		Name = "|| Imperial Armada ||",
		
		{ { 400671771, 290747655 } }
		
	},
	
	[ 1174414 ] = {
		
		Name = "The Nighthawk Imperium",
		
		[ 1 ] = { { 1405629307, 1405628381 } },
		
		[ 15 ] = { Officer = { 1340805475, 1340805608 } },
		
		[ 17 ] = { HC = { 1340805231, 1340805608 } }
		
	},
	
	[ 1124552 ] = {
		
		Name = "[S-WAVE] Shockwave Corporation",
		
		[ 1 ] = { LR = { 295394893, 295394834 } },
		
		[ 10 ] = { MR = { 305067670, 295394834 } },
		
		[ 198 ] = { HR = { 295394498, 295394713 } }
		
	},
	
	[ 2754784 ] = {
		
		Name = "Tad's Cobras",
		
		{ { 383916083, 383916133 } }
		
	},
	
	[ 80738 ] = {
		
		Name = "Urban Assault Forces",
		
		{ 
			CombatRed = { 330896949, 330896974 },
			
			CombatDarkBlue = { 330897016, 330897044 },
			
			CombatGold = { 330921945, 330921982 },
			
			CombatGreen = { 331021450, 331021510 },
			
			CombatBlue = { 331021658, 331021610 },
			
			CombatRedCamo = { 337794530, 337794571 },
			
			CombatGreenCamo = { 337800979, 337801025 }
			
		}
		
	},
	
	[ 306324 ] = {
		
		Name = "Black Wolf Empire",
		
		[ 2 ] = { LR = { 144001878, 143977399 } },
		
		[ 7 ] = { MR = { 207012533, 207032137 } },
		
		[ 14 ] = { HR = { 408524622, 408524714 } },
		
		[ 17 ] = { HC = { 408526551, 408526672 } }
		
	},
	
	[ 2908868 ] = {
		
		Name = "Black Wolf Empire || Bloodhounds",
		
		DivisionOf = 306324,
		
		{ { 207012268,  207033171 } }
		
	},
	
	[ 2808906 ] = {
		
		Name = "The Robine",
		
		[ 1 ] = { [ "Metro-Police MK.II" ] = { 2041329473, 2041331030 } },
		
		[ 60 ] = { [ "Field-Officer MK.II" ] = { 2041333593, 2041335077 } },
		
		[ 90 ] = { [ "MIND Attire MK.II" ] = { 2053976284, 2053976959 } }
		
	},
	
	[ 370016 ] = {
		
		Name = " Ark Empire",
		
		[ 1 ] = { LR = { 377136879, 377137015 } },
		
		[ 170 ] = { HR = { 447330007, 445486822 }, Trench = { 342524516, 342524634 } }
		
	},
	
	[ 639976 ] = {
		
		Name = "Redtisian Empire",
		
		[ 1 ] = { Formal = { 471739020, 449006787 }, CamoFormal = { 471739428, 461676998 } },
		
		[ 10 ] = { Private = { 448976004, 449006787 } },
		
		[ 20 ] = { Corporal = { 448976107, 449006787 } },
		
		[ 25 ] = { Sergeant = { 448976241, 449006787 } },
		
		[ 58 ] = { WarrantOfficer = { 448976822, 449006787 } },
		
		[ 59 ] = { Lt = { 448977163, 449006787 } },
		
		[ 146 ] = { Captain = { 448976931, 449006787 } },
		
		[ 200 ] = { Colonel = { 448977763, 449006787 } },
		
		[ 248 ] = { General = { 448978195, 449006787 } },
		
		[ 249 ] = { Council = { 448978335, 449006787 } },
		
		[ 250 ]  = {  Minister = { 454738586, 449006787 } },
		
		[ 251 ]  = {  GrandChancellor = { 454738837, 449006787 } },
		
		[ 253 ]  = {  SupremeCommander = { 454738977, 449006787 } },
		
		[ 254 ]  = {  PrimeMinister = { 464033603, 449006787 } }
		
	},
	
	[ 914233 ] = {
		
		Name = "Allied Airborne",
		
		[ 1 ] = { Private =  { 406516682, 406487271 }, Combat = { 453000286, 453011099 } },
		
		[ 30 ] = { PFC = { 406513097, 406487271 } },
		
		[ 80 ] = { Corporal = { 406511604, 406487271 } },
		
		[ 81 ] = { Sergeant =  { 406509349, 406487271 } },
		
		[ 82 ] = {  StaffSergeant = { 406507808, 406487271 } },
		
		[ 83 ] = { TechnicalSergeant = { 406507166, 406487271 } },
		
		[ 84 ] = { MasterSergeant = { 406506605, 406487271 } },
		
		[ 85 ] = { FirstSergeant = { 406506120, 406487271 } },	
		
		[ 86 ] = { SecondLieutenant = { 406499261, 406487271 } },
		
		[ 87 ] = { FirstLieutenant = { 406497777, 406487271 } },
		
		[ 88 ] = { Captain = { 406504281, 406487271 } },
		
		[ 103 ] = { Major = { 406494555, 406487271 } },
		
		[ 104 ] = { LieutenantColonel = { 406491020, 406487271 } },
		
		[ 105 ] = { Colonel = { 406490643, 406487271 } },
		
		[ 106 ] = { BrigadierGeneral = { 406490025, 406487271 } },
		
		[ 107] = { MajorGeneral = { 406502826, 406487271 } },
		
		[ 108 ] = { LieutenantGeneral = { 406488303, 406487271 } },
		
		[ 109 ] = { General = { 406495652, 406487271 } },
		
		[ 255 ] = { GeneralOfTheArmy = { 406487690, 406487271 } }
		
	},
	
	[ 14638 ] = {
		
		Name = "RSF",
		
		[ 1 ] = { Varcia = { 2527828459, 2527829122 }, Camo = { 2527830193, 2527830819 }, NightCamo = { 2978666794, 2978669887 } }
		
	},
	
	[ 3806150 ] = {
		
		Name = "RSF | Covert Operations",
		
		DivisionOf = 14638,
		
		{ Battle = { 2524259676, 2524262393 }, Varcia = { 2942587149, 2942589205 } }
		
	},
	
	[ 3231711 ] = {
		
		Name = "RSF | Medical Unit",
		
		DivisionOf = 14638,
		
		{ { 1474922407, 1474925592 } }
		
	},
	
	[ 3747606 ] = {
		
		Name = "The WIJ Alliance",
		
		[ 1 ] = { Enlist = { 1340092667, 1340104024 } },
		
		[ 197 ] = { Lieutenant = { 1340088718, 1340104545 } }
		
	},
	
	[ 157284 ] = {
		
		Name = "The Raven Empire",
		
		[ 1 ] = { [ "Standard Armor" ] = { 3072478215, 3072515741 }, [ "Off-duty Fatigues" ] = { 2939967667, 2939970820 }, [ "Winter Armor" ] = { 3055388334, 3055390215 } },
		
		[ 110 ] = { [ "Field Officer" ] = { 3259128977, 3072515741 } },
		
		[ 144 ] = { [ "Praeceptor Coat" ] = { 3426716496, 3426719278 } },
		
		[ 255 ] = { Leader = { 1154100676, 1163292736 } }
		
	},
	
	[ 3542101 ] = {
		
		Name = "Knights of Corvus",
		
		DivisionOf = 157284,
		
		[ 1 ] = { [ "Knight Armor" ] = { 3421231749, 3421238120 } },
		
		[ 252 ] = { [ "Cerberus Armor" ] = { 3421230043, 3421238120 } }
	
	},
	
	[ 3326117 ] = {
		
		Name = "Thorn's Fist",
		
		DivisionOf = 157284,
		
		[ 1 ] = { [ "Imperial Lancer Armor" ] = { 3124055800, 3124057533 }, [ "Blood Lancer Armor" ] = { 3144502313, 3144503500 } },
		
		[ 6 ] = { [ "Imperial Lancer Captains" ] = { 3295697899, 3124057533 } },
		
		[ 253 ] = { [ "Imperial Lancer Commander" ] = { 3295699081, 3124057533 } }
	
	},
	
	[ 4704504 ] = {
		
		Name = "Imperial Space Force",
		
		DivisionOf = 157284,
		
		{ [ "Drone Armor" ] = { 3135599574, 3135602747 } }
	
	}
	  
}