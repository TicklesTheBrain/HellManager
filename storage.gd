extends Node
class_name TokenStorage

@export var contents: Array[Token] = []
@export var defaultLimit: int = 1

func getTokenLimit() -> int:
	if get_parent().has_method("getTokenLimit"):
		return get_parent().getTokenLimit()
	return defaultLimit

func addToken(tokenToAdd: Token) -> bool:
	if not checkFull():
		contents.push_back(tokenToAdd)
		Events.tokenProduced.emit(tokenToAdd, self)
		return true
	return false

func addTokens(tokensToAdd: Array[Token]) -> Array[Token]:
	var notAdded: Array[Token] = []
	for token in tokensToAdd:
		var addSuccess = addToken(token)
		if not addSuccess:
			notAdded.push_back(token)
	return notAdded

func checkFull() -> bool:
	return contents.size() >= getTokenLimit()

#Adding this here for future tagging of effects, etc.
func removeToken(tokenToRemove: Token):
	#print('remove token function start')
	var amountPre = contents.size()
	contents.erase(tokenToRemove)
	if amountPre > contents.size():
		#print('emitting token consumed')
		Events.tokenConsumed.emit(tokenToRemove, self)
	
   
func tryFulfill(request: Array[Token]) -> Array[Token]:
	var leftUnfulfilled: Array[Token] = request.duplicate()
	var tempContents: Array[Token] = contents.duplicate()
	for token in request:
		var matching = tempContents.filter(func(t): return t.type == token.type)
		if matching.size() > 0:
			tempContents.erase(matching[0])
			leftUnfulfilled.erase(token)
	return leftUnfulfilled

func fulfill(request: Array[Token]) -> Array[Token]:
	var leftUnfulfilled: Array[Token] = request.duplicate()
	for token in request:
		var matching = contents.filter(func(t): return t.type == token.type)
		if matching.size() > 0:
			removeToken(matching[0])
			leftUnfulfilled.erase(token)
	return leftUnfulfilled
			

	




