package game.view.prop
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.events.LivingEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import game.model.Living;
   
   public class UsedPropBar extends Sprite implements Disposeable
   {
       
      
      private var _container:DisplayObjectContainer;
      
      private var _living:Living;
      
      private var _cells:Vector.<DisplayObject>;
      
      public function UsedPropBar()
      {
         super();
      }
      
      private function clearCells() : void
      {
      }
      
      public function setInfo(param1:Living) : void
      {
         this.clearCells();
         var _loc2_:Living = this._living;
         this._living = this._living;
         this.addEventToLiving(this._living);
         if(_loc2_ != null)
         {
            this.removeEventFromLiving(_loc2_);
         }
      }
      
      private function addEventToLiving(param1:Living) : void
      {
         param1.addEventListener(LivingEvent.USING_ITEM,this.__usingItem);
      }
      
      private function __usingItem(param1:LivingEvent) : void
      {
      }
      
      private function removeEventFromLiving(param1:Living) : void
      {
         param1.removeEventListener(LivingEvent.USING_ITEM,this.__usingItem);
      }
      
      public function dispose() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
