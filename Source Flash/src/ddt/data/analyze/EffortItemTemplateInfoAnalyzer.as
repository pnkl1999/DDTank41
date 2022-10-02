package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortQualificationInfo;
   import ddt.data.effort.EffortRewardInfo;
   import road7th.data.DictionaryData;
   
   public class EffortItemTemplateInfoAnalyzer extends DataAnalyzer
   {
      
      private static const PATH:String = "AchievementList.xml";
       
      
      public var list:DictionaryData;
      
      public function EffortItemTemplateInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         var _loc6_:EffortInfo = null;
         var _loc7_:XMLList = null;
         var _loc8_:int = 0;
         var _loc9_:XMLList = null;
         var _loc10_:int = 0;
         var _loc11_:EffortQualificationInfo = null;
         var _loc12_:EffortRewardInfo = null;
         var _loc2_:XML = new XML(param1);
         this.list = new DictionaryData();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = _loc3_[_loc4_];
               _loc6_ = new EffortInfo();
               _loc6_.ID = _loc5_.@ID;
               _loc6_.PlaceID = _loc5_.@PlaceID;
               _loc6_.Title = _loc5_.@Title;
               _loc6_.Detail = _loc5_.@Detail;
               _loc6_.NeedMinLevel = _loc5_.@NeedMinLevel;
               _loc6_.NeedMaxLevel = _loc5_.@NeedMaxLevel;
               _loc6_.PreAchievementID = _loc5_.@PreAchievementID;
               _loc6_.IsOther = this.getBoolean(_loc5_.@IsOther);
               _loc6_.AchievementType = _loc5_.@AchievementType;
               _loc6_.CanHide = this.getBoolean(_loc5_.@CanHide);
               _loc6_.picId = _loc5_.@PicID;
               _loc6_.StartDate = new Date(String(_loc5_.@StartDate).substr(5,2) + "/" + String(_loc5_.@StartDate).substr(8,2) + "/" + String(_loc5_.@StartDate).substr(0,4));
               _loc6_.EndDate = new Date(String(_loc5_.@StartDate).substr(5,2) + "/" + String(_loc5_.@StartDate).substr(8,2) + "/" + String(_loc5_.@StartDate).substr(0,4));
               _loc6_.AchievementPoint = _loc5_.@AchievementPoint;
               _loc7_ = _loc5_..Item_Condiction;
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length())
               {
                  _loc11_ = new EffortQualificationInfo();
                  _loc11_.AchievementID = _loc7_[_loc8_].@AchievementID;
                  _loc11_.CondictionID = _loc7_[_loc8_].@CondictionID;
                  _loc11_.CondictionType = _loc7_[_loc8_].@CondictionType;
                  _loc11_.Condiction_Para1 = _loc7_[_loc8_].@Condiction_Para1;
                  _loc11_.Condiction_Para2 = _loc7_[_loc8_].@Condiction_Para2;
                  _loc6_.addEffortQualification(_loc11_);
                  _loc8_++;
               }
               _loc9_ = _loc5_..Item_Reward;
               _loc10_ = 0;
               while(_loc10_ < _loc9_.length())
               {
                  _loc12_ = new EffortRewardInfo();
                  _loc12_.AchievementID = _loc9_[_loc10_].@AchievementID;
                  _loc12_.RewardCount = _loc9_[_loc10_].@RewardCount;
                  _loc12_.RewardPara = _loc9_[_loc10_].@RewardPara;
                  _loc12_.RewardType = _loc9_[_loc10_].@RewardType;
                  _loc12_.RewardValueId = _loc9_[_loc10_].@RewardValueId;
                  _loc6_.addEffortReward(_loc12_);
                  _loc10_++;
               }
               this.list[_loc6_.ID] = _loc6_;
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
      
      private function getBoolean(param1:String) : Boolean
      {
         if(param1 == "true" || param1 == "1")
         {
            return true;
         }
         return false;
      }
   }
}
