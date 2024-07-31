extends Condition
class_name ConditionTokenOnJob

@export var tokenRequirement: Array[Token]
@export var anyAmountPasses: bool = false
@export var requireAll: bool = false

func checkSubject(job) -> bool:
    if not job is Job:
        return false

    if requireAll:
        tokenRequirement = Token.getAllTypesCollection()

    if anyAmountPasses and job.storage.getTokens(tokenRequirement).size() > 0:
        return true 

    if job.storage.getTokens(tokenRequirement).size() != tokenRequirement.size():
        return false
    
    return true