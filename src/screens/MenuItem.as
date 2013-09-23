package screens 
{
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Kak0
	 */
	public class MenuItem extends TextEntity 
	{		
		private var m_previous:MenuItem;
		private var m_next:MenuItem;
		private var m_returnCode:int;
		private var m_isSelected:Boolean = false;
		
		public function MenuItem(a_returnCode:int, a_text:String, a_size:int, a_color:int) 
		{
			super(a_text, a_size, a_color);
			returnCode = a_returnCode;
		}
		
		// --------------------------------------------------------------------
		// Getters and Setters
		// --------------------------------------------------------------------
		
		public function get previous():MenuItem
		{
			return m_previous;
		}
		
		public function set previous(a_item:MenuItem):void
		{
			m_previous = a_item;
		}
		
		public function get next():MenuItem
		{
			return m_next;
		}
		
		public function set next(a_item:MenuItem):void
		{
			m_next = a_item;
		}
		
		public function get returnCode():int
		{
			return m_returnCode;
		}
		
		public function set returnCode(a_code:int):void
		{
			m_returnCode = a_code;
		}
		
		public function get isSelected():Boolean
		{
			return m_isSelected;
		}
		
		public function set isSelected(a_selected:Boolean):void
		{
			m_isSelected = a_selected;
		}
		
		// --------------------------------------------------------------------
		// Selecting another item
		// --------------------------------------------------------------------
		
		public function selectNext():MenuItem
		{
			if (m_next != null)
			{
				isSelected = false;
				m_next.isSelected = true;
			}
			
			return m_next;
		}
		
		public function selectPrevious():MenuItem
		{
			if (m_previous != null)
			{
				isSelected = false;
				m_previous.isSelected = true;
			}
			
			return m_previous;
		}
		
		// --------------------------------------------------------------------
		// Testing mouse on item
		// --------------------------------------------------------------------
		
		public function isPointOnItem(a_x:int, a_y:int):Boolean
		{
			return (
					a_x >= x 
					&& a_x <= (x + textWidth) 
					&& a_y >= y
					&& a_y <= (y + textHeight)
					);
		}
	}
}