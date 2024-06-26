extends Node
class_name TokenStorage

@export var contents: Array[Token] = []
@export var defaultLimit: int = 10

func getTokenLimit() -> int:
	if get_parent().has_method("getTokenLimit"):
		return get_parent().getTokenLimit()
	return defaultLimit

func addToken(tokenToAdd: Token) -> bool:
	if not checkFull():
		contents.push_back(tokenToAdd)		
		return true
	return false

func addTokens(tokensToAdd) -> Array[Token]:
	var added: Array[Token] = []
	for token in tokensToAdd:
		var addSuccess = addToken(token)
		if addSuccess:
			added.push_back(token)
	return added

func removeToken(token: Token):
	contents.erase(token)

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