package luckStar.model
{
   import com.pickgliss.loader.DataAnalyzer;
   import luckStar.manager.LuckStarManager;
   
   public class LuckStarRankAnalyzer extends DataAnalyzer
   {
      
      private static const MAX_LIST:int = 5;
       
      
      public function LuckStarRankAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:Vector.<LuckStarPlayerInfo> = null;
         var _loc4_:XMLList = null;
         var _loc5_:Array = null;
         var _loc6_:LuckStarPlayerInfo = null;
         var _loc7_:int = 0;
         var _loc8_:LuckStarPlayerInfo = null;
         var _loc2_:XML = XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc4_ = _loc2_..rankInfo;
            _loc5_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length())
            {
               if(_loc7_ % MAX_LIST == 0 || _loc7_ == 0)
               {
                  _loc3_ = new Vector.<LuckStarPlayerInfo>();
                  _loc5_.push(_loc3_);
               }
               _loc6_ = new LuckStarPlayerInfo();
               _loc6_.name = String(_loc4_[_loc7_].@nickName);
               _loc6_.rank = int(_loc4_[_loc7_].@rank);
               _loc6_.starNum = int(_loc4_[_loc7_].@useStarNum);
               _loc6_.isVip = int(_loc4_[_loc7_].@isVip) != 0;
               _loc3_.push(_loc6_);
               _loc7_++;
            }
            _loc8_ = new LuckStarPlayerInfo();
            _loc8_.rank = int(_loc2_.myRank.@rank);
            _loc8_.starNum = int(_loc2_.myRank.@useStarNum);
            LuckStarManager.Instance.model.selfInfo = _loc8_;
            LuckStarManager.Instance.model.lastDate = String(_loc2_.@lastUpdateTime);
            LuckStarManager.Instance.model.rank = _loc5_;
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
