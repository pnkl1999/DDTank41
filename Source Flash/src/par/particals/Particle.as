package par.particals
{
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import par.ShapeManager;
   import par.lifeeasing.AbstractLifeEasing;
   import road7th.math.randRange;
   
   public class Particle
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var alpha:Number;
      
      public var color:Number;
      
      public var scale:Number;
      
      public var rotation:Number;
      
      public var life:Number;
      
      public var age:Number;
      
      public var size:Number;
      
      public var v:Number;
      
      public var angle:Number;
      
      public var gv:Number;
      
      public var motionV:Number;
      
      public var weight:Number;
      
      public var spin:Number;
      
      public var image:DisplayObject;
      
      public var info:ParticleInfo;
      
      public function Particle(param1:ParticleInfo)
      {
         super();
         this.image = ShapeManager.create(param1.displayCreator);
         this.info = param1;
         this.initialize();
      }
      
      public function initialize() : void
      {
         this.x = 0;
         this.y = 0;
         this.color = 0;
         this.scale = 1;
         this.rotation = 0;
         this.age = 0;
         this.life = 1;
         this.alpha = 1;
         this.v = 0;
         this.angle = 0;
         this.gv = 0;
         this.image.blendMode = this.info.blendMode;
      }
      
      public function update(param1:Number) : void
      {
         var _loc2_:Number = this.age / this.life;
         var _loc3_:AbstractLifeEasing = this.info.lifeEasing;
         this.v = _loc3_.easingVelocity(this.v,_loc2_);
         this.motionV = _loc3_.easingRandomVelocity(this.motionV,_loc2_);
         this.weight = _loc3_.easingWeight(this.weight,_loc2_);
         this.gv += this.weight;
         var _loc4_:Point = Point.polar(this.v,this.angle);
         var _loc5_:Point = Point.polar(this.motionV,randRange(0,2 * Math.PI));
         this.x += (_loc4_.x + _loc5_.x) * param1;
         this.y += (_loc4_.y + _loc5_.y + this.gv) * param1;
         this.scale = _loc3_.easingSize(this.size,_loc2_);
         this.rotation += _loc3_.easingSpinVelocity(this.spin,_loc2_) * param1;
         this.color = _loc3_.easingColor(this.color,_loc2_);
         this.alpha = _loc3_.easingApha(1,_loc2_);
      }
      
      public function get matrixTransform() : Matrix
      {
         var _loc1_:Number = this.scale * Math.cos(this.rotation);
         var _loc2_:Number = this.scale * Math.sin(this.rotation);
         return new Matrix(_loc1_,_loc2_,-_loc2_,_loc1_,this.x,this.y);
      }
      
      public function get colorTransform() : ColorTransform
      {
         if(this.info.keepColor)
         {
            return new ColorTransform(1,1,1,this.alpha,this.color >> 16 & 255,this.color >> 8 & 255,this.color & 255,0);
         }
         return new ColorTransform(0,0,0,this.alpha,this.color >> 16 & 255,this.color >> 8 & 255,this.color & 255,0);
      }
   }
}
