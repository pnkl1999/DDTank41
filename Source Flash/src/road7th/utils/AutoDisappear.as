package road7th.utils
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class AutoDisappear extends Sprite implements Disposeable
   {
       
      
      private var _life:Number;
      
      private var _age:Number;
      
      private var _last:Number;
      
      public function AutoDisappear(param1:DisplayObject, param2:Number = -1)
      {
         super();
         this._life = param2 * 1000;
         this._age = 0;
         addChild(param1);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
      }
      
      private function __addToStage(param1:Event) : void
      {
         this._last = getTimer();
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function __enterFrame(param1:Event) : void
      {
         if(parent)
         {
            this._age += getTimer() - this._last;
            this._last = getTimer();
            if(this._age > this._life)
            {
               parent.removeChild(this);
               removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
               this.dispatchEvent(new Event(Event.COMPLETE));
            }
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
