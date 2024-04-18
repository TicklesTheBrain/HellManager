extends Line2D
class_name flowLineUI

@export var from: Job
@export var to: Job
@export var fromUI: JobUI:
    set(v):
        fromUI = v
        updateLine()
@export var toUI: JobUI:
    set(v):
        toUI = v
        updateLine()

func updateLine():
    if fromUI != null and toUI != null:
        points[0] = fromUI.position
        points[1] = toUI.position