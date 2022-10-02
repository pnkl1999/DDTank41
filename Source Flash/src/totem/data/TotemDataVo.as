package totem.data
{
   public class TotemDataVo
   {
       
      
      public var ID:int;
      
      public var ConsumeExp:int;
      
      public var DiscountMoney:int;
      
      public var ConsumeHonor:int;
      
      public var AddAttack:int;
      
      public var AddDefence:int;
      
      public var AddAgility:int;
      
      public var AddLuck:int;
      
      public var AddBlood:int;
      
      public var AddDamage:int;
      
      public var AddGuard:int;
      
      public var Random:int;
      
      public var Page:int;
      
      public var Layers:int;
      
      public var Location:int;
      
      public var Point:int;
      
      public function TotemDataVo()
      {
         super();
      }
      
      public function get addValue() : int
      {
         return this.AddAttack + this.AddDefence + this.AddAgility + this.AddLuck + this.AddBlood + this.AddDamage + this.AddGuard;
      }
   }
}
