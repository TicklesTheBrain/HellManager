extends Action
class_name ActionMakeJob

@export var amountOfJobs: int = 1
@export var connected: Connections
@export var connectionType: ConnectionType
@export var addFlowAction: Action

enum Connections {
	NONE,
	CHAIN,
	FIRST_TO_ALL,
	ALL_TO_ALL
}

enum ConnectionType {
	FORWARD,
	BACKWARD,
	BI
}

func performSpecific():

	if amountOfJobs <= 0:
		return false

	var jobsCreated = []
	for i in range(amountOfJobs):
		jobsCreated.push_back(Globals.getJobManager().makeNewJob())

	if connected == Connections.NONE:
		return true
	
	#Making Connections now
	var connectionsToMake = []
	if connected == Connections.CHAIN:
		for i in range(jobsCreated.size()-1):
			connectionsToMake.push_back([jobsCreated[i], jobsCreated[i+1]])
	if connected == Connections.FIRST_TO_ALL:
		for i in range(jobsCreated.size()-1):
			connectionsToMake.push_back([jobsCreated[0], jobsCreated[i+1]])
	if connected == Connections.ALL_TO_ALL:
		for i in range(jobsCreated.size()):
			for c in range(jobsCreated.size()):
				if c == i:
					continue
				connectionsToMake.push_back([jobsCreated[i], jobsCreated[c]])

	if connectionType == ConnectionType.BACKWARD:
		connectionsToMake = connectionsToMake.map(func(p): return [p[1], p[0]])
	if connectionType == ConnectionType.BI:
		var newBackwardsConnections = connectionsToMake.map(func(p): return [p[1], p[0]])
		connectionsToMake.append_array(newBackwardsConnections)

	for pair in connectionsToMake:
		var flowAction = addFlowAction.duplicate()
		flowAction.from = pair[0]
		flowAction.to = pair[1]
		flowAction.perform()

	return true

