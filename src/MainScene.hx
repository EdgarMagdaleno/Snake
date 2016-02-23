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
	var fruit:BodyPart;
	var elapsed:Float;
	public override function begin() {
		elapsed = 0;
		grid = new Tilemap("graphics/tiles.png", 640, 480, 20, 20);
		direction = 2;
		snake = new Snake(5, 2, grid);
		fruit = new BodyPart(5, 5);
		addGraphic(grid, 0, 0, 0);

		Input.define("Right", [Key.RIGHT]);
		Input.define("Left", [Key.LEFT]);
		Input.define("Down", [Key.DOWN]);
		Input.define("Up", [Key.UP]);
		drawGrid();
		grid.setTile(1, 1, 0);
	}

	public function drawGrid():Void {
		for ( x in 0 ... grid.columns ) 
			addGraphic(createRect(1, 480, 0xa7a0c3, .5), 0, x * 20, 0);
		for ( y in 0 ... grid.rows )
			addGraphic(createRect(640, 1, 0xa7a0c3, .5), 0, 0, y * 20);
	}

	public override function update():Void {
		checkInput();

		if ( elapsed > .06 ) {
			snake.move(direction);
			refresh();
			
			elapsed = 0;
			if ( snake.body[0].column == fruit.column &&  snake.body[0].row == fruit.row ) {
				snake.grow();
				fruit.column = Std.random(grid.columns);
				fruit.row = Std.random(grid.rows);
			}
		} else elapsed += HXP.timeFlag();
	}

	public function checkInput():Void {
		if ( Input.pressed("Up") && direction != 3 ) direction = 1;
		else if ( Input.pressed("Right") && direction != 4 ) direction = 2;
		else if ( Input.pressed("Down") && direction != 1 ) direction = 3;
		else if ( Input.pressed("Left") && direction != 2 ) direction = 4;
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
	public var body:Array<BodyPart>;
	private var grid:Tilemap;

	public function new(headColumn:Int, headRow:Int, grid:Tilemap) {
		this.grid = grid;
		body = new Array<BodyPart>();
		body.push(new BodyPart(headColumn, headRow));
		body.push(new BodyPart(headColumn - 1, headRow));
		body.push(new BodyPart(headColumn - 2, headRow));

	}

	public function move(direction:Int):Void {
		body.pop();
		switch ( direction ) {
			case 1:
				body.insert(0, new BodyPart(body[0].column, body[0].row - 1));
			case 2:
				body.insert(0, new BodyPart(body[0].column + 1, body[0].row));
			case 3:
				body.insert(0, new BodyPart(body[0].column, body[0].row + 1));
			case 4:
				body.insert(0, new BodyPart(body[0].column - 1, body[0].row));
		}
	}

	public function grow():Void {
		var tmp:BodyPart = new BodyPart(body[body.length - 1].column, body[body.length - 1].row);
		body.push(tmp);
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