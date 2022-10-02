package petsBag.model
{
   import ddt.data.player.PlayerInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import pet.date.PetInfo;
   import petsBag.data.PetFarmGuildeInfo;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.event.PetsAdvancedEvent;
   import road7th.data.DictionaryData;
   import trainer.data.ArrowType;
   
   public class PetBagModel extends EventDispatcher
   {
       
      
      private var _currentPetInfo:PetInfo;
      
      private var _currentPlayerInfo:PlayerInfo;
      
      private var _adoptPets:DictionaryData;
      
      private var _eatPetsInfo:DictionaryData;
      
      public var eatPetsLevelUp:Boolean;
      
      private var _adoptItems:DictionaryData;
      
      public var isLoadPetTrainer:Boolean;
      
      public var CurrentPetFarmGuildeArrow:Object;
      
      public var IsFinishTask5:Boolean = false;
      
      private var _petGuildeOptionOnOff:DictionaryData;
      
      private var _petGuilde:DictionaryData;
      
      public var nextShowArrowID:int = 0;
      
      public var preShowArrowID:int = 0;
      
      public function PetBagModel()
      {
         super();
      }
      
      public function get eatPetsInfo() : DictionaryData
      {
         if(this._eatPetsInfo == null)
         {
            this._eatPetsInfo = new DictionaryData();
         }
         return this._eatPetsInfo;
      }
      
      public function set eatPetsInfo(param1:DictionaryData) : void
      {
         this._eatPetsInfo = param1;
         dispatchEvent(new PetsAdvancedEvent(PetsAdvancedEvent.EAT_PETS_COMPLETE));
      }
      
      public function get adoptPets() : DictionaryData
      {
         if(this._adoptPets == null)
         {
            this._adoptPets = new DictionaryData();
         }
         return this._adoptPets;
      }
      
      public function get adoptItems() : DictionaryData
      {
         if(this._adoptItems == null)
         {
            this._adoptItems = new DictionaryData();
         }
         return this._adoptItems;
      }
      
      public function get currentPlayerInfo() : PlayerInfo
      {
         return this._currentPlayerInfo;
      }
      
      public function set currentPlayerInfo(param1:PlayerInfo) : void
      {
         this._currentPlayerInfo = param1;
      }
      
      public function get currentPetInfo() : PetInfo
      {
         return this._currentPetInfo;
      }
      
      public function set currentPetInfo(param1:PetInfo) : void
      {
         if(param1 == this._currentPetInfo)
         {
            return;
         }
         this._currentPetInfo = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get petGuildeOptionOnOff() : DictionaryData
      {
         if(!this._petGuildeOptionOnOff)
         {
            this._petGuildeOptionOnOff = new DictionaryData();
            this._petGuildeOptionOnOff.add(ArrowType.CHOOSE_PET_SKILL,0);
            this._petGuildeOptionOnOff.add(ArrowType.USE_PET_SKILL,0);
         }
         return this._petGuildeOptionOnOff;
      }
      
      public function get petGuilde() : DictionaryData
      {
         if(this._petGuilde == null)
         {
            this._petGuilde = new DictionaryData();
            this.initPetGuilde(this._petGuilde);
         }
         return this._petGuilde;
      }
      
      private function initPetGuilde(param1:DictionaryData) : void
      {
         var _loc2_:PetFarmGuildeInfo = null;
         var _loc3_:Vector.<PetFarmGuildeInfo> = null;
         _loc3_ = new Vector.<PetFarmGuildeInfo>();
         _loc2_ = new PetFarmGuildeInfo();
         _loc2_.arrowID = ArrowType.OPEN_PET_BAG;
         _loc2_.PreArrowID = 0;
         _loc2_.NextArrowID = ArrowType.OPEN_PET_LABEL;
         _loc3_.push(_loc2_);
         _loc2_ = new PetFarmGuildeInfo();
         _loc2_.arrowID = ArrowType.OPEN_PET_LABEL;
         _loc2_.PreArrowID = ArrowType.OPEN_PET_BAG;
         _loc2_.NextArrowID = ArrowType.FEED_PET;
         _loc3_.push(_loc2_);
         _loc2_ = new PetFarmGuildeInfo();
         _loc2_.arrowID = ArrowType.FEED_PET;
         _loc2_.PreArrowID = ArrowType.OPEN_PET_LABEL;
         _loc2_.NextArrowID = 0;
         _loc3_.push(_loc2_);
         this._petGuilde.add(PetFarmGuildeTaskType.PET_TASK2,_loc3_);
         _loc2_ = new PetFarmGuildeInfo();
         _loc2_.arrowID = ArrowType.JOIN_GAME;
         _loc2_.PreArrowID = 0;
         _loc2_.NextArrowID = 0;
         _loc3_.push(_loc2_);
         this._petGuilde.add(PetFarmGuildeTaskType.PET_TASK3,_loc3_);
      }
   }
}
