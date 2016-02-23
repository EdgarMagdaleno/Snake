import com.haxepunk.Scene;
import com.haxepunk.graphics.Tilemap;
import flash.geom.Point;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image.createRect;

class MainScene extends Scene {
	var grid:Tilemap;
	var direction:Int;
	var snake:Snake;
	var fruit:Fruit;
	public override function begin() {
		grid = new Tilemap("graphics/tiles.png", 640, 480, 20, 20);
		direction = 2;
		snake = new Snake(2, 2);
		fruit = new Fruit(5, 5);
		addGraphic(grid, 0, 0, 0);

		Input.define("Right", [Key.RIGHT]);
		Input.define("Left", [Key.LEFT]);
		Input.define("Down", [Key.DOWN]);
		Input.define("Up", [Key.UP]);
		drawGrid();
	}

	public function drawGrid():Void {
		for ( x in 0 ... grid.columns ) 
			addGraphic(createRect(1, 480, 0xa7a0c3, .5), 0, x * 20, 0);
		for ( y in 0 ... grid.rows )
			addGraphic(createRect(640, 1, 0xa7a0c3, .5), 0, 0, y * 20);
	}

	public override function update():Void {
		checkInput();
		refresh();
		snake.move(direction);
	}

	public function checkInput():Void {
		if ( Input.pressed("Up") ) direction = 1;
		else if ( Input.pressed("Right") ) direction = 2;
		else if ( Input.pressed("Down") ) direction = 3;
		else if ( Input.pressed("Left") ) direction = 4;
	}

	public function refresh():Void {
		for ( column in 0 ... grid.columns )
			for ( row in 0 ... grid.rows )
				if ( !snake.isBodyPart(column, row) )
					if ( isFruit(column, row) )
						grid.setTile(column, row, 1);
					else grid.clearTile(column, row);
				else grid.setTile(column, row , 0);
	}

	public function isFruit(column:Int, row:Int):Bool {
		if ( column == fruit.column && row == fruit.row ) return true;
		return false;
	}
}

class Snake {
	private var body:Array<BodyPart>;

	public function new(headColumn:Int, headRow:Int) {
		body = new Array<BodyPart>();
		body.push(new BodyPart(headColumn, headRow));
	}

	public function move(direction:Int):Void {
		for (part in body)
			switch ( direction ) {
				case 1: part.row--; break;
				case 2: part.column++; break;
				case 3: part.row++; break;
				case 4: part.column--; break;
			}
	}

	public function grow():Void {

	}

	public function isBodyPart(column:Int, row:Int):Bool {
		for ( part in body )
			if ( part.column == column && part.row == row )
				return true;
		return false;
	}
}

class BodyPart {
	public var column:Int;
	public var row:Int;

	public function new(column:Int, row:Int):Void {
		this.column = column;
		this.row = row;
	}
}

class Fruit {
	public var column:Int;
	public var row:Int;

	public function new(column:Int, row:Int):Void {
		this.column = column;
		this.row = row;
	}
}