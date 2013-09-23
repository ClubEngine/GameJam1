package gameplay 
{
	/**
	 * ...
	 * @author ur mom
	 */
	
	import gameplay.NetworkElement;
	import gameplay.StraightWire;
	import gameplay.IntPoint;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Key;
	
	public class SwitchNode extends NetworkElement 
	{
		private static const SWITCHNODELAYER:int = 2;
		public static var nodesNumber:int = 1;
		public static const UP:int = 0;
		public static const LEFT:int = 1;
		public static const DOWN:int = 2;
		public static const RIGHT:int = 3;
		public static const DIRECTIONS_NUMBER:int = 4;
		public static const NODESTEP:Number = 0.4;
		
		
		[Embed(source = '../../assets/switches.png')] private const ANIM_SWITCHES:Class;
		public var m_anim:Spritemap = new Spritemap(ANIM_SWITCHES, 32, 32);
		[Embed(source = '../../assets/turnswitch.mp3')] private const SOUNDSWITCH:Class;
		public var soundswitch:Sfx = new Sfx(SOUNDSWITCH);
		
		private var m_picLeft : Image;
		private var m_picRight : Image;
		private var m_picUp : Image;
		private var m_picDown : Image;
		private var m_straightsWires: Array;
		private var m_direction: int;
		private var m_isPushed: Boolean;
		private var m_id: int;
		
		public function SwitchNode(switchx: int = 0, switchy: int = 0) 
		{
			super(switchx, switchy);
			layer = SWITCHNODELAYER;
			m_id = nodesNumber;
			nodesNumber++;
			x = switchx;
			y = switchy;
			m_isPushed = false;
			m_anim.add("up", [0, 1, 2, 3], 5, true);
			m_anim.add("right", [4, 5, 6, 7], 5, true);
			m_anim.add("left", [8, 9, 10, 11], 5, true);
			m_anim.add("down", [12, 13, 14, 15], 5, true);
			graphic = m_anim;
			m_straightsWires = new Array(4);
			for (var i: int = 0; i < 4; i++)
				m_straightsWires[i] = null;
			setDirection(UP);
		}
		
		public function turnSwitch(): void 
		{
			var i: int = 1;
			while (i < 4 && m_straightsWires[(i + getDirection()) % 4] == null) {
				i++;
			}

			setDirection((getDirection() + i) % DIRECTIONS_NUMBER);
			soundswitch.play();
		}
		
		public function setDirection(direction: int): void
		{
			m_direction = direction;
			switch(m_direction) {
			case UP:
				m_anim.play("up");
				break;
			case RIGHT:
				m_anim.play("right");
				break;
			case DOWN:
				m_anim.play("down");
				break;
			case LEFT:
				m_anim.play("left");
				break;
			}
			setHitbox(m_anim.width, m_anim.height, x, y);
		}
		
		override public function update():void
		{
			if (Input.mouseDown) {
				if (!m_isPushed) {
					if (Input.mouseX >= this.x - halfWidth
						&& Input.mouseX <= this.x + halfWidth
						&& Input.mouseY >= this.y - halfHeight
						&& Input.mouseY <= this.y + halfHeight) {
						m_isPushed = true;
						turnSwitch();
					}
				}
			}
			if (Input.mouseUp) {
				m_isPushed = false;
			}
			if (Input.check(Key.NUMPAD_1) && m_id == 1)
				turnSwitch();
			if (Input.check(Key.NUMPAD_2) && m_id == 2)
				turnSwitch();
			if (Input.check(Key.NUMPAD_3) && m_id == 3)
				turnSwitch();
			if (Input.check(Key.NUMPAD_4) && m_id == 4)
				turnSwitch();
			if (Input.check(Key.NUMPAD_5) && m_id == 5)
				turnSwitch();
			if (Input.check(Key.NUMPAD_6) && m_id == 6)
				turnSwitch();
			if (Input.check(Key.NUMPAD_7) && m_id == 7)
				turnSwitch();
			if (Input.check(Key.NUMPAD_8) && m_id == 8)
				turnSwitch();
			if (Input.check(Key.NUMPAD_9) && m_id == 9)
				turnSwitch();
		}
		
		public function getDirection(): int {
			return m_direction;
		}
		
		override public function getProgressionStep():Number 
		{
			return NODESTEP;
		}
		
		public function addStraightWire(sw : StraightWire, direction : int): void {
			if (direction < 0 || direction > 3) {
				trace("In SwitchNode.addStraightWire: direction must be between 0 and 3");
			}
			if (m_straightsWires[direction] != null) {
				trace("In SwitchNode.addStraightWire: this direction already has a straightwire associated, it will be erased");
			}
			m_straightsWires[direction] = sw;
			setDirection(direction);
		}
		
		public function getStraightWire(direction : int): StraightWire {
			return m_straightsWires[direction];
		}
		
		public override function getNext(direction:Boolean):NetworkElement
		{
			return getStraightWire(m_direction);
		}
		
		public override function getSheepPosition(progression:Number, direction:Boolean):IntPoint
		{
			return new IntPoint(x, y);
		}
		
		public override function getDir(srcElem:NetworkElement):Boolean
		{
			return true;
		}
	}
}