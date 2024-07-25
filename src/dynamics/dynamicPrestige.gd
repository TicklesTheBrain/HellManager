extends Dynamic
class_name DynamicBasedOnPrestige

func getAmount(askingAction: Action) -> int:
    return askingAction.jobAttachedTo.prestige