extends Condition
class_name ConditionTokenOnJob

@export var tokenRequirement: Array[Token]
@export var anyAmountPasses: bool = false
@export var requireAll: bool = false

func checkSubject(job) -> bool:
    # print('check subject triggered')
    if not (job is Job):
        return false

    # print(' it is a job good')
    if requireAll:
        tokenRequirement = Token.getAllTypesCollection()

    # print('about to check any amount passes ', job.storage.getTokens(tokenRequirement).size(), tokenRequirement)
    if anyAmountPasses and job.storage.getTokens(tokenRequirement).size() > 0:
        return true 

    if job.storage.getTokens(tokenRequirement).size() != tokenRequirement.size():
        return false
    
    return true