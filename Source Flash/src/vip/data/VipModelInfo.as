package vip.data
{
   import flash.utils.Dictionary;
   
   public class VipModelInfo
   {
       
      
      public var maxExp:int = 0;
      
      public var ExpForEachDay:int = 0;
      
      public var ExpDecreaseForEachDay:int = 0;
      
      public var upRuleDescription:String = "";
      
      public var RewardDescription:String = "";
      
      public var levelInfo:Dictionary;
      
      public function VipModelInfo()
      {
         this.levelInfo = new Dictionary();
         super();
      }
   }
}
