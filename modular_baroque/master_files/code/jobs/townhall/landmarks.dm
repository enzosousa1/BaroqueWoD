#define JOB_START_HELPER(job_type, job_name)	\
	/obj/effect/landmark/start/darkpack/##job_type {	\
		name = ##job_name; \
		icon_state = "Citizen"; \
	}

/obj/effect/landmark/start/darkpack/townhall
	name = "generic town hall start"

JOB_START_HELPER(townhall/mayor, JOB_MAYOR)

#undef JOB_START_HELPER