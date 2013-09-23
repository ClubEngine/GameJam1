package gameplay 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;

	/**
	 * ...
	 * @author ...
	 */
	public class Sheep extends Entity 
	{
		[Embed(source = '../../assets/mouton.png')] private const MOUTON:Class;
		private const SHEEPLAYER:int = 3;
		private const STEP:Number = 0.01;
		private var m_color:SheepColor;
		private var m_currentWire:NetworkElement;
		private var m_direction:Boolean = true;
		private var m_progression:Number = 0;
		public var m_anim:Spritemap = new Spritemap(MOUTON, 64, 32);
		
		public function Sheep(a_color:SheepColor, a_currentWire:NetworkElement) 
		{
			this.layer = SHEEPLAYER;
			m_color = a_color;
			m_anim.add("right", [0,1,2,3,4,5,6,7], 20, true);
			m_anim.add("left", [8,9,10,11,12,13,14,15], 20, true);
			m_anim.color = m_color.getCode();
			graphic = m_anim;
			m_anim.scale = 0.5;
			m_currentWire = a_currentWire;
			this.setHitbox(m_anim.scaledWidth, m_anim.scaledHeight, x, y);
		
			var xy:IntPoint = m_currentWire.getSheepPosition(m_progression, m_direction);
			x = xy.x - halfWidth;
			y = xy.y - halfHeight;
		}
		
		override public function update():void 
		{
			if (m_currentWire != null) {
				m_progression += m_currentWire.getProgressionStep();
			}
			if (m_progression >= 1.0) {
				
				if (m_currentWire != null) {
					var m_precWire:NetworkElement = m_currentWire;
					m_progression = 0;
					m_currentWire.receiveSheep(this);
					m_currentWire = m_currentWire.getNext(m_direction);
					if (m_currentWire != null) {
						m_direction = m_currentWire.getDir(m_precWire);
						if (m_direction) {
							m_anim.play("right");
						} else {
							m_anim.play("left");
						}
					}
				} else {
					// Destruction du mouton à l'arrivee a la centrale
					FP.world.remove(this);
					//FP.world.SheepArray.splice(m_id, 1); 
				}
			}
			if (m_currentWire) {
				var xy:IntPoint = m_currentWire.getSheepPosition(m_progression, m_direction);
				x = xy.x - halfWidth;
				y = xy.y - halfHeight;
			}
			this.setHitbox(m_anim.scaledWidth, m_anim.scaledHeight, x, y);
			super.update();
		}
		
		override public function render():void 
		{

			//var prog1:int;
			//var prog2:int;
			//if (m_direction) {
				//prog1 = 1 - m_progression;
				//prog2 = m_progression;
			//} else {
				//prog1 = m_progression;
				//prog2 = 1 - m_progression;
			//}
			//var sumx:int = m_currentWire.xExt1 + m_currentWire.xExt2;
			//var sumy:int = m_currentWire.yExt1 + m_currentWire.yExt2;
			//
			//x = (m_currentWire.xExt1 * prog1 + m_currentWire.xExt2 * prog2) / sumx;
			//y = (m_currentWire.yExt1 * prog1 + m_currentWire.yExt2 * prog2) / sumy;
			super.render();
		}
		
		public function getColor():SheepColor
		{
			return m_color;
		}
	}

}