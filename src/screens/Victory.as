package screens 
{
	import net.flashpunk.World;
	
	/**
	 * @author Lucas Cimon
	 */
	public class Victory  extends World
	{
		override public function update():void
		{
			super.update();
			if (!(waitCounter++ % 60))
				add(new EndSheep(false));
		}
		private var waitCounter:int = 0;
	}
}