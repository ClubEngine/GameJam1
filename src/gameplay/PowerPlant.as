package gameplay 
{
	import flash.display.Shape;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;

	/**
	 * ...
	 * @author Kak0
	 */
	public class PowerPlant extends NetworkElement
	{
		[Embed(source = '../../assets/powerplant.png')] private const POWERPLANT:Class;
		[Embed(source = '../../assets/explosion2.png')] private static const EXPLOSION:Class;
		[Embed(source = '../../assets/indicator.png')] private static const INDICATOR:Class;
		
		[Embed(source = '../../assets/beee.mp3')] private static const BEEESOUND:Class;
		public var soundbeee:Sfx = new Sfx(BEEESOUND);
		
		[Embed(source = '../../assets/electricity.mp3')] private static const ELECTRICITYSOUND:Class;
		public var soundswitch:Sfx = new Sfx(ELECTRICITYSOUND);
		
		public var m_anim:Spritemap = new Spritemap(POWERPLANT, 64, 64);
		private const POWERPLANTLAYER:int = 4;
		
		private var m_power:int;
		private var m_power_indicator:Image;
		private var m_min_power:int;
		private var m_max_power:int;
		
		private var m_color:SheepColor;
		private static var m_explosion_image:Image = new Image(EXPLOSION);
		
		private static var m_color_power:Array = null;
		
		
		
		public function PowerPlant(a_x:int, a_y:int, a_color:SheepColor, a_min_power:int, a_max_power:int) 
		{
			super(a_x, a_y);
			x = a_x;
			y = a_y;
			layer = POWERPLANTLAYER;
			m_power = 20;
			m_min_power = a_min_power;
			m_max_power = a_max_power;
			m_color = a_color;
			
			m_anim.color = m_color.getCode();
			graphic = m_anim;
			m_anim.add("plop", [0, 1, 2, 3], 5, true);
			m_anim.play("plop");
			
			// Power Gauge
			var common_abs:int = m_anim.scaledWidth;
			var red_height:int = (100 - m_max_power) * m_anim.scaledHeight / 100;
			
			if (red_height > 0)
			{
				var red_rectangle:Image = Image.createRect(10, red_height, 0xFF0000);
				red_rectangle.x = common_abs;			
				addGraphic(red_rectangle);
			}
						
			var green_height:int = (m_max_power - m_min_power) * m_anim.scaledHeight / 100;
			if (green_height > 0)
			{
				var green_rectangle:Image = Image.createRect(10, green_height, 0x00FF00);
				green_rectangle.x = common_abs;
				green_rectangle.y = red_height;
				addGraphic(green_rectangle);
			}
			
			var blue_height:int = m_min_power * m_anim.scaledHeight / 100;
			if (green_height > 0)
			{
				var blue_rectangle:Image = Image.createRect(10, blue_height, 0x0000FF);
				blue_rectangle.x = common_abs;
				blue_rectangle.y = red_height+green_height;			
				addGraphic(blue_rectangle);
			}
			
			m_power_indicator = new Image(INDICATOR);
			m_power_indicator.x = common_abs + 10;
			updateIndicator();
			addGraphic(m_power_indicator);
			
			if (m_color_power == null)
			{
				var red:Array = new Array(20, -20, -10, 10);
				var blue:Array = new Array(-20, 20, 10, -10);
				var green:Array = new Array(-10, 10, 20, -20);
				var yellow:Array = new Array(10, -10, -20, 20);
				m_color_power = new Array(red, blue, green, yellow);
			}
			setHitbox(m_anim.width, m_anim.height, x, y);
		}
		
		public override function receiveSheep(a_sheep:Sheep):void
		{
			var power:int = m_color_power[a_sheep.getColor().getIndex()][m_color.getIndex()];
			increasePower(power);
			soundswitch.play();
			soundbeee.play();
			FP.world.remove(a_sheep);
		}
		
		private function updateIndicator():void
		{
			m_power_indicator.y = ((100 - m_power) * m_anim.scaledHeight / 100) - (m_power_indicator.scaledHeight/2);
		}
		
		public function increasePower(a_power:int):void
		{
			m_power += a_power;
			
			if (m_power > 100)
			{
				m_power = 100;
			}
			
			if (m_power < 0)
			{
				m_power = 0;
			}
			
			updateIndicator();
		}
		
		public function getPower():int
		{
			return m_power;
		}
		
		public function isPowered():Boolean
		{
			return m_power >= m_min_power && m_power <= m_max_power;
		}
		
		public function hasNoPower():Boolean
		{
			return m_power == 0;
		}
		
		/* INTERFACE gameplay.NetworkElement */
		
		public override function getNext(direction:Boolean):NetworkElement
		{
			return null;
		}
		
		public override function getSheepPosition(progression:Number, direction:Boolean):IntPoint
		{
			return new IntPoint(x + halfWidth, y + halfHeight);
		}
		
		public override function getDir(srcElem:NetworkElement):Boolean
		{
			return true;
		}
	}

}