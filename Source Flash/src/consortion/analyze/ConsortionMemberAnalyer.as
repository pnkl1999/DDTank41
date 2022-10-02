package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import consortion.ConsortionModelControl;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.PlayerManager;
   import road7th.data.DictionaryData;
   
   public class ConsortionMemberAnalyer extends DataAnalyzer
   {
       
      
      public var consortionMember:DictionaryData;
      
      public function ConsortionMemberAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc5_:ConsortiaPlayerInfo = null;
         _loc3_ = null;
         var _loc4_:int = 0;
         _loc5_ = null;
         var _loc6_:PlayerState = null;
         var _loc2_:XML = new XML(param1);
         this.consortionMember = new DictionaryData();
         if(_loc2_.@value == "true")
         {
            ConsortionModelControl.Instance.model.systemDate = XML(_loc2_).@currentDate;
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new ConsortiaPlayerInfo();
               _loc5_.beginChanges();
               _loc5_.IsVote = this.converBoolean(_loc3_[_loc4_].@IsVote);
               _loc5_.privateID = _loc3_[_loc4_].@ID;
               _loc5_.ConsortiaID = PlayerManager.Instance.Self.ConsortiaID;
               _loc5_.ConsortiaName = PlayerManager.Instance.Self.ConsortiaName;
               _loc5_.DutyID = _loc3_[_loc4_].@DutyID;
               _loc5_.DutyName = _loc3_[_loc4_].@DutyName;
               _loc5_.GP = _loc3_[_loc4_].@GP;
               _loc5_.Grade = _loc3_[_loc4_].@Grade;
               _loc5_.FightPower = _loc3_[_loc4_].@FightPower;
               _loc5_.AchievementPoint = _loc3_[_loc4_].@AchievementPoint;
               _loc5_.honor = _loc3_[_loc4_].@Rank;
               _loc5_.IsChat = this.converBoolean(_loc3_[_loc4_].@IsChat);
               _loc5_.IsDiplomatism = this.converBoolean(_loc3_[_loc4_].@IsDiplomatism);
               _loc5_.IsDownGrade = this.converBoolean(_loc3_[_loc4_].@IsDownGrade);
               _loc5_.IsEditorDescription = this.converBoolean(_loc3_[_loc4_].@IsEditorDescription);
               _loc5_.IsEditorPlacard = this.converBoolean(_loc3_[_loc4_].@IsEditorPlacard);
               _loc5_.IsEditorUser = this.converBoolean(_loc3_[_loc4_].@IsEditorUser);
               _loc5_.IsExpel = this.converBoolean(_loc3_[_loc4_].@IsExpel);
               _loc5_.IsInvite = this.converBoolean(_loc3_[_loc4_].@IsInvite);
               _loc5_.IsManageDuty = this.converBoolean(_loc3_[_loc4_].@IsManageDuty);
               _loc5_.IsRatify = this.converBoolean(_loc3_[_loc4_].@IsRatify);
               _loc5_.IsUpGrade = this.converBoolean(_loc3_[_loc4_].@IsUpGrade);
               _loc5_.IsBandChat = this.converBoolean(_loc3_[_loc4_].@IsBanChat);
               _loc5_.Offer = int(_loc3_[_loc4_].@Offer);
               _loc5_.RatifierID = _loc3_[_loc4_].@RatifierID;
               _loc5_.RatifierName = _loc3_[_loc4_].@RatifierName;
               _loc5_.Remark = _loc3_[_loc4_].@Remark;
               _loc5_.Repute = _loc3_[_loc4_].@Repute;
               _loc6_ = new PlayerState(int(_loc3_[_loc4_].@State));
               _loc5_.playerState = _loc6_;
               _loc5_.LastDate = _loc3_[_loc4_].@LastDate;
               _loc5_.ID = _loc3_[_loc4_].@UserID;
               _loc5_.NickName = _loc3_[_loc4_].@UserName;
               _loc5_.typeVIP = _loc3_[_loc4_].@typeVIP;
               _loc5_.VIPLevel = _loc3_[_loc4_].@VIPLevel;
               _loc5_.LoginName = _loc3_[_loc4_].@LoginName;
               _loc5_.Sex = this.converBoolean(_loc3_[_loc4_].@Sex);
               _loc5_.EscapeCount = _loc3_[_loc4_].@EscapeCount;
               _loc5_.Right = _loc3_[_loc4_].@Right;
               _loc5_.WinCount = _loc3_[_loc4_].@WinCount;
               _loc5_.TotalCount = _loc3_[_loc4_].@TotalCount;
               _loc5_.RichesOffer = _loc3_[_loc4_].@RichesOffer;
               _loc5_.RichesRob = _loc3_[_loc4_].@RichesRob;
               _loc5_.UseOffer = _loc3_[_loc4_].@TotalRichesOffer;
               _loc5_.DutyLevel = _loc3_[_loc4_].@DutyLevel;
               _loc5_.LastWeekRichesOffer = parseInt(_loc3_[_loc4_].@LastWeekRichesOffer);
               _loc5_.commitChanges();
               this.consortionMember.add(_loc5_.ID,_loc5_);
               if(_loc5_.ID == PlayerManager.Instance.Self.ID)
               {
                  PlayerManager.Instance.Self.ConsortiaID = _loc5_.ConsortiaID;
                  PlayerManager.Instance.Self.DutyLevel = _loc5_.DutyLevel;
                  PlayerManager.Instance.Self.DutyName = _loc5_.DutyName;
                  PlayerManager.Instance.Self.Right = _loc5_.Right;
               }
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
      
      private function converBoolean(param1:String) : Boolean
      {
         return param1 == "true" ? Boolean(Boolean(true)) : Boolean(Boolean(false));
      }
   }
}
