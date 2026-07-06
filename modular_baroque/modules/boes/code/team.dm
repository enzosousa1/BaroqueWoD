// Nested under /datum/ert/darkpack so Summon ERT lists this template (picker uses subtypesof(/datum/ert/darkpack)).
/datum/ert/darkpack/baroque
	abstract_type = /datum/ert/darkpack/baroque

/datum/ert/darkpack/baroque/boes
	leader_role = /datum/antagonist/ert/baroque/boes/leader
	roles = list(/datum/antagonist/ert/baroque/boes/medic, /datum/antagonist/ert/baroque/boes/rifleman, /datum/antagonist/ert/baroque/boes/priest,/datum/antagonist/ert/baroque/boes/negotiations)
	rename_team = "BOES"
	random_names = TRUE
	enforce_human = TRUE
	mission = "Apoiem a Sociedade de Leopoldo em operações contra ameaças sobrenaturais, priorizando a proteção de inocentes, a contenção de entidades hostis, a preservação do sigilo sobre o sobrenatural e a eliminação de alvos quando necessário."
	polldesc = "Batalhão de Operações Especiais Secretas."
