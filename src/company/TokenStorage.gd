extends Node
class_name TokenStorage

@export var contents: Array[Token] = []
@export var transit: Array[Token] = []
@export var defaultLimit: int = 10

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

func addTokenTransit(token: Token):
	transit.push_back(token)

func addTokensTransit(tokens: Array[Token]):
	for token in tokens:
		addTokenTransit(token)

func checkFull() -> bool:
	return contents.size() >= getTokenLimit()

func getTokens(request: Array[Token], exclude: Array[Token] = []) -> Array[Token]:
	var tempContents = contents.duplicate()
	var tokensGot: Array[Token] = []
	for token in request:
		var matching = tempContents.filter(func(t): return t.type == token.type and not exclude.has(t))
		if not matching.is_empty():
			tokensGot.push_back(matching[0])
			tempContents.erase(matching[0])
	return tokensGot


#Adding this here for future tagging of effects, etc.
func removeToken(tokenToRemove: Token):
	contents.erase(tokenToRemove)
   
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
			

	




