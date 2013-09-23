package screens 
{
	import gameplay.LevelData;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	/**
	 * @author Lucas Cimon
	 */
	public class GameOver extends Menu
	{
		private static const RETRY:int = 0;
		private static const BACK:int = 1;
		
		public function GameOver(a_won:Boolean)
		{
			super();
			
			// Message
			var message:TextEntity = new TextEntity((a_won ? "YOU SUCCEEDED" : "YOU FAILED"), 40, 0xEEEE00);
			message.x = (FP.screen.width - message.textWidth) / 2;
			message.y = FP.screen.height/3;
			add(message);
			
			// Options
			var common_abs:int = message.x + message.textWidth / 4;
			
			var retry:MenuItem = new MenuItem(RETRY, "RETRY", 30, 0x0000EE);
			retry.x = common_abs;
			retry.y = message.y + message.textHeight + 20;
			addItem(retry);
			
			var back:MenuItem = new MenuItem(BACK, "MAIN MENU", 30, 0x00EE00);
			back.x = common_abs;
			back.y = retry.y + retry.textHeight;
			addItem(back);
			
			// Linking menu items
			retry.previous = back;
			back.next = retry;
			
			back.previous = retry;
			retry.next = back;
			
			// Pointer
			selectedItem = retry;
		}
		
		override protected function choiceValidated():void
		{
			if(selectedItem.returnCode == RETRY)
			{
				FP.world = new LevelData(LevelData.CURRENT_DIFFICULTY);
			}
			else
			{
				FP.world = StartMenu.getInstance();
			}
		}
	}
}