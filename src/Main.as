package 
{
	import gameplay.LevelData;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import screens.StartMenu;
	
	public class Main extends Engine 
	{
		public function Main():void 
		{
			super(400, 300, 60, false);
			FP.screen.scale = 2;
			FP.screen.color = 0xFFFFFFFF;
			FP.world = StartMenu.getInstance();
		}
	}
	
}