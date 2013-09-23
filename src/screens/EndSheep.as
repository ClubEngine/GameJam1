package screens 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * @author Lucas Cimon (ashamed)
	 */
	public class EndSheep extends Entity
	{
		[Embed(source = '../../assets/mouton.png')] private const MOUTON:Class;
		public function EndSheep(horizontal:Boolean) 
		{
			var endAnim:Spritemap = new Spritemap(MOUTON, 64, 32);
			this.graphic = endAnim;
			this.horizontal = horizontal;
			if (horizontal) {
				endAnim.x = 0;
				endAnim.y = Math.random() * 300;
			} else {
				endAnim.x = Math.random() * 400;
				endAnim.y = 300;
			}
			var animName:String = "CrazySheep_" + sheepCounter++;
			endAnim.add(animName, [0,1,2,3,4,5,6,7], 20, true);
			endAnim.play(animName);
		}
		
		public override function update():void
		{
			if (horizontal) {
				this.graphic.x += speed;
			} else {
				this.graphic.y -= speed;
				speed *= 1,4;
			}
		}
		
		private var horizontal:Boolean;
		private var speed:int = 1;
		private static var sheepCounter:int = 0;
	}
}