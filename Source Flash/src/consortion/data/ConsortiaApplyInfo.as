package consortion.data
{
   public class ConsortiaApplyInfo
   {
       
      
      public var ID:int;
      
      public var ApplyDate:String;
      
      public var ConsortiaID:int;
      
      public var ConsortiaName:String;
      
      public var ChairmanID:int;
      
      public var ChairmanName:String;
      
      public var Remark:String;
      
      public var UserID:int;
      
      public var UserName:String;
      
      public var UserLevel:int;
      
      public var Repute:int;
      
      public var Win:int;
      
      public var Total:int;
      
      public var typeVIP:int;
      
      public var FightPower:int;
      
      public var Offer:int;
      
      public function ConsortiaApplyInfo()
      {
         super();
      }
      
      public function get IsVIP() : Boolean
      {
         return this.typeVIP >= 1;
      }
   }
}
