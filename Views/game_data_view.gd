extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalData.connect("update_away_score", _on_away_score_updated)
	GlobalData.connect("update_home_score", _on_home_score_updated)

@rpc("authority", "call_remote")
func _on_away_score_updated(score : int):
	%AwayTeamScore.text = str(score)
	if multiplayer.is_server():
		_on_away_score_updated.rpc(score)

@rpc("authority", "call_remote")
func _on_home_score_updated(score : int):
	%HomeTeamScore.text = str(score)
	if multiplayer.is_server():
		_on_home_score_updated.rpc(score)
