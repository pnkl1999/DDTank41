package game.view
{
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   [Event(name="complete",type="flash.events.Event")]
   public class AutoPropEffect extends Sprite
   {
       
      
      private var _age:Number;
      
      private var _last:uint;
      
      public function AutoPropEffect(param1:DisplayObject)
      {
         super();
         param1.x = -20;
         addChild(param1);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
      }
      
      private function __addToStage(param1:Event) : void
      {
         this._age = 0;
         this._last = getTimer();
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function __enterFrame(param1:Event) : void
      {
         if(parent)
         {
            this._age += 0.2;
            this._last = getTimer();
            if(this._age <= 1)
            {
               this.alpha = this._age;
            }
            else if(this._age < 4)
            {
               alpha = 1;
            }
            else if(this._age < 5)
            {
               if(5 - this._age > 0.2)
               {
                  alpha = 5 - this._age;
               }
            }
            else if(this._age < 6)
            {
               alpha = 1;
            }
            else if(this._age > 8)
            {
               alpha = 5 - this._age;
               if(alpha < 0.2)
               {
                  ObjectUtils.disposeAllChildren(this);
                  parent.removeChild(this);
                  removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
                  this.dispatchEvent(new Event(Event.COMPLETE));
               }
            }
         }
      }
   }
}
