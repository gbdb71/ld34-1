package org.wildrabbit.magnetpuzzle;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxVector;

/**
 * ...
 * @author ith1ldin
 */

 @:enum abstract MovementMode(Int) from Int to Int
 {
	 var Off = 0;
	 var Left = 1;
	 var Right = 2;
 }
 
 @:enum abstract MagnetMode(Int) from Int to Int
 {
	 var Off = 0;
	 var Attract = 1;
	 var Repel = 2;
 }
 
class Magnet extends FlxSprite
{
	
	public static var w:Int = 32;
	public static var h:Int = 32;
	
	private var speed:Float = 300;
	private var gamepad:FlxGamepad;
	
	public static inline var MOVEMODE_COUNT:Int = MovementMode.Right - MovementMode.Off + 1;
	public static inline var MAGNETMODE_COUNT:Int = MagnetMode.Repel - MagnetMode.Off + 1;
	
	private var lastMv:MovementMode;
	private var mvMode:MovementMode;
	
	private var lastMg:MagnetMode;
	private var mgMode:MagnetMode;
	
	private var forceMagnitude: Float = 10000;
	public var currentForce: Float = 0;
	public var minThreshold:Float = 48;
	public var maxThreshold:Float = 240;
	
	public var radius:Float = 48;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);	
		makeGraphic(w, h);
		
		velocity.set(0, 0);		
		gamepad = null;
		
		lastMv = MovementMode.Right;
		changeMovement(MovementMode.Off);		
		
		lastMg = MagnetMode.Repel;
		changeMagnet(MagnetMode.Off);		
	}
	
	override public function update():Void
	{
		processInput();
		super.update();
		
		if ((x + h) > FlxG.width)
		{
			x = FlxG.width - h;
			changeMovement(MovementMode.Left);
			lastMv = MovementMode.Left;
		}
		else if (x < 0)
		{
			x = 0;
			changeMovement(MovementMode.Right);
			lastMv = MovementMode.Right;
		}
	}
	
	private function processInput():Void
	{
		//if (gamepad != null)
		//{
			//
		//}
		
		var buttonMove:Bool = FlxG.keys.anyJustPressed(["J"]);
		if (buttonMove)
		{
			if (lastMv == MovementMode.Left)
			{
				changeMovement(lastMv);
			}
			else if (lastMv == MovementMode.Right)
			{
				changeMovement(lastMv);
			}
		}
		else if (FlxG.keys.anyJustReleased(["J"]))
		{
			changeMovement(MovementMode.Off);
		}

		var buttonMagnet:Bool = FlxG.keys.anyJustPressed(["K"]);
		if (buttonMagnet)
		{
			var newMagnet:Int = mgMode;
			newMagnet = (newMagnet+ 1) % MAGNETMODE_COUNT;
			changeMagnet(newMagnet);
		}
		//var buttonReleased:Bool = FlxG.
	}
	
	private function changeMovement(newMvMode:MovementMode ):Void 
	{
		mvMode = newMvMode;
		switch mvMode
		{
			case MovementMode.Off: 
			{
				velocity.set(0, 0);
			}
			case MovementMode.Left:
			{
				velocity.set( -speed, 0);
			}
			case MovementMode.Right:
			{
				velocity.set(speed, 0);
			}
		}
		
	}
	
	private function changeMagnet (newMgMode:MagnetMode):Void 
	{
		mgMode = newMgMode;
		switch mgMode
		{
			case MagnetMode.Off: 
			{
				color = FlxColor.GRAY;
				currentForce = 0;
			}
			case MagnetMode.Attract:
			{
				color = FlxColor.RED;
				currentForce = forceMagnitude;
			}
			case MagnetMode.Repel:
			{
				color = FlxColor.BLUE;
				currentForce = -forceMagnitude;
			}
		}
	}
	public function getPosition():FlxVector 
	{
		return new FlxVector(x + w/2, y + h/2);
	}
}