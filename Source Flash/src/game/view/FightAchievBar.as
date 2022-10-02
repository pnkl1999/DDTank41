package game.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class FightAchievBar extends Sprite implements Disposeable
   {
       
      
      private var _animates:Vector.<AchieveAnimation>;
      
      private var _displays:Vector.<AchieveAnimation>;
      
      private var _started:Boolean = false;
      
      public function FightAchievBar()
      {
         this._animates = new Vector.<AchieveAnimation>();
         this._displays = new Vector.<AchieveAnimation>();
         super();
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__onFrame);
      }
      
      public function addAnimate(param1:AchieveAnimation) : void
      {
         this._animates.push(param1);
         if(param1.interval <= 0)
         {
            this.playAnimate(param1);
         }
         if(!this._started)
         {
            addEventListener(Event.ENTER_FRAME,this.__onFrame);
            this._started = true;
         }
      }
      
      private function playAnimate(param1:AchieveAnimation) : void
      {
         var _loc2_:AchieveAnimation = null;
         param1.play();
         addChild(param1);
         param1.addEventListener(Event.COMPLETE,this.__animateComplete);
         this._displays.unshift(param1);
         if(this._displays.length > 4)
         {
            _loc2_ = this._displays.pop();
            this.removeAnimate(_loc2_);
            ObjectUtils.disposeObject(_loc2_);
         }
         this.drawLayer();
      }
      
      private function __animateComplete(param1:Event) : void
      {
         var _loc2_:AchieveAnimation = param1.currentTarget as AchieveAnimation;
         _loc2_.removeEventListener(Event.COMPLETE,this.__animateComplete);
         this.removeAnimate(_loc2_);
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __onFrame(param1:Event) : void
      {
         var _loc3_:AchieveAnimation = null;
         var _loc2_:int = getTimer();
         for each(_loc3_ in this._animates)
         {
            if(!_loc3_.show && _loc3_.delay >= _loc2_)
            {
               this.playAnimate(_loc3_);
            }
         }
      }
      
      public function removeAnimate(param1:AchieveAnimation) : void
      {
         var _loc2_:int = this._animates.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._animates.splice(_loc2_,1);
         }
         if(param1.show)
         {
            _loc2_ = this._displays.indexOf(param1);
            if(_loc2_ >= 0)
            {
               this._displays.splice(_loc2_,1);
            }
         }
         if(this._animates.length <= 0)
         {
            removeEventListener(Event.ENTER_FRAME,this.__onFrame);
            this._started = false;
         }
      }
      
      public function rePlayAnimate(param1:AchieveAnimation) : void
      {
      }
      
      public function getAnimate(param1:int) : AchieveAnimation
      {
         var _loc2_:AchieveAnimation = null;
         for each(_loc2_ in this._animates)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function drawLayer() : void
      {
         var _loc1_:int = this._displays.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(_loc2_ == 0)
            {
               this._displays[_loc2_].y = -this._displays[_loc2_].height;
            }
            else
            {
               this._displays[_loc2_].y = this._displays[_loc2_ - 1].y - this._displays[_loc2_].height - 4;
            }
            _loc2_++;
         }
      }
   }
}
