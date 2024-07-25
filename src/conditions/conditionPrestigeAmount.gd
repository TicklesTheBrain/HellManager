extends Condition
class_name ConditionPrestigeAmount

@export var lower: bool = true
@export var acceptEqual: bool = true
@export var compareToActingEmployee: bool = false
@export var prestigeValueToCompare: int

func checkSubject(sbj):

    # print('checking prestige amount')
    if not (sbj is Employee):
        return false

    var value
    if compareToActingEmployee:
        value = Globals.getCtxt().actingEmployee.prestige
    else:
        value = prestigeValueToCompare

    # print('value ', value)
    
    if value == sbj.prestige and acceptEqual:
        return true
    
    if (value < sbj.prestige and not lower) or (value > sbj.prestige and lower):
        # print('returning true')
        return true

    return false