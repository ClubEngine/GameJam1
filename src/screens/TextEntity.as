package screens 
{
	import flash.text.TextField;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	/**
	 * ...
	 * @author Kak0
	 */
	public class TextEntity extends Entity
	{
		[Embed(source = '../../assets/electrox.ttf', embedAsCFF = "false", fontFamily = 'electrox')] private const ELECTROX:Class;
	
		private var m_text:Text;
		
		public function TextEntity(a_text:String, a_size:int, a_color:int)
		{
			Text.font = "electrox";
			Text.size = a_size;
			m_text = new Text(a_text);
			m_text.color = a_color;
			graphic = m_text;
		}
		
		public function get textWidth():int
		{
			return m_text.textWidth;
		}
		
		public function get textHeight():int
		{
			return m_text.textHeight;
		}
	}

}