package ddt.data.player
{
   import consortion.ConsortionModelControl;
   import ddt.manager.PlayerManager;
   import ddt.view.character.Direction;
   import road7th.utils.DateUtils;
   
   public class ConsortiaPlayerInfo extends BasePlayer
   {
       
      
      public var PosX:int = 300;
      
      public var PosY:int = 300;
      
      public var Direct:Direction;
      
      public var privateID:int;
      
      public var DutyID:int;
      
      public var IsChat:Boolean;
      
      public var IsDiplomatism:Boolean;
      
      public var IsDownGrade:Boolean;
      
      public var IsEditorDescription:Boolean;
      
      public var IsEditorPlacard:Boolean;
      
      public var IsEditorUser:Boolean;
      
      public var IsExpel:Boolean;
      
      public var IsInvite:Boolean;
      
      public var IsManageDuty:Boolean;
      
      public var IsRatify:Boolean;
      
      public var RatifierID:int;
      
      public var RatifierName:String;
      
      public var Remark:String;
      
      private var _IsVote:Boolean;
      
      public var LastWeekRichesOffer:int;
      
      public var IsBandChat:Boolean;
      
      public var LastDate:String;
      
      public var isSelected:Boolean;
      
      public var minute:int;
      
      public var day:int;
      
      public function ConsortiaPlayerInfo()
      {
         this.Direct = Direction.getDirectionFromAngle(2);
         super();
      }
      
      public function get IsVote() : Boolean
      {
         return this._IsVote;
      }
      
      public function set IsVote(param1:Boolean) : void
      {
         this._IsVote = param1;
      }
      
      public function get OffLineHour() : int
      {
         if(NickName == PlayerManager.Instance.Self.NickName || playerState.StateID != PlayerState.OFFLINE)
         {
            return -2;
         }
         var _loc1_:int = 0;
         var _loc2_:Date = DateUtils.dealWithStringDate(this.LastDate);
         var _loc3_:Date = DateUtils.dealWithStringDate(ConsortionModelControl.Instance.model.systemDate);
         var _loc4_:Number = (_loc3_.valueOf() - _loc2_.valueOf()) / 3600000;
         _loc1_ = _loc4_ < 1 ? int(int(-1)) : int(int(Math.floor(_loc4_)));
         if(_loc4_ < 1)
         {
            this.minute = _loc4_ * 60;
            if(this.minute <= 0)
            {
               this.minute = 1;
            }
         }
         if(_loc4_ > 24 && _loc4_ < 720)
         {
            this.day = Math.floor(_loc4_ / 24);
         }
         return _loc1_;
      }
   }
}
