package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   import trainer.data.LevelRewardInfo;
   
   public class LevelRewardAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      public function LevelRewardAnalyzer(param1:Function)
      {
         this.list = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:Dictionary = null;
         var _loc7_:XMLList = null;
         var _loc8_:XML = null;
         var _loc9_:LevelRewardInfo = null;
         var _loc2_:XML = XML(param1);
         var _loc3_:XMLList = _loc2_.reward;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.@level;
            _loc6_ = new Dictionary();
            _loc7_ = _loc4_.rewardItem;
            for each(_loc8_ in _loc7_)
            {
               _loc9_ = new LevelRewardInfo();
               _loc9_.sort = int(_loc8_.@sort);
               _loc9_.title = String(_loc8_.@title);
               _loc9_.content = String(_loc8_.@content);
               _loc9_.girlItems = String(_loc8_.@items).split("|")[0].split(",");
               _loc9_.boyItems = String(_loc8_.@items).split("|")[1].split(",");
               _loc6_[_loc9_.sort] = _loc9_;
            }
            this.list[_loc5_] = _loc6_;
         }
         onAnalyzeComplete();
      }
   }
}
