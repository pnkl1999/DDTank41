package totem.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemLeftWindowOpenCartoonView extends Sprite implements Disposeable
   {
       
      
      private var _pointBomb:MovieClip;
      
      private var _lightBomb:MovieClip;
      
      private var _failPointBomb:MovieClip;
      
      private var _failTipTxtBitmap:Bitmap;
      
      private var _moveLightList:Vector.<MovieClip>;
      
      private var _openUsedNextPointInfo:TotemDataVo;
      
      private var _openUsedCallback:Function;
      
      private var _failOpenNextPointInfo:TotemDataVo;
      
      private var _failOpenCallback:Function;
      
      private var _totemPointLocationList:Array;
      
      private var __refreshGlowFilter:Function;
      
      private var __refreshTotemPoint:Function;
      
      private var _addTxt:FilterFrameText;
      
      private var _propertyTxtList:Array;
      
      private var _failBombCount:int;
      
      private var _bombCount:int;
      
      private var _moveTxtCount:int;
      
      private var _moveTxtEndCallbackTag:int;
      
      private var _moveLightCount:int;
      
      public function TotemLeftWindowOpenCartoonView(param1:Array, param2:Function, param3:Function)
      {
         super();
         this._totemPointLocationList = param1;
         this.__refreshGlowFilter = param2;
         this.__refreshTotemPoint = param3;
         this._pointBomb = ComponentFactory.Instance.creat("asset.totem.open.pointBomb");
         this._lightBomb = ComponentFactory.Instance.creat("asset.totem.open.lightBomb");
         this._pointBomb.gotoAndStop(2);
         this._lightBomb.gotoAndStop(2);
         this._failPointBomb = ComponentFactory.Instance.creat("asset.totem.failOpen.pointBomb");
         this._failPointBomb.gotoAndStop(2);
         this._failTipTxtBitmap = ComponentFactory.Instance.creatBitmap("asset.totem.failOpen.tipTxt");
         this._addTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemOpenCartoon.moveTxt");
         this._addTxt.alpha = 0;
         this._propertyTxtList = LanguageMgr.GetTranslation("ddt.totem.sevenProperty").split(",");
      }
      
      public function failRefreshView(param1:TotemDataVo, param2:Function = null) : void
      {
         this._failOpenNextPointInfo = param1;
         this._failOpenCallback = param2;
         this.showFailOpenCartoon();
      }
      
      private function showFailOpenCartoon() : void
      {
         var _loc1_:Object = null;
         _loc1_ = null;
         _loc1_ = null;
         _loc1_ = null;
         _loc1_ = this._totemPointLocationList[this._failOpenNextPointInfo.Page - 1][this._failOpenNextPointInfo.Location - 1];
         this._lightBomb.gotoAndStop(1);
         this._failPointBomb.x = _loc1_.x;
         this._failPointBomb.y = _loc1_.y - 25;
         this._lightBomb.x = _loc1_.x;
         this._lightBomb.y = _loc1_.y + 17;
         addChild(this._lightBomb);
         this._failTipTxtBitmap.x = _loc1_.x - 26;
         this._failTipTxtBitmap.y = _loc1_.y - 15;
         this._failBombCount = 0;
         this._lightBomb.addEventListener(Event.ENTER_FRAME,this.lightBombFrameHandler,false,0,true);
      }
      
      private function lightBombFrameHandler(param1:Event) : void
      {
         ++this._failBombCount;
         if(this._failBombCount == 8)
         {
            this._lightBomb.removeEventListener(Event.ENTER_FRAME,this.lightBombFrameHandler);
            this._lightBomb.gotoAndStop(2);
            removeChild(this._lightBomb);
            this._failPointBomb.gotoAndStop(1);
            addChild(this._failPointBomb);
            this._failBombCount = 0;
            this._failPointBomb.addEventListener(Event.ENTER_FRAME,this.pointBombFrameHandler,false,0,true);
         }
      }
      
      private function pointBombFrameHandler(param1:Event) : void
      {
         ++this._failBombCount;
         if(this._failBombCount == 6)
         {
            addChild(this._failTipTxtBitmap);
            TweenLite.to(this._failTipTxtBitmap,0.6,{
               "y":this._failTipTxtBitmap.y - 56,
               "onComplete":this.moveFailTxtCompleteHandler
            });
         }
         else if(this._failBombCount == 14)
         {
            if(this._failPointBomb)
            {
               this._failPointBomb.removeEventListener(Event.ENTER_FRAME,this.pointBombFrameHandler);
               this._failPointBomb.gotoAndStop(2);
               removeChild(this._failPointBomb);
            }
         }
      }
      
      private function moveFailTxtCompleteHandler() : void
      {
         if(this._failTipTxtBitmap)
         {
            removeChild(this._failTipTxtBitmap);
         }
         if(this._failOpenCallback != null)
         {
            this._failOpenCallback();
            this._failOpenCallback = null;
         }
         this._failOpenNextPointInfo = null;
      }
      
      public function refreshView(param1:TotemDataVo, param2:Function = null) : void
      {
         this._openUsedNextPointInfo = param1;
         this._openUsedCallback = param2;
         this.showOpenCartoon();
      }
      
      private function showOpenCartoon() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this._openUsedNextPointInfo)
         {
            _loc1_ = 5;
            _loc2_ = 7;
         }
         else if(this._openUsedNextPointInfo.Location == 1)
         {
            if(this._openUsedNextPointInfo.Layers == 1)
            {
               _loc1_ = this._openUsedNextPointInfo.Page - 1;
            }
            else
            {
               _loc1_ = this._openUsedNextPointInfo.Page;
            }
            _loc2_ = 7;
         }
         else
         {
            _loc1_ = this._openUsedNextPointInfo.Page;
            _loc2_ = this._openUsedNextPointInfo.Location - 1;
         }
         this.addTotemPointCartoon(this._totemPointLocationList[_loc1_ - 1][_loc2_ - 1]);
      }
      
      private function addTotemPointCartoon(param1:Object) : void
      {
         this._pointBomb.gotoAndStop(1);
         this._lightBomb.gotoAndStop(1);
         this._pointBomb.x = param1.x;
         this._pointBomb.y = param1.y - 25;
         this._lightBomb.x = param1.x;
         this._lightBomb.y = param1.y + 17;
         addChild(this._lightBomb);
         addChild(this._pointBomb);
         this._addTxt.x = param1.x - 26;
         this._addTxt.y = param1.y - 15;
         this._bombCount = 0;
         this._pointBomb.addEventListener(Event.ENTER_FRAME,this.bombFrameHandler,false,0,true);
      }
      
      private function bombFrameHandler(param1:Event) : void
      {
         ++this._bombCount;
         if(this._bombCount == 8)
         {
            this._lightBomb.gotoAndStop(2);
            removeChild(this._lightBomb);
         }
         if(this._bombCount == 24)
         {
            this._pointBomb.removeEventListener(Event.ENTER_FRAME,this.bombFrameHandler);
            this._pointBomb.gotoAndStop(2);
            removeChild(this._pointBomb);
            this._moveTxtEndCallbackTag = 0;
            if(this._openUsedNextPointInfo && this._openUsedNextPointInfo.Location != 1)
            {
               this.__refreshGlowFilter(this._openUsedNextPointInfo.Page,this._openUsedNextPointInfo);
               this.showMoveLigthCartoon();
            }
            else if(this._openUsedNextPointInfo && this._openUsedNextPointInfo.Page != 1 && this._openUsedNextPointInfo.Layers == 1 && this._openUsedNextPointInfo.Location == 1)
            {
               this._moveTxtEndCallbackTag = 1;
            }
            else
            {
               this._moveTxtEndCallbackTag = 2;
            }
            this.showMoveTxt();
         }
      }
      
      private function showMoveTxt() : void
      {
         var _loc1_:int = 0;
         if(this._openUsedNextPointInfo)
         {
            _loc1_ = this._openUsedNextPointInfo.Point - 1;
         }
         else
         {
            _loc1_ = 350;
         }
         var _loc2_:TotemDataVo = TotemManager.instance.getCurInfoByLevel(_loc1_);
         this._addTxt.text = this._propertyTxtList[_loc2_.Location - 1] + " +" + _loc2_.addValue;
         this._moveTxtCount = 0;
         this._addTxt.addEventListener(Event.ENTER_FRAME,this.moveTxtHandler,false,0,true);
         addChild(this._addTxt);
      }
      
      private function moveTxtHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         ++this._moveTxtCount;
         if(this._moveTxtCount >= 0 && this._moveTxtCount <= 8)
         {
            this._addTxt.y -= 4;
            this._addTxt.alpha += 1 / 8;
         }
         else if(this._moveTxtCount > 8 && this._moveTxtCount <= 16)
         {
            this._addTxt.alpha = 1;
         }
         else if(this._moveTxtCount > 16 && this._moveTxtCount < 22)
         {
            this._addTxt.y -= 6;
            this._addTxt.alpha -= 1 / 5;
         }
         else if(this._moveTxtCount >= 22)
         {
            this._addTxt.removeEventListener(Event.ENTER_FRAME,this.moveTxtHandler);
            this._addTxt.alpha = 0;
            if(this._moveTxtEndCallbackTag == 1)
            {
               this._openUsedNextPointInfo = null;
               if(this._openUsedCallback != null)
               {
                  this._openUsedCallback.apply();
               }
               this._openUsedCallback = null;
            }
            else if(this._moveTxtEndCallbackTag == 2)
            {
               if(!this._openUsedNextPointInfo)
               {
                  _loc2_ = 5;
               }
               else
               {
                  _loc2_ = this._openUsedNextPointInfo.Page;
               }
               this.__refreshTotemPoint(_loc2_,this._openUsedNextPointInfo,true);
               this._openUsedNextPointInfo = null;
            }
         }
      }
      
      private function showMoveLigthCartoon() : void
      {
         var _loc1_:Array = this._totemPointLocationList[this._openUsedNextPointInfo.Page - 1];
         var _loc2_:Object = _loc1_[this._openUsedNextPointInfo.Location - 2];
         var _loc3_:Object = _loc1_[this._openUsedNextPointInfo.Location - 1];
         var _loc4_:Number = _loc3_.y - _loc2_.y;
         var _loc5_:Number = _loc3_.x - _loc2_.x;
         var _loc6_:Number = _loc4_ / _loc5_;
         var _loc7_:Number = 0;
         if(_loc3_.x == _loc2_.x)
         {
            if(_loc3_.y > _loc2_.y)
            {
               _loc7_ = 90;
            }
            else
            {
               _loc7_ = -90;
            }
         }
         else if(_loc3_.x < _loc2_.x)
         {
            if(_loc3_.y > _loc2_.y)
            {
               _loc7_ = Math.atan(_loc6_) * (180 / Math.PI) + 180;
            }
            else
            {
               _loc7_ = Math.atan(_loc6_) * (180 / Math.PI) - 180;
            }
         }
         else
         {
            _loc7_ = Math.atan(_loc6_) * (180 / Math.PI);
         }
         var _loc8_:Number = Math.pow(Math.pow(_loc4_,2) + Math.pow(_loc5_,2),1 / 2);
         var _loc9_:Number = _loc8_ % 89.2;
         var _loc10_:int = _loc8_ / 89.2;
         if(_loc9_ > 10)
         {
            _loc10_ += 1;
         }
         this._moveLightList = new Vector.<MovieClip>();
         this.createMoveLight(_loc2_.x,_loc2_.y,_loc7_);
         if(_loc10_ >= 2)
         {
            this.createMoveLight((_loc8_ - 89.2) / _loc8_ * _loc5_ + _loc2_.x,(_loc8_ - 89.2) / _loc8_ * _loc4_ + _loc2_.y,_loc7_);
         }
         var _loc11_:int = 1;
         while(_loc11_ < _loc10_ - 1)
         {
            this.createMoveLight(89.2 * _loc11_ / _loc8_ * _loc5_ + _loc2_.x,89.2 * _loc11_ / _loc8_ * _loc4_ + _loc2_.y,_loc7_);
            _loc11_++;
         }
         this._moveLightCount = 0;
         this._moveLightList[0].addEventListener(Event.ENTER_FRAME,this.moveLightFrameHandler,false,0,true);
      }
      
      private function createMoveLight(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:MovieClip = null;
         _loc4_ = null;
         _loc4_ = ClassUtils.CreatInstance("asset.totem.open.moveLight");
         _loc4_.gotoAndStop(1);
         _loc4_.x = param1;
         _loc4_.y = param2;
         _loc4_.rotation = param3;
         addChild(_loc4_);
         this._moveLightList.push(_loc4_);
      }
      
      private function moveLightFrameHandler(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         ++this._moveLightCount;
         if(this._moveLightCount == 22)
         {
            this._moveLightList[0].removeEventListener(Event.ENTER_FRAME,this.moveLightFrameHandler);
            for each(_loc2_ in this._moveLightList)
            {
               _loc2_.gotoAndStop(2);
               if(_loc2_.parent)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
            }
            this._moveLightList = null;
            this.__refreshTotemPoint(this._openUsedNextPointInfo.Page,this._openUsedNextPointInfo,true);
            this._openUsedNextPointInfo = null;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:MovieClip = null;
         if(this._moveLightList && this._moveLightList.length > 0)
         {
            this._moveLightList[0].removeEventListener(Event.ENTER_FRAME,this.moveLightFrameHandler);
            for each(_loc1_ in this._moveLightList)
            {
               _loc1_.gotoAndStop(2);
               if(_loc1_.parent)
               {
                  _loc1_.parent.removeChild(_loc1_);
               }
            }
         }
         this._moveLightList = null;
         if(this._pointBomb)
         {
            this._pointBomb.removeEventListener(Event.ENTER_FRAME,this.bombFrameHandler);
            this._pointBomb.gotoAndStop(2);
         }
         this._pointBomb = null;
         if(this._lightBomb)
         {
            this._lightBomb.removeEventListener(Event.ENTER_FRAME,this.lightBombFrameHandler);
            this._lightBomb.gotoAndStop(2);
         }
         this._lightBomb = null;
         this._openUsedNextPointInfo = null;
         this._openUsedCallback = null;
         this._totemPointLocationList = null;
         this.__refreshGlowFilter = null;
         this.__refreshTotemPoint = null;
         if(this._addTxt)
         {
            this._addTxt.removeEventListener(Event.ENTER_FRAME,this.moveTxtHandler);
            ObjectUtils.disposeObject(this._addTxt);
         }
         this._addTxt = null;
         if(this._failPointBomb)
         {
            this._failPointBomb.removeEventListener(Event.ENTER_FRAME,this.pointBombFrameHandler);
            this._failPointBomb.gotoAndStop(2);
            if(this._failPointBomb.parent)
            {
               this._failPointBomb.parent.removeChild(this._failPointBomb);
            }
         }
         this._failPointBomb = null;
         if(this._failTipTxtBitmap)
         {
            TweenLite.killTweensOf(this._failTipTxtBitmap,true);
            if(this._failTipTxtBitmap.parent)
            {
               this._failTipTxtBitmap.parent.removeChild(this._failTipTxtBitmap);
            }
         }
         this._failTipTxtBitmap = null;
         this._failOpenNextPointInfo = null;
         this._failOpenCallback = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
