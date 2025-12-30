var xOffset:Float = -300;
var yOffset:Float = -200;

function goodNoteHit() {
    game.comboGroup.camera = game.camGame;
    game.comboGroup.x = ((game.dad.x + game.boyfriend.x) / 2) + xOffset;
    game.comboGroup.y = ((game.dad.y + game.boyfriend.y) / 2) + yOffset;
}