extends Condition
class_name ConditionTokenOnJob

@export var tokenRequirement: Array[Token]

func checkSubject(job) -> bool:
    if not job is Job:
        return false

    if job.getTokensOwn(tokenRequirement).size() != tokenRequirement.size():
        return false
    
    return true