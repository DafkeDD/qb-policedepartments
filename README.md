# qb-policedepartments
 
## These resources will not work out of the box, I do not plan to maintain this repository or give support.

```lua
-- LEO
['lspd'] = {
    label = 'LSPD',
    defaultDuty = true,
    offDutyPay = false,
    type = 'leo',
    grades = {
        ['0'] = {name = 'Cadet',   payment = 400},
        ['1'] = {name = 'Officer', payment = 450},
        ['2'] = {name = 'Senior Officer', payment = 475},
        ['3'] = {name = 'Corporal', payment = 500},
        ['4'] = {name = 'Sergeant', payment = 550},
        ['5'] = {name = 'Lieutenant', payment = 600},
        ['6'] = {name = 'Captain', payment = 650},
        ['7'] = {name = 'Assistant Chief', payment = 650},
        ['8'] = {name = 'Chief of Police',isboss = true, payment = 650}
    },
},
['bcso'] = {
    label = 'BCSO',
    defaultDuty = true,
    offDutyPay = false,
    type = 'leo',
    grades = {
        ['0'] = {name = 'Cadet', payment = 400},
        ['1'] = {name = 'Deputy', payment = 450},
        ['2'] = {name = 'Senior Deputy', payment = 475},
        ['3'] = {name = 'Corporal', payment = 500},
        ['4'] = {name = 'Sergeant', payment = 550},
        ['5'] = {name = 'Lieutenant', payment = 600},
        ['6'] = {name = 'Captain', payment = 650},
        ['7'] = {name = 'Undersheriff', payment = 650},
        ['8'] = {name = 'Sheriff',isboss = true, payment = 650}
    },
},
['sapr'] = {
    label = 'SAPR',
    defaultDuty = true,
    offDutyPay = false,
    type = 'leo',
    grades = {
        ['0'] = {name = 'Cadet', payment = 400},
        ['1'] = {name = 'Ranger', payment = 475},
        ['2'] = {name = 'Supervisor', payment = 550},
        ['3'] = {name = 'Superintendent', payment = 600},
        ['4'] = {name = 'Chief Ranger', isboss = true, payment = 650},
    },
},
['sasp'] = {
    label = 'SASP',
    defaultDuty = true,
    offDutyPay = false,
    type = 'leo',
    grades = {
        ['0'] = {name = 'Cadet', payment = 400},
        ['1'] = {name = 'Trooper', payment = 475},
        ['2'] = {name = 'Sir Trooper', payment = 550},
        ['3'] = {name = 'Ultra Trooper', payment = 600},
        ['4'] = {name = 'Lord Commander', isboss = true, payment = 650},
    },
},

--

PlayerData.metadata['certificates'] = PlayerData.metadata['certificates'] or {
    ['leoheat'] = false,
    ['leoboat'] = false,
    ['leobike'] = false,
    ['leoswat'] = false,
    ['leoheli'] = false,
    ['leok9'] = false,
    ['leounmarked'] = false
}

--

----------------------
-- Police Equipment --
----------------------
['handcuffs'] 				 	 = {['name'] = 'handcuffs', 			    	['label'] = 'Handcuffs', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'handcuffs.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	    ['combinable'] = nil,    ['description'] = 'Comes in handy when people misbehave. Maybe it can be used for something else?'},
['police_stormram'] 			 = {['name'] = 'police_stormram', 			  	['label'] = 'Stormram', 				['weight'] = 18000, 	['type'] = 'item', 		['image'] = 'police_stormram.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	    ['combinable'] = nil,    ['description'] = 'A nice tool to break into doors'},
['empty_evidence_bag'] 			 = {['name'] = 'empty_evidence_bag', 			['label'] = 'Empty Evidence Bag', 		['weight'] = 0, 		['type'] = 'item', 		['image'] = 'evidence.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'Used a lot to keep DNA from blood, bullet shells and more'},
['filled_evidence_bag'] 		 = {['name'] = 'filled_evidence_bag', 			['label'] = 'Evidence Bag', 			['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'evidence.png', 			['unique'] = true, 		['useable'] = true, 	['shouldClose'] = false,    ['combinable'] = nil,    ['description'] = 'A filled evidence bag to see who committed the crime >:('},
['pd_emergencybutton'] 		 	 = {['name'] = "pd_emergencybutton", 			['label'] = "Emergencybutton", 			['weight'] = 1000, 		['type'] = "item", 		['image'] = "pd_emergencybutton.png", 	['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,     ['combinable'] = nil,    ['description'] = "PD Equipment.."},
['pd_gsrtest'] 		 	 		 = {['name'] = "pd_gsrtest", 					['label'] = "GSR Test", 				['weight'] = 100, 		['type'] = "item", 		['image'] = "pd_gsrtest.png", 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,     ['combinable'] = nil,    ['description'] = "Used to test someone for gunshot residue.."},
['pd_simcard'] 		 	 		 = {['name'] = "pd_simcard", 					['label'] = "Simcard", 					['weight'] = 1000, 		['type'] = "item", 		['image'] = "pd_simcard.png", 			['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,     ['combinable'] = nil,    ['description'] = "To change your telephone number.."},
['fed_briefcase'] 		 	 	 = {['name'] = "fed_briefcase", 				['label'] = "Briefcase", 				['weight'] = 1000, 		['type'] = "item", 		['image'] = "securitycase.png", 		['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,     ['combinable'] = nil,    ['description'] = "A briefcase filled with money.."},
['pd_breachingcharge'] 		 	 = {['name'] = "pd_breachingcharge", 			['label'] = "Breaching Charge", 		['weight'] = 4000, 		['type'] = "item", 		['image'] = "pd_breachingcharge.png", 	['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,     ['combinable'] = nil,   ['created'] = nil,	['decay'] = 7.0, ['description'] = "This should blast any door open.."},
['pd_spikestrip'] 		 		 = {['name'] = "pd_spikestrip", 				['label'] = "Spike Strips", 			['weight'] = 4000, 		['type'] = "item", 		['image'] = "pd_spikestrip.png", 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,     ['combinable'] = nil,   ['created'] = nil,	['decay'] = 28.0, ['description'] = "Abuse these and I will remove them -lh34"},
```