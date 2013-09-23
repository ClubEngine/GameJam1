package gameplay 
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author ur mom
	 */
	public class NetworkElement extends Entity 
	{
		private var m_pos:IntPoint;
				
		public function NetworkElement(a_x:int, a_y:int)
		{
			this.pos = new IntPoint(a_x, a_y);
		}
		
		public function get pos():IntPoint
		{
			return m_pos;
		}
		
		public function set pos(a_pos:IntPoint):void
		{
			m_pos = a_pos;
		}
		
		public function getNext(direction:Boolean):NetworkElement
		{
			return null;
		}
		
		/**
		 * @param progression between 0 & 1
		 */
		public function getSheepPosition(progression:Number, direction:Boolean):IntPoint
		{
			return null;
		}

		public function getDir(srcElem:NetworkElement):Boolean
		{
			return false;
		}
		
		public function receiveSheep(a_sheep:Sheep):void
		{
			
		}
		
		public function getProgressionStep():Number
		{
			return 1;
		}
		
		override public function render():void 
		{
			x -= halfWidth;
			y -= halfHeight;
			super.render();
			x += halfWidth;
			y += halfHeight;		
		}
	}
	
}