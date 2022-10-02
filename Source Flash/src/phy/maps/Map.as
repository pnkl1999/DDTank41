package phy.maps
{
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import par.enginees.ParticleEnginee;
   import par.renderer.DisplayObjectRenderer;
   import phy.object.PhysicalObj;
   import phy.object.Physics;
   import phy.object.PhysicsLayer;
   
   public class Map extends Sprite
   {
      
      private static var FRAME_TIME_OVER_TAG:int;
      
      private static var FRAME_OVER_COUNT_TAG:int;
       
      
      public var wind:Number = 3;
      
      public var windRate:Number = 1;
      
      public var gravity:Number = 9.8;
      
      public var airResistance:Number = 2;
      
      private var _objects:Dictionary;
      
      private var _phyicals:Dictionary;
      
      private var _bound:Rectangle;
      
      private var _partical:ParticleEnginee;
      
      protected var _sky:DisplayObject;
      
      protected var _stone:Ground;
      
      protected var _middle:DisplayObject;
      
      protected var _ground:Ground;
      
      protected var _livingLayer:Sprite;
      
      protected var _phyLayer:Sprite;
      
      protected var _mapThing:Sprite;
      
      private var _lastCheckTime:int = 0;
      
      private var _frameTimeOverCount:int = 0;
      
      protected var _mapChanged:Boolean = false;
      
      private var _isLackOfFPS:Boolean = false;
      
      public function Map(param1:DisplayObject, param2:Ground = null, param3:Ground = null, param4:DisplayObject = null)
      {
         super();
         this._phyicals = new Dictionary();
         this._objects = new Dictionary();
         this._sky = param1;
         addChild(this._sky);
         graphics.beginFill(0,1);
         graphics.drawRect(0,0,this._sky.width * 1.5,this._sky.height * 1.5);
         graphics.endFill();
         this._stone = param3;
         this._middle = param4;
         if(this._middle)
         {
            addChild(this._middle);
         }
         if(this._stone)
         {
            addChild(this._stone);
         }
         this._ground = param2;
         if(this._ground)
         {
            addChild(this._ground);
         }
         this._livingLayer = new Sprite();
         addChild(this._livingLayer);
         this._phyLayer = new Sprite();
         addChild(this._phyLayer);
         this._mapThing = new Sprite();
         addChild(this._mapThing);
         var _loc5_:DisplayObjectRenderer = new DisplayObjectRenderer();
         this._phyLayer.addChild(_loc5_);
         this._partical = new ParticleEnginee(_loc5_);
         if(this._ground)
         {
            this._bound = new Rectangle(0,0,this._ground.width,this._ground.height);
         }
         else
         {
            this._bound = new Rectangle(0,0,this._stone.width,this._stone.height);
         }
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      public function get bound() : Rectangle
      {
         return this._bound;
      }
      
      public function get sky() : DisplayObject
      {
         return this._sky;
      }
      
      public function get mapThingLayer() : DisplayObjectContainer
      {
         return this._mapThing;
      }
      
      public function get ground() : Ground
      {
         return this._ground;
      }
      
      public function get stone() : Ground
      {
         return this._stone;
      }
      
      public function get particleEnginee() : ParticleEnginee
      {
         return this._partical;
      }
      
      public function Dig(param1:Point, param2:Bitmap, param3:Bitmap = null) : void
      {
         this._mapChanged = true;
         if(this._ground)
         {
            this._ground.Dig(param1,param2,param3);
         }
         if(this._stone)
         {
            this._stone.Dig(param1,param2,param3);
         }
      }
      
      public function get mapChanged() : Boolean
      {
         return this._mapChanged;
      }
      
      public function resetMapChanged() : void
      {
         this._mapChanged = false;
      }
      
      public function IsEmpty(param1:int, param2:int) : Boolean
      {
         return (this._ground == null || this._ground.IsEmpty(param1,param2)) && (this._stone == null || this._stone.IsEmpty(param1,param2));
      }
      
      public function IsRectangleEmpty(param1:Rectangle) : Boolean
      {
         return (this._ground == null || this._ground.IsRectangeEmptyQuick(param1)) && (this._stone == null || this._stone.IsRectangeEmptyQuick(param1));
      }
      
      public function findYLineNotEmptyPointDown(param1:int, param2:int, param3:int) : Point
      {
         param1 = param1 < 0 ? int(int(0)) : (param1 >= this._bound.width ? int(int(this._bound.width - 1)) : int(int(param1)));
         param2 = param2 < 0 ? int(int(0)) : int(int(param2));
         param3 = param2 + param3 >= this._bound.height ? int(int(this._bound.height - param2 - 1)) : int(int(param3));
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            if(!this.IsEmpty(param1 - 1,param2) || !this.IsEmpty(param1 + 1,param2))
            {
               return new Point(param1,param2);
            }
            param2++;
            _loc4_++;
         }
         return null;
      }
      
      public function findYLineNotEmptyPointUp(param1:int, param2:int, param3:int) : Point
      {
         param1 = param1 < 0 ? int(int(0)) : (param1 > this._bound.width ? int(int(this._bound.width)) : int(int(param1)));
         param2 = param2 < 0 ? int(int(0)) : int(int(param2));
         param3 = param2 + param3 > this._bound.height ? int(int(this._bound.height - param2)) : int(int(param3));
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            if(!this.IsEmpty(param1 - 1,param2) || !this.IsEmpty(param1 + 1,param2))
            {
               return new Point(param1,param2);
            }
            param2--;
            _loc4_++;
         }
         return null;
      }
      
      public function findNextWalkPoint(param1:int, param2:int, param3:int, param4:int, param5:int) : Point
      {
         if(param3 != 1 && param3 != -1)
         {
            return null;
         }
         var _loc6_:int = param1 + param3 * param4;
         if(_loc6_ < 0 || _loc6_ > this._bound.width)
         {
            return null;
         }
         var _loc7_:Point = this.findYLineNotEmptyPointDown(_loc6_,param2 - param5 - 1,this._bound.height);
         if(_loc7_)
         {
            if(Math.abs(_loc7_.y - param2) > param5)
            {
               _loc7_ = null;
            }
         }
         return _loc7_;
      }
      
      public function canMove(param1:int, param2:int) : Boolean
      {
         return this.IsEmpty(param1,param2) && !this.IsOutMap(param1,param2);
      }
      
      public function IsOutMap(param1:int, param2:int) : Boolean
      {
         if(param1 < this._bound.x || param1 > this._bound.width || param2 > this._bound.height)
         {
            return true;
         }
         return false;
      }
      
      public function addPhysical(param1:Physics) : void
      {
         if(param1 is PhysicalObj)
         {
            this._phyicals[param1] = param1;
            if(param1.layer == PhysicsLayer.GhostBox)
            {
               this._phyLayer.addChild(param1);
            }
            else if(param1.layer == PhysicsLayer.SimpleObject)
            {
               this._livingLayer.addChild(param1);
            }
            else if(param1.layer == PhysicsLayer.GameLiving)
            {
               this._livingLayer.addChild(param1);
            }
            else if(param1.layer == PhysicsLayer.Tomb || param1.layer == PhysicsLayer.AppointBottom)
            {
               this._livingLayer.addChildAt(param1,0);
            }
            else
            {
               this._phyLayer.addChild(param1);
            }
         }
         else
         {
            this._objects[param1] = param1;
            addChild(param1);
         }
         param1.setMap(this);
      }
      
      public function addToPhyLayer(param1:DisplayObject) : void
      {
         this._phyLayer.addChild(param1);
      }
      
      public function get livngLayer() : DisplayObjectContainer
      {
         return this._livingLayer;
      }
      
      public function addMapThing(param1:Physics) : void
      {
         this._mapThing.addChild(param1);
         param1.setMap(this);
         if(param1 is PhysicalObj)
         {
            this._phyicals[param1] = param1;
         }
         else
         {
            this._objects[param1] = param1;
         }
      }
      
      public function removeMapThing(param1:Physics) : void
      {
         this._mapThing.removeChild(param1);
         param1.setMap(null);
         if(param1 is PhysicalObj)
         {
            delete this._phyicals[param1];
         }
         else
         {
            delete this._objects[param1];
         }
      }
      
      public function setTopPhysical(param1:Physics) : void
      {
         param1.parent.setChildIndex(param1,param1.parent.numChildren - 1);
      }
      
      public function hasSomethingMoving() : Boolean
      {
         var _loc1_:PhysicalObj = null;
         for each(_loc1_ in this._phyicals)
         {
            if(_loc1_.isMoving())
            {
               return true;
            }
         }
         return false;
      }
      
      public function removePhysical(param1:Physics) : void
      {
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         param1.setMap(null);
         if(param1 is PhysicalObj)
         {
            if(this._phyicals == null || !this._phyicals[param1])
            {
               return;
            }
            delete this._phyicals[param1];
         }
         else
         {
            if(this._objects && !this._objects[param1])
            {
               return;
            }
            delete this._objects[param1];
         }
      }
      
      public function hidePhysical(param1:PhysicalObj) : void
      {
         var _loc2_:PhysicalObj = null;
         for each(_loc2_ in this._phyicals)
         {
            if(_loc2_ != param1)
            {
               _loc2_.visible = false;
            }
         }
      }
      
      public function showPhysical() : void
      {
         var _loc1_:PhysicalObj = null;
         for each(_loc1_ in this._phyicals)
         {
            _loc1_.visible = true;
         }
      }
      
      public function getPhysicalObjects(param1:Rectangle, param2:PhysicalObj) : Array
      {
         var _loc4_:PhysicalObj = null;
         var _loc5_:Rectangle = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in this._phyicals)
         {
            if(_loc4_ != param2 && _loc4_.isLiving && _loc4_.canCollided)
            {
               _loc5_ = _loc4_.getCollideRect();
               _loc5_.offset(_loc4_.x,_loc4_.y);
               if(_loc5_.intersects(param1))
               {
                  _loc3_.push(_loc4_);
               }
            }
         }
         return _loc3_;
      }
      
      public function getPhysicalObjectByPoint(param1:Point, param2:Number, param3:PhysicalObj = null) : Array
      {
         var _loc5_:PhysicalObj = null;
         var _loc4_:Array = new Array();
         for each(_loc5_ in this._phyicals)
         {
            if(_loc5_ != param3 && _loc5_.isLiving && Point.distance(param1,_loc5_.pos) <= param2)
            {
               _loc4_.push(_loc5_);
            }
         }
         return _loc4_;
      }
      
      public function getBoxesByRect(param1:Rectangle) : Array
      {
         var _loc3_:PhysicalObj = null;
         var _loc4_:Rectangle = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._phyicals)
         {
            if(_loc3_.isBox() && _loc3_.isLiving)
            {
               _loc4_ = _loc3_.getTestRect();
               _loc4_.offset(_loc3_.x,_loc3_.y);
               if(_loc4_.intersects(param1))
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         return _loc2_;
      }
      
      private function __enterFrame(param1:Event) : void
      {
         this.update();
      }
      
      protected function update() : void
      {
         var _loc2_:Physics = null;
         var _loc1_:Number = numChildren;
         for each(_loc2_ in this._phyicals)
         {
            _loc2_.update(0.04);
         }
         this._partical.update();
      }
      
      private function checkOverFrameRate() : void
      {
         if(this._isLackOfFPS)
         {
            return;
         }
         var _loc1_:int = getTimer();
         if(this._lastCheckTime == 0)
         {
            this._lastCheckTime = _loc1_ - 40;
         }
         if(_loc1_ - this._lastCheckTime > FRAME_TIME_OVER_TAG)
         {
            ++this._frameTimeOverCount;
         }
         else
         {
            if(this._frameTimeOverCount > 0)
            {
            }
            this._frameTimeOverCount = 0;
         }
         this._lastCheckTime = _loc1_;
         if(this._frameTimeOverCount > FRAME_OVER_COUNT_TAG)
         {
            this._isLackOfFPS = true;
         }
      }
      
      public function getCollidedPhysicalObjects(param1:Rectangle, param2:PhysicalObj) : Array
      {
         var _loc4_:PhysicalObj = null;
         var _loc5_:Rectangle = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in this._phyicals)
         {
            if(_loc4_ != param2 && _loc4_.canCollided)
            {
               _loc5_ = _loc4_.getCollideRect();
               _loc5_.offset(_loc4_.x,_loc4_.y);
               if(_loc5_.intersects(param1))
               {
                  _loc3_.push(_loc4_);
               }
            }
         }
         return _loc3_;
      }
      
      public function get isLackOfFPS() : Boolean
      {
         return this._isLackOfFPS;
      }
      
      public function dispose() : void
      {
         var _loc3_:DisplayObject = null;
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         var _loc1_:Number = numChildren;
         var _loc2_:int = _loc1_ - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ is Physics)
            {
               Physics(_loc3_).dispose();
            }
            _loc2_--;
         }
         this._partical.dispose();
         if(this._ground)
         {
            this._ground.dispose();
         }
         this._ground = null;
         if(this._stone)
         {
            this._stone.dispose();
         }
         this._stone = null;
         if(this._middle)
         {
            if(this._middle.parent)
            {
               this._middle.parent.removeChild(this._middle);
            }
            this._middle = null;
         }
         removeChild(this._sky);
         this._sky = null;
         if(this._mapThing && this._mapThing.parent)
         {
            this._mapThing.parent.removeChild(this._mapThing);
         }
         ObjectUtils.disposeAllChildren(this);
         this._phyicals = null;
         this._objects = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
