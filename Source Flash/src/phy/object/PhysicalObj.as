package phy.object
{
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import road7th.utils.MathUtils;
   
   public class PhysicalObj extends Physics
   {
       
      
      protected var _id:int;
      
      protected var _testRect:Rectangle;
      
      protected var _canCollided:Boolean;
      
      protected var _isLiving:Boolean;
      
      protected var _layerType:int;
      
      private var _drawPointContainer:Sprite;
      
      public function PhysicalObj(param1:int, param2:int = 1, param3:Number = 1, param4:Number = 1, param5:Number = 1, param6:Number = 1)
      {
         super(param3,param4,param5,param6);
         this._id = param1;
         this._layerType = param2;
         this._canCollided = false;
         this._testRect = new Rectangle(-5,-5,10,10);
         this._isLiving = true;
      }
      
      public function get Id() : int
      {
         return this._id;
      }
      
      public function get layerType() : int
      {
         return this._layerType;
      }
      
      public function setCollideRect(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._testRect.top = param2;
         this._testRect.left = param1;
         this._testRect.right = param3;
         this._testRect.bottom = param4;
      }
      
      public function getCollideRect() : Rectangle
      {
         return this._testRect.clone();
      }
      
      public function get canCollided() : Boolean
      {
         return this._canCollided;
      }
      
      public function set canCollided(param1:Boolean) : void
      {
         this._canCollided = param1;
      }
      
      public function get smallView() : SmallObject
      {
         return null;
      }
      
      public function get isLiving() : Boolean
      {
         return this._isLiving;
      }
      
      override public function moveTo(param1:Point) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc9_:Rectangle = null;
         var _loc10_:Array = null;
         if(Point.distance(param1,pos) >= 3)
         {
            _loc2_ = Math.abs(int(param1.x) - int(x));
            _loc3_ = Math.abs(int(param1.y) - int(y));
            _loc4_ = _loc2_ > _loc3_ ? int(int(_loc2_)) : int(int(_loc3_));
            _loc5_ = 1 / Number(_loc4_);
            _loc6_ = pos;
            _loc8_ = Math.abs(_loc4_);
            while(_loc8_ > 0)
            {
               _loc7_ = Point.interpolate(_loc6_,param1,_loc5_ * _loc8_);
               _loc9_ = this.getCollideRect();
               _loc9_.offset(_loc7_.x,_loc7_.y);
               _loc10_ = _map.getPhysicalObjects(_loc9_,this);
               if(_loc10_.length > 0)
               {
                  pos = _loc7_;
                  this.collideObject(_loc10_);
               }
               else if(!_map.IsRectangleEmpty(_loc9_))
               {
                  pos = _loc7_;
                  this.collideGround();
               }
               else if(_map.IsOutMap(_loc7_.x,_loc7_.y))
               {
                  pos = _loc7_;
                  this.flyOutMap();
               }
               if(!_isMoving)
               {
                  return;
               }
               _loc8_ -= 3;
            }
            pos = param1;
         }
      }
      
      public function calcObjectAngle(param1:Number = 16) : Number
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(_map)
         {
            _loc2_ = new Array();
            _loc3_ = new Array();
            _loc4_ = new Point();
            _loc5_ = new Point();
            _loc6_ = param1;
            _loc7_ = 1;
            while(_loc7_ <= _loc6_)
            {
               _loc10_ = -10;
               while(_loc10_ <= 10)
               {
                  if(_map.IsEmpty(x + _loc7_,y - _loc10_))
                  {
                     if(_loc10_ == -10)
                     {
                        break;
                     }
                     _loc2_.push(new Point(x + _loc7_,y - _loc10_));
                     break;
                  }
                  _loc10_++;
               }
               _loc11_ = -10;
               while(_loc11_ <= 10)
               {
                  if(_map.IsEmpty(x - _loc7_,y - _loc11_))
                  {
                     if(_loc11_ == -10)
                     {
                        break;
                     }
                     _loc3_.push(new Point(x - _loc7_,y - _loc11_));
                     break;
                  }
                  _loc11_++;
               }
               _loc7_ += 2;
            }
            _loc4_ = new Point(x,y);
            _loc5_ = new Point(x,y);
            _loc8_ = 0;
            while(_loc8_ < _loc2_.length)
            {
               _loc4_ = _loc4_.add(_loc2_[_loc8_]);
               _loc8_++;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc3_.length)
            {
               _loc5_ = _loc5_.add(_loc3_[_loc9_]);
               _loc9_++;
            }
            _loc4_.x /= _loc2_.length + 1;
            _loc4_.y /= _loc2_.length + 1;
            _loc5_.x /= _loc3_.length + 1;
            _loc5_.y /= _loc3_.length + 1;
            return MathUtils.GetAngleTwoPoint(_loc4_,_loc5_);
         }
         return 0;
      }
      
      public function calcObjectAngleDebug(param1:Number = 16) : Number
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(_map)
         {
            _loc2_ = new Array();
            _loc3_ = new Array();
            _loc4_ = new Point();
            _loc5_ = new Point();
            _loc6_ = param1;
            _loc7_ = 1;
            while(_loc7_ <= _loc6_)
            {
               _loc10_ = -10;
               while(_loc10_ <= 10)
               {
                  if(_map.IsEmpty(x + _loc7_,y - _loc10_))
                  {
                     if(_loc10_ == -10)
                     {
                        break;
                     }
                     _loc2_.push(new Point(x + _loc7_,y - _loc10_));
                     break;
                  }
                  _loc10_++;
               }
               _loc11_ = -10;
               while(_loc11_ <= 10)
               {
                  if(_map.IsEmpty(x - _loc7_,y - _loc11_))
                  {
                     if(_loc11_ == -10)
                     {
                        break;
                     }
                     _loc3_.push(new Point(x - _loc7_,y - _loc11_));
                     break;
                  }
                  _loc11_++;
               }
               _loc7_ += 2;
            }
            _loc4_ = new Point(x,y);
            _loc5_ = new Point(x,y);
            _loc8_ = 0;
            while(_loc8_ < _loc2_.length)
            {
               _loc4_ = _loc4_.add(_loc2_[_loc8_]);
               _loc8_++;
            }
            this.drawPoint(_loc2_,true);
            _loc9_ = 0;
            while(_loc9_ < _loc3_.length)
            {
               _loc5_ = _loc5_.add(_loc3_[_loc9_]);
               _loc9_++;
            }
            this.drawPoint(_loc3_,false);
            _loc4_.x /= _loc2_.length + 1;
            _loc4_.y /= _loc2_.length + 1;
            _loc5_.x /= _loc3_.length + 1;
            _loc5_.y /= _loc3_.length + 1;
            return MathUtils.GetAngleTwoPoint(_loc4_,_loc5_);
         }
         return 0;
      }
      
      private function drawPoint(param1:Array, param2:Boolean) : void
      {
         if(this._drawPointContainer == null)
         {
            this._drawPointContainer = new Sprite();
         }
         if(param2)
         {
            this._drawPointContainer.graphics.clear();
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            this._drawPointContainer.graphics.beginFill(16711680);
            this._drawPointContainer.graphics.drawCircle(param1[_loc3_].x,param1[_loc3_].y,2);
            this._drawPointContainer.graphics.endFill();
            _loc3_++;
         }
         _map.addChild(this._drawPointContainer);
      }
      
      protected function flyOutMap() : void
      {
         if(this._isLiving)
         {
            this.die();
         }
      }
      
      protected function collideObject(param1:Array) : void
      {
         var _loc2_:PhysicalObj = null;
         for each(_loc2_ in param1)
         {
            _loc2_.collidedByObject(this);
         }
      }
      
      protected function collideGround() : void
      {
         if(_isMoving)
         {
            stopMoving();
         }
      }
      
      public function collidedByObject(param1:PhysicalObj) : void
      {
      }
      
      public function setActionMapping(param1:String, param2:String) : void
      {
      }
      
      public function die() : void
      {
         this._isLiving = false;
         if(_isMoving)
         {
            stopMoving();
         }
      }
      
      public function getTestRect() : Rectangle
      {
         return this._testRect.clone();
      }
      
      public function isBox() : Boolean
      {
         return false;
      }
   }
}
