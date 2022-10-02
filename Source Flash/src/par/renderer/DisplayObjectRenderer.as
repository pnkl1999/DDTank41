package par.renderer
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import par.particals.Particle;
	
	public class DisplayObjectRenderer extends Sprite implements IParticleRenderer
	{
		
		
		private var layers:Dictionary;
		
		public function DisplayObjectRenderer()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			this.layers = new Dictionary();
		}
		
		public function renderParticles(param1:Vector.<Particle>) : void
		{
			var _loc2_:Particle = null;
			for each(_loc2_ in param1)
			{
				_loc2_.image.transform.colorTransform = _loc2_.colorTransform;
				_loc2_.image.transform.matrix = _loc2_.matrixTransform;
			}
		}
		
		public function addParticle(param1:Particle) : void
		{
			var _loc2_:Sprite = this.layers[param1.info];
			if(_loc2_ == null)
			{
				this.layers[param1.info] = _loc2_ = new Sprite();
				_loc2_.blendMode = BlendMode.LAYER;
				addChild(_loc2_);
			}
			if(param1.info.keepOldFirst)
			{
				_loc2_.addChild(param1.image);
			}
			else
			{
				_loc2_.addChildAt(param1.image,0);
			}
		}
		
		public function removeParticle(param1:Particle) : void
		{
			var _loc2_:Sprite = this.layers[param1.info];
			if(_loc2_ && _loc2_.contains(param1.image))
			{
				_loc2_.removeChild(param1.image);
			}
		}
		
		public function reset() : void
		{
			this.layers = new Dictionary();
			var _loc1_:Number = numChildren;
			var _loc2_:int = 0;
			while(_loc2_ < _loc1_)
			{
				this.removeChildAt(0);
				_loc2_++;
			}
		}
		
		public function dispose() : void
		{
		}
	}
}
