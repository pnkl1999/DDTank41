package vip.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   import vip.data.VipModelInfo;
   
   public class PlayerVIPLevleInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var info:VipModelInfo;
      
      public function PlayerVIPLevleInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:Dictionary = null;
         this.info = new VipModelInfo();
         _loc2_ = new XML(param1);
         if(_loc2_.@value == "true")
         {
            this.info.maxExp = _loc2_.@maxExp;
            this.info.ExpForEachDay = _loc2_.@ExpForEachDay;
            this.info.ExpDecreaseForEachDay = _loc2_.@ExpDecreaseForEachDay;
            this.info.upRuleDescription = _loc2_.@Description;
            this.info.RewardDescription = _loc2_.@RewardInfo;
            _loc3_ = _loc2_..Levels;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new Dictionary();
               _loc5_["level"] = _loc3_[_loc4_].@Level;
               _loc5_["ExpNeeded"] = _loc3_[_loc4_].@ExpNeeded;
               _loc5_["Description"] = _loc3_[_loc4_].@Description;
               this.info.levelInfo[_loc4_] = _loc5_;
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
