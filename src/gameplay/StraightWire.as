package gameplay 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	
	/**
	 * @author Lucas Cimon
	 */
	public class StraightWire extends NetworkElement
	{
		private const STANDARDLENGTH:Number = 1.0;
		private const WIRELAYER:int = 5;
		
		/**
		 * Ext1 boundary
		 */
		public var ext1:NetworkElement = null;

		/**
		 * Ext2 boundary
		 */
		public var ext2:NetworkElement = null;

		/**
		 * X position of the Ext1 boundary
		 */
		public var posExt1:IntPoint;
		
		/**
		 * X position of the Ext2 boundary
		 */
		public var posExt2:IntPoint;
		
		/**
		 * Constructor
		 */
		public function StraightWire(a_ext1:NetworkElement, a_ext2:NetworkElement) 
		{
			super(0, 0); // TODO : Fix constructor of NetworkElement
			
			var pos1:IntPoint = a_ext1.pos;
			var pos2:IntPoint = a_ext2.pos;
			
			this.layer = WIRELAYER;
			x = (pos1.x + pos2.x) / 2;
			y = (pos1.y + pos2.y) / 2;
			this.pos = new IntPoint(x, y);
			
			if (pos1.x <= pos2.x) 
			{
				this.ext1 = a_ext1;
				this.ext2 = a_ext2;
				this.posExt1 = pos1;
				this.posExt2 = pos2;
			} 
			else 
			{
				this.ext1 = a_ext2;
				this.ext2 = a_ext1;
				this.posExt1 = pos2;
				this.posExt2 = pos1;
			}
			if (posExt1.x == posExt2.x)
				if (posExt1.y == posExt2.y)
					throw new Error("Null StraightWire");
				else 
					this.graphic = Image.createRect(1, Math.abs(posExt2.y - posExt1.y), 0xFF000000);
			else if (posExt1.y == posExt2.y)
					this.graphic = Image.createRect(Math.abs(posExt2.x - posExt1.x), 1, 0xFF000000);
			else
				throw new Error("Non flat StraightWire");
			this.setHitbox(Math.abs(posExt2.x - posExt1.x), Math.abs(posExt2.y - posExt1.y), x, y);
		}
		
		override public function getProgressionStep():Number 
		{
			return STANDARDLENGTH / Math.abs(posExt1.x - posExt2.x + posExt1.y - posExt2.y);
		}
		
		
		/**
		 * Access next wire in given direction
		 * @param direction true for progression ext1 -> ext2
		 */
		public override function getNext(direction:Boolean):NetworkElement
		{
			if (direction)
				return ext2;
			else
				return ext1;
		}
		
		public override function getSheepPosition(progression:Number, direction:Boolean):IntPoint
		{
			if (direction)
				return new IntPoint(	posExt1.x + (posExt2.x - posExt1.x) * progression,
									posExt1.y + (posExt2.y - posExt1.y) * progression);
			else
				return new IntPoint(	posExt2.x + (posExt1.x - posExt2.x) * progression,
									posExt2.y + (posExt1.y - posExt2.y) * progression);
		}

		public override function getDir(srcElem:NetworkElement):Boolean
		{
			if (srcElem == ext1)
				return true;
			else if (srcElem == ext2)
				return false;
			else
				throw new Error("StraightWire.getDir - Invalid jonction");
		}
	}
}