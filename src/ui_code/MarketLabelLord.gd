extends Node2D
class_name MarketLabelLord

@export var marketLabelPacked: PackedScene
@export var market: CardMarket
@export var container: Container

func _ready():   
    for i in range(market.columns):
        var text = "Action Cost: {cost}".format({"cost": market.getColumnCost(i)})
        var newLabel = marketLabelPacked.instantiate()
        newLabel.text = text
        container.add_child(newLabel)

