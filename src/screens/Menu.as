package screens 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Kak0
	 */
	public class Menu extends World
	{
		[Embed(source = '../../assets/menu_pointer.png')] private const POINTER:Class;
		private var m_items:Array;
		
		private var m_pointer:Entity;
		private var m_selectedItem:MenuItem;
		
		private var m_lastMouseCoordinates:Point;
		private var m_keyUpdateCooldown:int;
		
		public function Menu()
		{
			m_items = new Array();
			m_lastMouseCoordinates = new Point();
			m_pointer = new Entity();
			m_pointer.addGraphic(new Spritemap(POINTER, 16, 16));
			add(m_pointer);
		}
		
		private function updatePointer():void
		{
			m_pointer.x = m_selectedItem.x - 20;
			m_pointer.y = m_selectedItem.y + (m_selectedItem.textHeight - 16)/ 2;
		}
		
		private function selectItemUnderMouse():Boolean
		{
			for each(var item:MenuItem in m_items)
			{
				if (item.isPointOnItem(Input.mouseX, Input.mouseY))
				{
					selectedItem = item;
					return true;
				}
			}
			
			return false;
		}
		
		protected function set selectedItem(a_item:MenuItem):void
		{
			if (m_selectedItem == null)
			{
				m_selectedItem = a_item;
			}
			else
			{
				m_selectedItem.isSelected = false;
				m_selectedItem = a_item;
				m_selectedItem.isSelected = true;
			}
			
			updatePointer();
		}
		
		protected function get selectedItem():MenuItem
		{
			return m_selectedItem;
		}
		
		protected function addItem(a_item:MenuItem):void
		{
			m_items[m_items.length] = a_item;
			add(a_item);
		}
		
		// To be overriden by each class that inherits Menu
		protected function choiceValidated():void{}
		
		override public function update():void 
		{
			super.update();
			
			// Managing mouse
			
			// If the user clicks on an item, we select it and validate the choice
			if (Input.mousePressed && selectItemUnderMouse())
			{
				choiceValidated();
				return;
			}
			
			// Else, if the mouse moved, we select the item under the mouse
			if (m_lastMouseCoordinates.x != Input.mouseX
				|| m_lastMouseCoordinates.y != Input.mouseY)
			{
				selectItemUnderMouse();
				m_lastMouseCoordinates.x = Input.mouseX;
				m_lastMouseCoordinates.y = Input.mouseY;
				return;
			}
			
			// Managing keyboard
			// Note that we only look at the keyboard events if the mouse stays still
			
			// Wait for the cooldown to finish
			if (m_keyUpdateCooldown > 0)
			{
				m_keyUpdateCooldown--;
				return;
			}
			
			// If an arrow is pressed, we select the appropriate item
			// If the ENTER key is pressed, we validate the choice
			if (Input.check(Key.DOWN))
			{
				m_selectedItem = m_selectedItem.selectNext();
				m_keyUpdateCooldown = 10;
			}
			else if (Input.check(Key.UP))
			{
				m_selectedItem = m_selectedItem.selectPrevious();
				m_keyUpdateCooldown = 10;
			}
			else if (Input.check(Key.ENTER))
			{
				choiceValidated();
			}
			else // No interesting event, the pointer doesn't need to move
			{
				return;
			}
			
			// Moves the pointer to its new position
			updatePointer();
		}
	}

}