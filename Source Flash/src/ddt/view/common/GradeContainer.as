package ddt.view.common
{
   import com.pickgliss.utils.ClassUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GradeContainer extends Sprite
   {
       
      
      private var _timer:Timer;
      
      private var _grade:MovieClip;
      
      private var _topLayer:Boolean;
      
      public function GradeContainer(param1:Boolean = false)
      {
         super();
         this._topLayer = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._timer = new Timer(6000,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this.clearGrade();
      }
      
      public function clearGrade() : void
      {
         if(this._grade != null)
         {
            if(this._grade.parent)
            {
               this._grade.stop();
               this._grade["lv_mc"]["lv_mc_init"]["video"].clear();
               this._grade.parent.removeChild(this._grade);
            }
            this._grade = null;
         }
         if(this._timer)
         {
            this._timer.stop();
         }
      }
      
      public function setGrade(param1:MovieClip) : void
      {
         this.clearGrade();
         this._grade = param1;
         if(this._grade != null)
         {
            this._timer.reset();
            this._timer.start();
            addChild(this._grade);
         }
      }
      
      public function playerGrade() : void
      {
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.core.playerLevelUpFaileAsset") as Class;
         var _loc2_:MovieClip = new _loc1_() as MovieClip;
         this.setGrade(_loc2_);
      }
      
      public function dispose() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._timer = null;
         this.clearGrade();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
