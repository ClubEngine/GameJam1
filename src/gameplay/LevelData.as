package gameplay 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import screens.GameOver;

	/**
	 * @author Lucas Cimon
	 */
	public class LevelData extends World
	{
		public static const DIFFICULTY_EASY:int = 0;
		public static const DIFFICULTY_NORMAL:int = 1;
		public static const DIFFICULTY_HARD:int = 2;
		public static var CURRENT_DIFFICULTY:int;
		
		private var m_powerplants:Array = new Array;
		private var m_farms:Array = new Array;
		private var m_switches:Array = new Array;
		private var m_wires:Array = new Array;
		
		private var initialized:Boolean = false;
		
		public function LevelData(a_difficulty:int) 
		{
			CURRENT_DIFFICULTY = a_difficulty;
			var diff:String;
			switch(CURRENT_DIFFICULTY)
			{
				case LevelData.DIFFICULTY_EASY : 	diff = "easy"; 
													break;
				
				case LevelData.DIFFICULTY_HARD : 	diff = "hard"; 
													break;
				
				default: diff = "normal";
			}
			readXML("../assets/levels/level1_"+diff+".xml")
		}
		
		private function readXML(a_file:String):void
		{
			var loader:URLLoader = new URLLoader();
			var format:String = URLLoaderDataFormat.TEXT;
			loader.dataFormat = format;
			loader.load(new URLRequest(a_file));
			loader.addEventListener(Event.COMPLETE, processXML);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorXML);
		}
		
		private function errorXML(a_error:Event):void
		{
			trace("Error while loading XML : " + a_error);
		}
		
		private function processXML(a_event:Event):void
		{
			var file:XML = new XML(a_event.target.data);
			for each(var pp : XML in file.POWERPLANT)
			{
				m_powerplants[pp.@id] = new PowerPlant	(	
															pp.@abs, 
															pp.@ord,
															getColor(pp.@color),
															pp.@min_power,
															pp.@max_power
														);
				
				add(m_powerplants[pp.@id]);
			}
			
			for each(var farm : XML in file.FARM)
			{
				m_farms[farm.@id] = new Farm(
												farm.@abs, 
												farm.@ord,
												farm.@pop_delay,
												farm.@pop_rate
											);
											
				add(m_farms[farm.@id]);
			}
			
			for each(var switch_node : XML in file.SWITCH)
			{
				m_switches[switch_node.@id] = new SwitchNode(
																switch_node.@abs, 
																switch_node.@ord
															);
											
				add(m_switches[switch_node.@id]);
			}
			
			for each(var wire : XML in file.WIRE)
			{
				var ext1:NetworkElement = getArray(wire.@type_ext1)[wire.@id_ext1];
				var ext2:NetworkElement = getArray(wire.@type_ext2)[wire.@id_ext2];
				
				m_wires[wire.@id] = new StraightWire(ext1, ext2);
				
				add(m_wires[wire.@id]);
			}
			
			for each(var switch_wire : XML in file.SWITCH_WIRE)
			{
				var node:SwitchNode = m_switches[switch_wire.@id_switch];
				
				for each(var connection : XML in switch_wire.CONNECTION)
				{
					var node_wire:StraightWire = m_wires[connection.@id_wire];
					node.addStraightWire(node_wire, getDirection(connection.@dir));
				}
			}
			
			for each(var farm_wire : XML in file.FARM_WIRE)
			{
				var elem:StraightWire = m_wires[farm_wire.@id_wire];
				m_farms[farm_wire.@id_farm].networkElement = elem;
			}
			
			initialized = true;
		}
		
		private function getColor(a_colorName:String):SheepColor
		{
			switch(a_colorName)
			{
				case "RED": return SheepColor.RED;
				case "BLUE": return SheepColor.BLUE;
				case "YELLOW": return SheepColor.YELLOW;
				case "GREEN": return SheepColor.GREEN;
			}
			
			throw new Error("Unknown color : " + a_colorName);
		}
		
		private function getArray(a_itemName:String):Array
		{
			switch(a_itemName)
			{
				case "POWERPLANT": return m_powerplants;
				case "FARM": return m_farms;
				case "SWITCH": return m_switches;
				case "WIRE": return m_wires;
			}
			
			throw new Error("Unknown item : " + a_itemName);
		}
		
		private function getDirection(a_dirName:String):int
		{
			switch(a_dirName)
			{
				case "UP": return SwitchNode.UP;
				case "DOWN": return SwitchNode.DOWN;
				case "LEFT": return SwitchNode.LEFT;
				case "RIGHT": return SwitchNode.RIGHT;
			}
			
			throw new Error("Unknown direction : " + a_dirName);
		}

		private function allPowered():Boolean
		{
			for each(var pp:PowerPlant in m_powerplants)
			{
				if (!pp.isPowered())
				{
					return false;
				}
			}
			
			return true;
		}
		
		private function oneUnpowered():Boolean
		{
			for each(var pp:PowerPlant in m_powerplants)
			{
				if (pp.hasNoPower())
				{
					return true;
				}
			}
			
			return false;
		}
		
		override public function update():void
		{
			super.update();
			if (!initialized)
			{
				return;
			}
			
			// Victory test
			if (allPowered())
			{
				FP.world =  new GameOver(true);
			}
			
			// Defeat test
			if (oneUnpowered())
			{
				FP.world = new GameOver(false);
			}
		}
	}
}