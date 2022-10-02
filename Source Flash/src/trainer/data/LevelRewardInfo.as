package trainer.data
{
   import ddt.manager.PlayerManager;
   
   public class LevelRewardInfo
   {
       
      
      public var sort:int;
      
      public var title:String;
      
      public var content:String;
      
      public var boyItems:Array;
      
      public var girlItems:Array;
      
      public function LevelRewardInfo()
      {
         super();
      }
      
      public function get items() : Array
      {
         if(PlayerManager.Instance.Self.Sex)
         {
            return this.boyItems;
         }
         return this.girlItems;
      }
   }
}
