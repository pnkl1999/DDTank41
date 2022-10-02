package com.pickgliss.ui
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.core.ITransformableTipedDisplay;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.ui.vo.DirectionPos;
   import com.pickgliss.utils.Directions;
   import com.pickgliss.utils.DisplayUtils;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public final class ShowTipManager
   {
      
      public static const StartPoint:Point = new Point(0,0);
      
      private static var _instance:ShowTipManager;
       
      
      private var _currentTipObject:ITipedDisplay;
      
      private var _simpleTipset:Object;
      
      private var _tipContainer:DisplayObjectContainer;
      
      private var _tipedObjects:Vector.<ITipedDisplay>;
      
      private var _tips:Dictionary;
      
      private var _updateTempTarget:ITipedDisplay;
      
      public function ShowTipManager()
      {
         super();
         this._tips = new Dictionary();
         this._tipedObjects = new Vector.<ITipedDisplay>();
      }
      
      public static function get Instance() : ShowTipManager
      {
         if(_instance == null)
         {
            _instance = new ShowTipManager();
         }
         return _instance;
      }
      
      public function addTip(param1:ITipedDisplay) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.removeTipedObject(param1);
         this._tipedObjects.push(param1);
         param1.addEventListener(MouseEvent.ROLL_OVER,this.__onOver);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.__onOut);
         if(this._currentTipObject == param1)
         {
            this.showTip(this._currentTipObject);
         }
      }
      
      public function getTipPosByDirction(param1:ITip, param2:ITipedDisplay, param3:int) : Point
      {
         var _loc4_:Point = new Point();
         if(param3 == Directions.DIRECTION_T)
         {
            _loc4_.y = -param1.height - param2.tipGapV;
            _loc4_.x = (param2.width - param1.width) / 2;
         }
         else if(param3 == Directions.DIRECTION_L)
         {
            _loc4_.x = -param1.width - param2.tipGapH;
            _loc4_.y = (param2.height - param1.height) / 2;
         }
         else if(param3 == Directions.DIRECTION_R)
         {
            _loc4_.x = param2.width + param2.tipGapH;
            _loc4_.y = (param2.height - param1.height) / 2;
         }
         else if(param3 == Directions.DIRECTION_B)
         {
            _loc4_.y = param2.height + param2.tipGapV;
            _loc4_.x = (param2.width - param1.width) / 2;
         }
         else if(param3 == Directions.DIRECTION_TL)
         {
            _loc4_.y = -param1.height - param2.tipGapV;
            _loc4_.x = -param1.width - param2.tipGapH;
         }
         else if(param3 == Directions.DIRECTION_TR)
         {
            _loc4_.y = -param1.height - param2.tipGapV;
            _loc4_.x = param2.width + param2.tipGapH;
         }
         else if(param3 == Directions.DIRECTION_BL)
         {
            _loc4_.y = param2.height + param2.tipGapV;
            _loc4_.x = -param1.width - param2.tipGapH;
         }
         else if(param3 == Directions.DIRECTION_BR)
         {
            _loc4_.y = param2.height + param2.tipGapV;
            _loc4_.x = param2.width + param2.tipGapH;
         }
         return _loc4_;
      }
      
      public function hideTip(param1:ITipedDisplay) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:ITip = this._tips[param1.tipStyle];
         if(_loc2_ == null)
         {
            return;
         }
         if(this._tipContainer.contains(_loc2_.asDisplayObject()))
         {
            this._tipContainer.removeChild(_loc2_.asDisplayObject());
         }
         this._currentTipObject = null;
      }
      
      public function removeCurrentTip() : void
      {
         this.hideTip(this._currentTipObject);
      }
      
      public function removeAllTip() : void
      {
         var _loc1_:ITip = null;
         for each(_loc1_ in this._tips)
         {
            if(_loc1_.asDisplayObject().parent)
            {
               _loc1_.asDisplayObject().parent.removeChild(_loc1_.asDisplayObject());
            }
         }
      }
      
      public function removeTip(param1:ITipedDisplay) : void
      {
         this.removeTipedObject(param1);
         if(this._currentTipObject == param1)
         {
            this.hideTip(this._currentTipObject);
         }
      }
      
      public function setSimpleTip(param1:ITipedDisplay, param2:String = "") : void
      {
         if(this._simpleTipset == null)
         {
            return;
         }
         if(param1 is Component)
         {
            Component(param1).beginChanges();
         }
         param1.tipStyle = this._simpleTipset.tipStyle;
         param1.tipData = param2;
         param1.tipDirctions = this._simpleTipset.tipDirctions;
         param1.tipGapV = this._simpleTipset.tipGapV;
         param1.tipGapH = this._simpleTipset.tipGapH;
         if(param1 is Component)
         {
            Component(param1).commitChanges();
         }
      }
      
      public function setup() : void
      {
         this._tipContainer = LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER);
      }
      
      public function showTip(param1:*) : void
      {
         var _loc2_:* = this._tips[param1.tipStyle];
         if(param1 is ITipedDisplay)
         {
            this.setCommonTip(param1,_loc2_);
            _loc2_ = this._tips[param1.tipStyle];
         }
         if(param1 is ITransformableTipedDisplay)
         {
            _loc2_.tipWidth = param1.tipWidth;
            _loc2_.tipHeight = param1.tipHeight;
         }
         this.configPosition(param1,_loc2_);
         this._currentTipObject = param1;
         this._tipContainer.addChild(_loc2_.asDisplayObject());
      }
      
      public function getTipInstanceByStylename(param1:String) : ITip
      {
         return this._tips[param1];
      }
      
      public function updatePos() : void
      {
         if(!this._updateTempTarget)
         {
            return;
         }
         this.showTip(this._updateTempTarget);
      }
      
      private function setCommonTip(param1:*, param2:*) : void
      {
         if(param2 == null)
         {
            if(param1.tipStyle == null)
            {
               return;
            }
            param2 = this.createTipByStyleName(param1.tipStyle);
            if(param2 == null)
            {
               return;
            }
         }
         param2.tipData = param1.tipData;
      }
      
      public function createTipByStyleName(param1:String) : *
      {
         this._tips[param1] = ComponentFactory.Instance.creat(param1);
         return this._tips[param1];
      }
      
      private function configPosition(param1:*, param2:*) : void
      {
         var _loc3_:Point = this._tipContainer.globalToLocal(param1.localToGlobal(StartPoint));
         var _loc4_:Point = new Point();
         var _loc5_:DirectionPos = this.getTipPriorityDirction(param2,param1,param1.tipDirctions);
         _loc4_ = this.getTipPosByDirction(param2,param1,_loc5_.direction);
         if(_loc5_.offsetX < int.MAX_VALUE / 2)
         {
            param2.x = _loc4_.x + _loc3_.x + _loc5_.offsetX;
         }
         else
         {
            param2.x = _loc4_.x + _loc3_.x;
         }
         if(_loc5_.offsetY < int.MAX_VALUE / 2)
         {
            param2.y = _loc4_.y + _loc3_.y + _loc5_.offsetY;
         }
         else
         {
            param2.y = _loc4_.y + _loc3_.y;
         }
      }
      
      private function __onOut(param1:MouseEvent) : void
      {
         var _loc2_:ITipedDisplay = param1.currentTarget as ITipedDisplay;
         this.hideTip(_loc2_);
         this._updateTempTarget = null;
      }
      
      private function __onOver(param1:MouseEvent) : void
      {
         var _loc2_:ITipedDisplay = param1.currentTarget as ITipedDisplay;
         if(_loc2_.tipStyle == null)
         {
            return;
         }
         this.showTip(_loc2_);
         this._updateTempTarget = _loc2_;
      }
      
      private function getTipPriorityDirction(param1:ITip, param2:ITipedDisplay, param3:String) : DirectionPos
      {
         var _loc5_:DirectionPos = null;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc12_:DirectionPos = null;
         var _loc4_:Array = param3.split(",");
         var _loc6_:Vector.<DirectionPos> = new Vector.<DirectionPos>();
         var _loc7_:Point = this._tipContainer.globalToLocal(param2.localToGlobal(StartPoint));
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc9_ = this.getTipPosByDirction(param1,param2,_loc4_[_loc8_]);
            _loc10_ = new Point(_loc9_.x + _loc7_.x,_loc9_.y + _loc7_.y);
            _loc11_ = new Point(_loc9_.x + _loc7_.x + param1.width,_loc9_.y + _loc7_.y + param1.height);
            _loc12_ = this.creatDirectionPos(_loc10_,_loc11_,int(_loc4_[_loc8_]));
            if(_loc12_.offsetX == 0 && _loc12_.offsetY == 0)
            {
               _loc5_ = _loc12_;
               break;
            }
            _loc6_.push(_loc12_);
            _loc8_++;
         }
         if(_loc5_ == null)
         {
            _loc5_ = this.searchFixedDirectionPos(_loc6_);
         }
         return _loc5_;
      }
      
      private function searchFixedDirectionPos(param1:Vector.<DirectionPos>) : DirectionPos
      {
         var _loc2_:DirectionPos = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Vector.<DirectionPos> = param1.reverse();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc2_ == null)
            {
               _loc2_ = _loc3_[_loc4_];
            }
            else
            {
               _loc5_ = Math.abs(_loc3_[_loc4_].offsetX) + Math.abs(_loc3_[_loc4_].offsetY);
               _loc6_ = Math.abs(_loc2_.offsetX) + Math.abs(_loc2_.offsetY);
               if(_loc5_ <= _loc6_)
               {
                  _loc2_ = _loc3_[_loc4_];
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function creatDirectionPos(param1:Point, param2:Point, param3:int) : DirectionPos
      {
         var _loc4_:DirectionPos = new DirectionPos();
         _loc4_.direction = param3;
         if(param3 == Directions.DIRECTION_T)
         {
            if(param1.y < 0)
            {
               _loc4_.offsetY = int.MAX_VALUE / 2;
            }
            else
            {
               _loc4_.offsetY = 0;
            }
            if(param1.x < 0)
            {
               _loc4_.offsetX = -param1.x;
            }
            else if(param2.x > StageReferance.stageWidth)
            {
               _loc4_.offsetX = StageReferance.stageWidth - param2.x;
            }
            else
            {
               _loc4_.offsetX = 0;
            }
         }
         else if(param3 == Directions.DIRECTION_L)
         {
            if(param1.x < 0)
            {
               _loc4_.offsetX = int.MAX_VALUE / 2;
            }
            else
            {
               _loc4_.offsetX = 0;
            }
            if(param1.y < 0)
            {
               _loc4_.offsetY = -param1.y;
            }
            else if(param2.y > StageReferance.stageHeight)
            {
               _loc4_.offsetY = StageReferance.stageHeight - param2.y;
            }
            else
            {
               _loc4_.offsetY = 0;
            }
         }
         else if(param3 == Directions.DIRECTION_R)
         {
            if(param2.x > StageReferance.stageWidth)
            {
               _loc4_.offsetX = int.MAX_VALUE / 2;
            }
            else
            {
               _loc4_.offsetX = 0;
            }
            if(param1.y < 0)
            {
               _loc4_.offsetY = -param1.y;
            }
            else if(param2.y > StageReferance.stageHeight)
            {
               _loc4_.offsetY = StageReferance.stageHeight - param2.y;
            }
            else
            {
               _loc4_.offsetY = 0;
            }
         }
         else if(param3 == Directions.DIRECTION_B)
         {
            if(param2.y > StageReferance.stageHeight)
            {
               _loc4_.offsetY = int.MAX_VALUE / 2;
            }
            else
            {
               _loc4_.offsetY = 0;
            }
            if(param1.x < 0)
            {
               _loc4_.offsetX = -param1.x;
            }
            else if(param2.x > StageReferance.stageWidth)
            {
               _loc4_.offsetX = StageReferance.stageWidth - param2.x;
            }
            else
            {
               _loc4_.offsetX = 0;
            }
         }
         else if(DisplayUtils.isInTheStage(param1) && DisplayUtils.isInTheStage(param2))
         {
            _loc4_.offsetX = 0;
            _loc4_.offsetY = 0;
         }
         else
         {
            _loc4_.offsetY = int.MAX_VALUE / 2;
            _loc4_.offsetX = int.MAX_VALUE / 2;
         }
         return _loc4_;
      }
      
      private function removeTipedObject(param1:ITipedDisplay) : void
      {
         var _loc2_:int = this._tipedObjects.indexOf(param1);
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.__onOver);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.__onOut);
         if(_loc2_ != -1)
         {
            this._tipedObjects.splice(_loc2_,1);
         }
      }
   }
}
