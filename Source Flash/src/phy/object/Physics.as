package phy.object
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Sprite;
   import flash.geom.Point;
   import phy.maps.Map;
   import phy.math.EulerVector;
   
   public class Physics extends Sprite implements Disposeable
   {
       
      
      protected var _mass:Number;
      
      protected var _gravityFactor:Number;
      
      protected var _windFactor:Number;
      
      protected var _airResitFactor:Number;
      
      protected var _vx:EulerVector;
      
      protected var _vy:EulerVector;
      
      protected var _ef:Point;
      
      protected var _isMoving:Boolean;
      
      protected var _map:Map;
      
      protected var _arf:Number = 0;
      
      protected var _gf:Number = 0;
      
      protected var _wf:Number = 0;
      
      public function Physics(param1:Number = 1, param2:Number = 1, param3:Number = 1, param4:Number = 1)
      {
         super();
         this._mass = param1;
         this._gravityFactor = param2;
         this._windFactor = param3;
         this._airResitFactor = param4;
         this._vx = new EulerVector(0,0,0);
         this._vy = new EulerVector(0,0,0);
         this._ef = new Point(0,0);
      }
      
      public function get layer() : int
      {
         return PhysicsLayer.Phy;
      }
      
      public function addExternForce(param1:Point) : void
      {
         this._ef.x += param1.x;
         this._ef.y += param1.y;
         if(!this._isMoving && this._map)
         {
            this.startMoving();
         }
      }
      
      public function addSpeedXY(param1:Point) : void
      {
         this._vx.x1 += param1.x;
         this._vy.x1 += param1.y;
         if(!this._isMoving && this._map)
         {
            this.startMoving();
         }
      }
      
      public function setSpeedXY(param1:Point) : void
      {
         this._vx.x1 = param1.x;
         this._vy.x1 = param1.y;
         if(!this._isMoving && this._map)
         {
            this.startMoving();
         }
      }
      
      public function get Vx() : Number
      {
         return this._vx.x1;
      }
      
      public function get Vy() : Number
      {
         return this._vy.x2;
      }
      
      public function get motionAngle() : Number
      {
         return Math.atan2(this._vy.x1,this._vx.x1);
      }
      
      public function isMoving() : Boolean
      {
         return this._isMoving;
      }
      
      public function startMoving() : void
      {
         this._isMoving = true;
      }
      
      public function stopMoving() : void
      {
         this._vx.clearMotion();
         this._vy.clearMotion();
         this._isMoving = false;
      }
      
      public function setMap(param1:Map) : void
      {
         this._map = param1;
         if(this._map)
         {
            this._arf = this._map.airResistance * this._airResitFactor;
            this._gf = this._map.gravity * this._gravityFactor * this._mass;
            this._wf = this._map.wind * this._windFactor * this._map.windRate;
         }
      }
      
      protected function computeFallNextXY(param1:Number) : Point
      {
         this._vx.ComputeOneEulerStep(this._mass,this._arf,this._wf + this._ef.x,param1);
         this._vy.ComputeOneEulerStep(this._mass,this._arf,this._gf + this._ef.y,param1);
         return new Point(this._vx.x0,this._vy.x0);
      }
      
      public function get pos() : Point
      {
         return new Point(x,y);
      }
      
      public function set pos(param1:Point) : void
      {
         this.x = param1.x;
         this.y = param1.y;
      }
      
      public function update(param1:Number) : void
      {
         if(this._isMoving && this._map)
         {
            this.updatePosition(param1);
         }
      }
      
      protected function updatePosition(param1:Number) : void
      {
         this.moveTo(this.computeFallNextXY(param1));
      }
      
      public function moveTo(param1:Point) : void
      {
         if(param1.x != x || param1.y != y)
         {
            this.pos = param1;
         }
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         this._vx.x0 = param1;
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this._vy.x0 = param1;
      }
      
      public function dispose() : void
      {
         if(this._map)
         {
            this._map.removePhysical(this);
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
