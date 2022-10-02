package game.view.propContainer
{
   import ddt.events.ItemEvent;
   import ddt.events.LivingEvent;
   import flash.display.Sprite;
   import game.model.LocalPlayer;
   
   public class BaseGamePropBarView extends Sprite
   {
       
      
      protected var _notExistTip:Sprite;
      
      protected var _itemContainer:ItemContainer;
      
      private var _self:LocalPlayer;
      
      public function BaseGamePropBarView(param1:LocalPlayer, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:Boolean, param7:String = "")
      {
         super();
         this._self = param1;
         this._itemContainer = new ItemContainer(param2,param3,param4,param5,param6,param7);
         addChild(this._itemContainer);
         this._self.addEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChange);
         this._self.addEventListener(LivingEvent.DIE,this.__die);
         this._self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
      }
      
      public function get itemContainer() : ItemContainer
      {
         return this._itemContainer;
      }
      
      public function get self() : LocalPlayer
      {
         return this._self;
      }
      
      public function setClickEnabled(param1:Boolean, param2:Boolean) : void
      {
         this._itemContainer.setState(param1,param2);
      }
      
      public function dispose() : void
      {
         this._self.removeEventListener(LivingEvent.DIE,this.__die);
         this._self.removeEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChange);
         this._self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
         removeChild(this._itemContainer);
         this._itemContainer.removeEventListener(ItemEvent.ITEM_CLICK,this.__click);
         this._itemContainer.removeEventListener(ItemEvent.ITEM_MOVE,this.__move);
         this._itemContainer.removeEventListener(ItemEvent.ITEM_OUT,this.__out);
         this._itemContainer.removeEventListener(ItemEvent.ITEM_OVER,this.__over);
         this._itemContainer.dispose();
         this._itemContainer = null;
         if(parent)
         {
            parent.removeChild(this);
            this._itemContainer = null;
         }
      }
      
      private function __changeAttack(param1:LivingEvent) : void
      {
         if(this._self.isAttacking && this._self.isLiving && !this._self.LockState)
         {
            this.setClickEnabled(false,false);
         }
      }
      
      private function __die(param1:LivingEvent) : void
      {
         this.setClickEnabled(false,false);
      }
      
      protected function __energyChange(param1:LivingEvent) : void
      {
         if(this._self.isLiving && !this._self.LockState)
         {
            this._itemContainer.setClickByEnergy(this._self.energy);
         }
         else if(this._self.isLiving && this._self.LockState)
         {
            this.setClickEnabled(false,true);
         }
      }
      
      protected function __move(param1:ItemEvent) : void
      {
      }
      
      public function setVisible(param1:int, param2:Boolean) : void
      {
         this._itemContainer.setVisible(param1,param2);
      }
      
      protected function __over(param1:ItemEvent) : void
      {
      }
      
      protected function __out(param1:ItemEvent) : void
      {
      }
      
      protected function __click(param1:ItemEvent) : void
      {
      }
      
      public function setLayerMode(param1:int) : void
      {
      }
   }
}
