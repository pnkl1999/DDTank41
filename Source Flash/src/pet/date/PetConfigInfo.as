package pet.date
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class PetConfigInfo extends EventDispatcher
   {
       
      
      public var FreeRefereshID:int;
      
      public var AdoptRefereshCost:int = 50;
      
      public var AddSkillLevel:String;
      
      public var RecycleCost:int = 0;
      
      public var ChangeNameCost:int = 50;
      
      public var PropertiesRate:int;
      
      public var MaxHunger:int;
      
      public var NotRemoveStar:int;
      
      public var HighRemoveStar:int;
      
      public var HighRemoveStarCost:int;
      
      public var NewPetDescribe:String;
      
      public function PetConfigInfo(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function get skillOpenLevel() : Array
      {
         return this.AddSkillLevel.split(",");
      }
   }
}
