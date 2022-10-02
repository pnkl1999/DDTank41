package game.model
{
   import ddt.events.LivingEvent;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import pet.date.PetInfo;
   
   public class Pet extends EventDispatcher
   {
       
      
      private var _MP:int;
      
      private var _maxMP:int = 100;
      
      private var _petInfo:PetInfo;
      
      private var _petBeatInfo:Dictionary;
      
      public function Pet(param1:PetInfo)
      {
         this._petBeatInfo = new Dictionary();
         super();
         this._petInfo = param1;
      }
      
      public function get petInfo() : PetInfo
      {
         return this._petInfo;
      }
      
      public function get MP() : int
      {
         return this._MP;
      }
      
      public function set MP(param1:int) : void
      {
         if(param1 == this._MP)
         {
            return;
         }
         this._MP = param1;
         dispatchEvent(new LivingEvent(LivingEvent.PET_MP_CHANGE));
      }
      
      public function get MaxMP() : int
      {
         return this._maxMP;
      }
      
      public function set MaxMP(param1:int) : void
      {
         this._maxMP = param1;
      }
      
      public function get equipedSkillIDs() : Array
      {
         return this._petInfo.equipdSkills.list;
      }
      
      public function useSkill(param1:int, param2:Boolean) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.USE_PET_SKILL,param1));
      }
      
      public function get petBeatInfo() : Dictionary
      {
         return this._petBeatInfo;
      }
   }
}
