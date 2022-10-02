package pet.sprite
{
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import pet.date.PetInfo;
   
   public class PetSpriteModel extends EventDispatcher
   {
      
      public static const CURRENT_PET_CHANGED:String = "currentPetChanged";
      
      public static const HUNGER_CHANGED:String = "hungerChanged";
      
      public static const GP_CHANGED:String = "gpChanged";
       
      
      private var _currentPet:PetInfo;
      
      private var _petSwitcher:Boolean = true;
      
      public function PetSpriteModel(param1:IEventDispatcher = null)
      {
         super(param1);
         this.initEvents();
      }
      
      public function get petSwitcher() : Boolean
      {
         return this._petSwitcher;
      }
      
      public function set petSwitcher(param1:Boolean) : void
      {
         this._petSwitcher = param1;
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updatePet);
      }
      
      protected function __updatePet(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[SelfInfo.PET] != null)
         {
            return;
         }
         if(this._currentPet != PlayerManager.Instance.Self.currentPet)
         {
            this.currentPet = PlayerManager.Instance.Self.currentPet;
         }
      }
      
      public function set currentPet(param1:PetInfo) : void
      {
         if(param1 == this._currentPet)
         {
            return;
         }
         this._currentPet = param1;
         dispatchEvent(new Event(CURRENT_PET_CHANGED));
      }
      
      private function __gpChanged() : void
      {
         dispatchEvent(new Event(GP_CHANGED));
      }
      
      protected function __hungerChanged(param1:Event) : void
      {
         dispatchEvent(new Event(HUNGER_CHANGED));
      }
      
      public function get currentPet() : PetInfo
      {
         return this._currentPet;
      }
   }
}
