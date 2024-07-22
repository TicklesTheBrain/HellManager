extends Resource
class_name Action

#This function is supposed to do a dry run of the execution and return bool on whether it would succeed,
#what exactly success means depends on the action. E.g., when consuming stuff success is probably getting
#all the requirements satisfied, while when producing stuff, success might mean producing at least 1 thing,
#not neccessarilly all of the production.
#SHOULD BE OVERRIDEN BY INHERITING ACTIONS (USUALLY)
func try() -> bool:
	return true

#This is some book keeping to get mark beginning and end of execution, etc.
func perform() -> bool:
	Events.actionStarted.emit(self)
	var result = performSpecific()
	Events.actionEnded.emit(self)
	return result

#This is the actual meat of the action, can't thing of cases where it wouldn't be overriden right now.
func performSpecific() -> bool:
	print('default perform Specific not overriden ', self)
	return true

#This is a check to see if all the parameters that the action needs are chosen. If there are no additional params,
#this can be left as is.
func isSetup() -> bool:
	return true

#This function gets called when setup is not done, it returns a delegate that will get fed a choice. the delegate will
#validate the choice (returning true/false) and record the choice if it is valid.
func ask() -> Callable:
	return (func(_a): return true)

#This function is triggered when action is partly setup and then cancelled
func resetSetup():
	pass

#This is just a help function, when action needs to tell the resolver it wants to move on.
func announceChoice(choice):
	Events.choiceMade.emit(self, choice)

func checkChoice(_choice) -> bool:
	return true
