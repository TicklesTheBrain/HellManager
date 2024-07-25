extends MethodReplacement
class_name MR_GetNetworkInsteadOfOwn

func getTokensOwn(replacingJob: Job, request: Array[Token], exclude: Array[Token] = [], limit: int = 999):

	#Simplified:
	#return replacingJob.getTokensNetwork(request, exclude, limit)
	#it might possibly conflict if there are more than one replacemnt

	var tokensExcluded: Array[Token] = exclude.duplicate()
	var requestModified: Array[Token] = request.duplicate()
	var got: Array[Job.TokenPath] = []
	for job in replacingJob.inflow:
		var tokensGot = job.getTokensOwn(requestModified, tokensExcluded)
		requestModified = Globals.subtractTokenList(requestModified, tokensGot.map(func(tp): return tp.token))
		got.append_array(tokensGot.map(func(tp): return tp.extend(self)))
		tokensExcluded.append_array(tokensGot.map(func(tp): return tp.token))
	if got.size() > limit:
		got = got.slice(0, limit)
	return got