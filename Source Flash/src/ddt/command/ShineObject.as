package ddt.command
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ShineObject extends Sprite
   {
       
      
      private var _shiner:MovieClip;
      
      private var _addToBottom:Boolean;
      
      public function ShineObject(param1:MovieClip, param2:Boolean = true)
      {
         this._shiner = param1;
         this._addToBottom = param2;
         super();
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         addChild(this._shiner);
         this._shiner.stop();
      }
      
      private function initEvents() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
      }
      
      private function __addToStage(param1:Event) : void
      {
         if(parent)
         {
            this.scaleX = 1 / parent.scaleX;
            this.scaleY = 1 / parent.scaleY;
            this._shiner.x = (parent.width * parent.scaleX - this._shiner.width) * 0.5;
            this._shiner.y = (parent.height * parent.scaleY - this._shiner.height) * 0.5;
            if(this._addToBottom)
            {
               parent.addChildAt(this,0);
            }
         }
      }
      
      public function shine(param1:Boolean = false) : void
      {
         if(this._shiner)
         {
            if(!SoundManager.instance.isPlaying("044") && param1)
            {
               SoundManager.instance.play("044",false,true,100);
            }
            this._shiner.play();
         }
      }
      
      public function stopShine() : void
      {
         if(this._shiner)
         {
            SoundManager.instance.stop("044");
            this._shiner.gotoAndStop(1);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._shiner)
         {
            this._shiner.stop();
            ObjectUtils.disposeObject(this._shiner);
         }
         this._shiner = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
