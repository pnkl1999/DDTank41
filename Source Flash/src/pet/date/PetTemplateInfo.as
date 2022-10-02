package pet.date
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class PetTemplateInfo extends EventDispatcher
   {
       
      
      public var TemplateID:int;
      
      public var Name:String = "";
      
      public var KindID:int;
      
      public var Description:String;
      
      public var RareLevel:int;
      
      public var StarLevel:int;
      
      public var GameAssetUrl:String;
      
      public var Pic:String;
      
      public var MP:int;
      
      public var HighAttack:int;
      
      public var HighDefence:int;
      
      public var HighAgility:int;
      
      public var HighLuck:int;
      
      public var HighBlood:int;
      
      public var HighDamage:int;
      
      public var HighGuard:int;
      
      public var HighAttackGrow:int;
      
      public var HighDefenceGrow:int;
      
      public var HighAgilityGrow:int;
      
      public var HighLuckGrow:int;
      
      public var HighBloodGrow:int;
      
      public var HighDamageGrow:int;
      
      public var HighGuardGrow:int;
      
      public function PetTemplateInfo(param1:IEventDispatcher = null)
      {
         super(param1);
      }
   }
}
