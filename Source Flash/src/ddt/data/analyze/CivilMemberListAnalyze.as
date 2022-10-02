package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.player.CivilPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   
   public class CivilMemberListAnalyze extends DataAnalyzer
   {
      
      public static const PATH:String = "MarryInfoPageList.ashx";
       
      
      public var civilMemberList:Array;
      
      public var _page:int;
      
      public var _name:String;
      
      public var _sex:Boolean;
      
      public var _totalPage:int;
      
      public function CivilMemberListAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc5_:PlayerInfo = null;
         _loc3_ = null;
         var _loc4_:int = 0;
         _loc5_ = null;
         var _loc6_:CivilPlayerInfo = null;
         this.civilMemberList = [];
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Info;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new PlayerInfo();
               _loc5_.beginChanges();
               _loc5_.ID = _loc3_[_loc4_].@UserID;
               _loc5_.NickName = _loc3_[_loc4_].@NickName;
               _loc5_.ConsortiaID = _loc3_[_loc4_].@ConsortiaID;
               _loc5_.ConsortiaName = _loc3_[_loc4_].@ConsortiaName;
               _loc5_.Sex = this.converBoolean(_loc3_[_loc4_].@Sex);
               _loc5_.WinCount = _loc3_[_loc4_].@Win;
               _loc5_.TotalCount = _loc3_[_loc4_].@Total;
               _loc5_.EscapeCount = _loc3_[_loc4_].@Escape;
               _loc5_.GP = _loc3_[_loc4_].@GP;
               _loc5_.Style = _loc3_[_loc4_].@Style;
               _loc5_.Colors = _loc3_[_loc4_].@Colors;
               _loc5_.Hide = _loc3_[_loc4_].@Hide;
               _loc5_.Grade = _loc3_[_loc4_].@Grade;
               _loc5_.playerState = new PlayerState(int(_loc3_[_loc4_].@State));
               _loc5_.Repute = _loc3_[_loc4_].@Repute;
               _loc5_.Skin = _loc3_[_loc4_].@Skin;
               _loc5_.Offer = _loc3_[_loc4_].@Offer;
               _loc5_.IsMarried = this.converBoolean(_loc3_[_loc4_].@IsMarried);
               _loc5_.Nimbus = int(_loc3_[_loc4_].@Nimbus);
               _loc5_.DutyName = _loc3_[_loc4_].@DutyName;
               _loc5_.FightPower = _loc3_[_loc4_].@FightPower;
               _loc5_.AchievementPoint = _loc3_[_loc4_].@AchievementPoint;
               _loc5_.honor = _loc3_[_loc4_].@Rank;
               _loc5_.typeVIP = _loc3_[_loc4_].@typeVIP;
               _loc5_.VIPLevel = _loc3_[_loc4_].@VIPLevel;
               _loc6_ = new CivilPlayerInfo();
               _loc6_.UserId = _loc5_.ID;
               _loc6_.MarryInfoID = _loc3_[_loc4_].@ID;
               _loc6_.IsPublishEquip = this.converBoolean(_loc3_[_loc4_].@IsPublishEquip);
               _loc6_.Introduction = _loc3_[_loc4_].@Introduction;
               _loc6_.IsConsortia = this.converBoolean(_loc3_[_loc4_].@IsConsortia);
               _loc6_.info = _loc5_;
               this.civilMemberList.push(_loc6_);
               _loc5_.commitChanges();
               _loc4_++;
            }
            this._totalPage = Math.ceil(int(_loc2_.@total) / 12);
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
         if(param1 == "true")
         {
            return true;
         }
         return false;
      }
   }
}
