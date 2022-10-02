package par.enginees
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import par.emitters.Emitter;
	import par.particals.Particle;
	import par.particals.ParticleInfo;
	import par.renderer.IParticleRenderer;
	
	public class ParticleEnginee
	{
		
		
		private var _maxCount:int;
		
		private var _root:Sprite;
		
		private var _last:int;
		
		private var _emitters:Dictionary;
		
		public var spareParticles:Dictionary;
		
		public var particles:Vector.<Particle>;
		
		private var _render:IParticleRenderer;
		
		public var cachable:Boolean = true;
		
		public function ParticleEnginee(param1:IParticleRenderer)
		{
			super();
			this._render = param1;
			this._maxCount = 200;
			this.spareParticles = new Dictionary();
			this.particles = new Vector.<Particle>();
			this._emitters = new Dictionary();
		}
		
		public function setMaxCount(param1:Number) : void
		{
			this._maxCount = param1;
		}
		
		public function addEmitter(param1:Emitter) : void
		{
			this._emitters[param1] = param1;
			param1.setEnginee(this);
		}
		
		public function removeEmitter(param1:Emitter) : void
		{
			delete this._emitters[param1];
			param1.setEnginee(null);
		}
		
		public function addParticle(param1:Particle) : void
		{
			this.particles.push(param1);
			this._render.addParticle(param1);
		}
		
		private function __enterFrame(param1:Event) : void
		{
			this.update();
		}
		
		public function update() : void
		{
			var _loc1_:Particle = null;
			var _loc3_:Emitter = null;
			var _loc4_:int = 0;
			while(this.particles.length > this._maxCount)
			{
				_loc1_ = this.particles.shift();
				this._render.removeParticle(_loc1_);
				this.cacheParticle(_loc1_);
			}
			var _loc2_:Number = 0.04;
			for each(_loc3_ in this._emitters)
			{
				_loc3_.execute(_loc2_);
			}
			_loc4_ = 0;
			while(_loc4_ < this.particles.length)
			{
				_loc1_ = this.particles[_loc4_];
				_loc1_.age = _loc1_.age + _loc2_;
				if(_loc1_.age >= _loc1_.life)
				{
					this.particles.splice(_loc4_,1);
					this._render.removeParticle(_loc1_);
					this.cacheParticle(_loc1_);
					_loc4_--;
				}
				else
				{
					_loc1_.update(_loc2_);
				}
				_loc4_++;
			}
			this._render.renderParticles(this.particles);
		}
		
		protected function cacheParticle(param1:Particle) : void
		{
			param1.initialize();
			var _loc2_:String = param1.info.name;
			var _loc3_:Array = this.spareParticles[_loc2_];
			if(_loc3_ == null)
			{
				this.spareParticles[_loc2_] = _loc3_ = new Array();
			}
			if(_loc3_.length < 15)
			{
				_loc3_.push(param1);
			}
		}
		
		public function reset() : void
		{
			this.particles = new Vector.<Particle>();
			this.spareParticles = new Dictionary();
			this._emitters = new Dictionary();
			this._render.reset();
		}
		
		public function createParticle(param1:ParticleInfo) : Particle
		{
			if(this.spareParticles[param1.name] && this.spareParticles[param1.name].length > 0)
			{
				return this.spareParticles[param1.name].shift();
			}
			return new Particle(param1);
		}
		
		public function dispose() : void
		{
			this._render.dispose();
		}
	}
}
