package par.emitters
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import par.enginees.ParticleEnginee;
	import par.particals.Particle;
	import par.particals.ParticleInfo;
	import road7th.math.randRange;
	
	[Event(name="complete",type="flash.events.Event")]
	public class Emitter extends EventDispatcher
	{
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		private var _info:EmitterInfo;
		
		private var _enginee:ParticleEnginee;
		
		private var _interval:Number = 0;
		
		private var _age:Number = 0;
		
		public var angle:Number = 0;
		
		public var autoRestart:Boolean = false;
		
		public function Emitter()
		{
			super();
			this._interval = 0;
		}
		
		public function setEnginee(param1:ParticleEnginee) : void
		{
			this._enginee = param1;
		}
		
		public function restart() : void
		{
			this._age = 0;
		}
		
		public function get info() : EmitterInfo
		{
			return this._info;
		}
		
		public function set info(param1:EmitterInfo) : void
		{
			this._info = param1;
			this._interval = this._info.interval;
		}
		
		public function execute(param1:Number) : void
		{
			if(this._enginee && this.info)
			{
				this._age = this._age + param1;
				if(this.info.life <= 0 || this._age < this.info.life)
				{
					this._interval = this._interval + param1;
					if(this._interval > this.info.interval)
					{
						this._interval = 0;
						this.emit();
					}
				}
				else if(this.autoRestart)
				{
					this.restart();
				}
				else
				{
					this.dispose();
				}
			}
		}
		
		public function dispose() : void
		{
			this._enginee.removeEmitter(this);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function emit() : void
		{
			var _loc1_:ParticleInfo = null;
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			var _loc4_:Particle = null;
			for each(_loc1_ in this.info.particales)
			{
				if(_loc1_.beginTime < this._age && _loc1_.endTime > this._age)
				{
					_loc2_ = _loc1_.countOrient + int(randRange(0,_loc1_.countSize));
					_loc3_ = 0;
					while(_loc3_ < _loc2_)
					{
						_loc4_ = this._enginee.createParticle(_loc1_);
						_loc4_.life = _loc1_.lifeOrient + randRange(0,_loc1_.lifeSize);
						_loc4_.size = _loc1_.sizeOrient + randRange(0,_loc1_.sizeSize);
						_loc4_.v = _loc1_.vOrient + randRange(0,_loc1_.vSize);
						_loc4_.angle = this.angle + randRange(this.info.beginAngle,this.info.endAngle);
						_loc4_.motionV = _loc1_.motionVOrient + randRange(0,_loc1_.motionVOrient);
						_loc4_.weight = _loc1_.weightOrient + randRange(0,_loc1_.weightSize);
						_loc4_.spin = _loc1_.spinOrient + randRange(0,_loc1_.spinSize);
						_loc4_.rotation = _loc1_.rotation + this.angle;
						_loc4_.x = this.x;
						_loc4_.y = this.y;
						_loc4_.color = _loc1_.colorOrient;
						_loc4_.alpha = _loc1_.alphaOrient;
						this._enginee.addParticle(_loc4_);
						_loc3_++;
					}
				}
			}
		}
	}
}
