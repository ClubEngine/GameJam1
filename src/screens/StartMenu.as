package screens 
{
	import gameplay.LevelData;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Kak0
	 */
	public class StartMenu extends Menu
	{
		// Singleton
		private static var m_instance:StartMenu;
		
		[Embed(source = '../../assets/music.mp3')] private const MUSIC:Class;
		private var music:Sfx = new Sfx(MUSIC);
		
		public static function getInstance():StartMenu
		{
			if(m_instance == null)
			{
				m_instance = new StartMenu();
			}
			
			return m_instance;
		}
		
		public function StartMenu():void
		{
			super();
			
			if (m_instance != null)
			{
				throw new Error("Implementation error : call \"StartMenu.getInstance()\" instead of \"new StartMenu()\"");
			}
			
			// Title
			var title:TextEntity = new TextEntity("Elektrosheep", 70, 0xEEEE00);
			title.x = (FP.screen.width - title.textWidth) / 2;
			title.y = 0;
			add(title);
			
			// Difficulty
			var difficulty:TextEntity = new TextEntity("Difficulty", 40, 0xEEEE00);
			difficulty.x = (FP.screen.width - difficulty.textWidth) / 2;
			difficulty.y = title.y + title.textHeight + 20;
			add(difficulty);
			
			// Options
			var easy:MenuItem = new MenuItem(	LevelData.DIFFICULTY_EASY,
												"Easy", 30, 0x0000EE
											);
			var common_abs:int = difficulty.x + difficulty.textWidth / 4;
			easy.x = common_abs;
			easy.y = difficulty.y + difficulty.textHeight + 20;
			addItem(easy);
			
			var normal:MenuItem = new MenuItem(	LevelData.DIFFICULTY_NORMAL,
												"Normal", 30, 0x00EE00);
			normal.x = common_abs;
			normal.y = easy.y + easy.textHeight;
			addItem(normal);
			
			var hard:MenuItem = new MenuItem(	LevelData.DIFFICULTY_HARD,
												"Hard", 30, 0xEE0000);
			hard.x = common_abs;
			hard.y = normal.y + normal.textHeight;
			addItem(hard);
			
			// Linking menu items
			easy.previous = hard;
			easy.next = normal;
			
			normal.previous = easy;
			normal.next = hard;
			
			hard.previous = normal;
			hard.next = easy;
			
			// Pointer
			selectedItem = easy;
			
			// Music
			if(!music.playing)
			{
				music.loop();
			}
		}
		
		override protected function choiceValidated():void
		{
			FP.world = new LevelData(selectedItem.returnCode);
		}
	}
}