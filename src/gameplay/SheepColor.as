package gameplay 
{
	/**
	 * ...
	 * @author ...
	 */
	public final class SheepColor 
	{
		public static const RED:SheepColor = new SheepColor(0);	
		public static const BLUE:SheepColor = new SheepColor(1);
		public static const GREEN:SheepColor = new SheepColor(2);
		public static const YELLOW:SheepColor = new SheepColor(3);
		
		private static const COLORCODES:Array = new Array(0xff0000, 0x0000ff, 0x00ff00, 0xffff00); 
		
		private var m_index:int;
		
		public function SheepColor(a_index:int)
		{
			m_index = a_index;
		}
		
		public function getIndex():int
		{
			return m_index;
		}
		
		public function getCode():uint
		{
			return COLORCODES[m_index];
		}
		
	}

}