package guildMemberWeek.controller
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import road7th.comm.PackageIn;
   
   public class GuildMemberWeekController
   {
      
      private static var _instance:GuildMemberWeekController;
       
      
      public function GuildMemberWeekController(param1:PrivateClass)
      {
         super();
         if(param1 == null)
         {
            throw new Error("错误：GuildMemberWeekController类属于单例，请使用本类的istance获取实例");
         }
         this.initEvent();
      }
      
      public static function get instance() : GuildMemberWeekController
      {
         if(!_instance)
         {
            _instance = new GuildMemberWeekController(new PrivateClass());
         }
         return _instance;
      }
      
      public function initEvent() : void
      {
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_FINISHACTIVITY,this.__ShowFinishFrame);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_SHOWRUNKING,this.__ShowRankingFrame);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_MYRUNKING,this.__UpMyRanking);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_PLAYERTOP10,this.__UpTop10Data);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_POINTBOOK,this.__UpAddPointBook);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_ADDPOINTBOOKRECORD,this._UpAddPointRecord);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_UPADDPOINTBOOK,this._UpImmediatelyRecord);
         GuildMemberWeekManager.instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_SHOWACTIVITYEND,this.__activityEndShowRanking);
      }
      
      public function removeEvent() : void
      {
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_FINISHACTIVITY,this.__ShowFinishFrame);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_SHOWRUNKING,this.__ShowRankingFrame);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_MYRUNKING,this.__UpMyRanking);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_PLAYERTOP10,this.__UpTop10Data);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_POINTBOOK,this.__UpAddPointBook);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_ADDPOINTBOOKRECORD,this._UpAddPointRecord);
         GuildMemberWeekManager.instance.removeEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_SHOWACTIVITYEND,this.__activityEndShowRanking);
      }
      
      private function __ShowFinishFrame(param1:CrazyTankSocketEvent) : void
      {
         GuildMemberWeekManager.instance.LoadAndOpenShowTop10PromptFrame();
      }
      
      private function __ShowRankingFrame(param1:CrazyTankSocketEvent) : void
      {
         GuildMemberWeekManager.instance.LoadAndOpenGuildMemberWeekFinishActivity();
      }
      
      private function __UpTop10Data(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:String = _loc2_.readUTF();
         GuildMemberWeekManager.instance.model.upData = _loc3_;
         var _loc4_:int = _loc2_.readInt();
         if(GuildMemberWeekManager.instance.model)
         {
            GuildMemberWeekManager.instance.model.TopTenMemberData.splice(0);
         }
         if(GuildMemberWeekManager.instance.MainFrame)
         {
            GuildMemberWeekManager.instance.MainFrame.upDataTimeTxt();
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_.readInt();
            _loc7_ = _loc2_.readUTF();
            _loc8_ = _loc2_.readInt();
            _loc9_ = _loc2_.readInt();
            GuildMemberWeekManager.instance.model.TopTenMemberData.push([_loc6_,_loc7_,_loc8_,_loc9_]);
            _loc5_++;
         }
         this.UpTop10Data("Member");
      }
      
      private function __UpAddPointBook(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         GuildMemberWeekManager.instance.model.TopTenAddPointBook.splice(0);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            GuildMemberWeekManager.instance.model.TopTenAddPointBook.push(_loc5_);
            _loc4_++;
         }
         this.UpTop10Data("PointBook");
      }
      
      private function __activityEndShowRanking(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         GuildMemberWeekManager.instance.model.TopTenMemberData.splice(0);
         GuildMemberWeekManager.instance.model.TopTenAddPointBook.splice(0);
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc10_:PackageIn = param1.pkg;
         var _loc11_:String = _loc10_.readUTF();
         GuildMemberWeekManager.instance.model.upData = _loc11_;
         if(GuildMemberWeekManager.instance.MainFrame)
         {
            GuildMemberWeekManager.instance.MainFrame.upDataTimeTxt();
         }
         _loc4_ = _loc10_.readInt();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc10_.readInt();
            _loc6_ = _loc10_.readUTF();
            _loc7_ = _loc10_.readInt();
            _loc8_ = _loc10_.readInt();
            GuildMemberWeekManager.instance.model.TopTenMemberData.push([_loc5_,_loc6_,_loc7_,_loc8_]);
            if(PlayerManager.Instance.Self.ID == _loc5_)
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         _loc4_ = _loc10_.readInt();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc9_ = _loc10_.readInt();
            GuildMemberWeekManager.instance.model.TopTenAddPointBook.push(_loc9_);
            _loc3_++;
         }
         GuildMemberWeekManager.instance.model.MyRanking = _loc10_.readInt();
         GuildMemberWeekManager.instance.model.MyContribute = _loc10_.readInt();
         this.UpTop10Data("Member");
         this.UpTop10Data("PointBook");
         this.UpTop10Data("Gift");
         if(GuildMemberWeekManager.instance.MainFrame)
         {
            GuildMemberWeekManager.instance.MainFrame.UpMyRanking();
         }
         if(GuildMemberWeekManager.instance.FinishActivityFrame)
         {
            GuildMemberWeekManager.instance.FinishActivityFrame.UpMyRanking();
         }
         if(_loc2_)
         {
            if(GuildMemberWeekManager.instance.model.MyRanking <= 0 || GuildMemberWeekManager.instance.model.MyRanking > 10)
            {
               _loc2_ = false;
            }
         }
         GuildMemberWeekManager.instance.CheckShowEndFrame(_loc2_);
      }
      
      public function _UpAddPointRecord(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:String = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readUTF();
            GuildMemberWeekManager.instance.model.AddRanking.push(_loc5_);
            _loc4_++;
         }
         if(GuildMemberWeekManager.instance.MainFrame != null)
         {
            GuildMemberWeekManager.instance.MainFrame.UpRecord();
         }
      }
      
      public function _UpImmediatelyRecord(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt() - 1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:String = _loc2_.readUTF();
         GuildMemberWeekManager.instance.model.TopTenAddPointBook[_loc3_] += _loc4_;
         GuildMemberWeekManager.instance.model.AddRanking.push(_loc5_);
         if(GuildMemberWeekManager.instance.MainFrame != null)
         {
            GuildMemberWeekManager.instance.MainFrame.UpRecord();
            this.UpTop10Data("PointBook");
         }
      }
      
      public function __UpMyRanking(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         GuildMemberWeekManager.instance.model.MyRanking = _loc2_.readInt();
         GuildMemberWeekManager.instance.model.MyContribute = _loc2_.readInt();
         if(GuildMemberWeekManager.instance.MainFrame != null)
         {
            GuildMemberWeekManager.instance.MainFrame.UpMyRanking();
         }
         if(GuildMemberWeekManager.instance.FinishActivityFrame != null)
         {
            GuildMemberWeekManager.instance.FinishActivityFrame.UpMyRanking();
         }
      }
      
      private function UpTop10Data(param1:String) : void
      {
         if(GuildMemberWeekManager.instance.MainFrame != null)
         {
            if(GuildMemberWeekManager.instance.MainFrame.TopTenShowSprite != null)
            {
               GuildMemberWeekManager.instance.MainFrame.TopTenShowSprite.UpTop10data(param1);
            }
         }
      }
      
      public function CheckAddBookIsOK() : void
      {
         var _loc1_:Boolean = true;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = GuildMemberWeekManager.instance.model.PlayerAddPointBook.length;
         var _loc6_:Array = new Array();
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = GuildMemberWeekManager.instance.model.PlayerAddPointBook[_loc3_];
            _loc6_.push(_loc4_);
            if(_loc4_ >= 10)
            {
               _loc2_ = true;
            }
            else if(_loc4_ > 0 && _loc4_ < 10)
            {
               _loc1_ = false;
               break;
            }
            _loc3_++;
         }
         if(_loc1_)
         {
            if(_loc2_)
            {
               SocketManager.Instance.out.sendGuildMemberWeekAddRanking(_loc6_.concat());
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.AddOKPointBook"));
               GuildMemberWeekManager.instance.model.PlayerAddPointBook = [0,0,0,0,0,0,0,0,0,0];
               GuildMemberWeekManager.instance.CloseAddRankingFrame();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.AddNoPointBook"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.AddPointBookMustUp100"));
         }
      }
      
      public function upPointBookData(param1:int, param2:Number, param3:Boolean = true) : void
      {
         var _loc4_:int = param1 - 1;
         var _loc5_:Number = param2 / 10;
         var _loc6_:int = 0;
         if(String(_loc5_).indexOf(".") >= 0)
         {
            _loc5_ = Math.round(_loc5_);
            _loc6_ = param2 - _loc5_;
         }
         else
         {
            _loc6_ = param2 - int(_loc5_);
         }
         GuildMemberWeekManager.instance.model.PlayerAddPointBook[_loc4_] = param2;
         GuildMemberWeekManager.instance.AddRankingFrame.ChangePointBookShow(param1,_loc6_);
         if(param3)
         {
            this.ChangePlayerMoney();
         }
      }
      
      public function ChangePlayerMoney() : void
      {
         var _loc1_:Number = 0;
         var _loc2_:int = GuildMemberWeekManager.instance.model.PlayerAddPointBook.length;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ += GuildMemberWeekManager.instance.model.PlayerAddPointBook[_loc3_];
            _loc3_++;
         }
         if(_loc1_ > PlayerManager.Instance.Self.Money)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = GuildMemberWeekManager.instance.model.PlayerAddPointBookBefor[_loc3_];
               GuildMemberWeekManager.instance.model.PlayerAddPointBook[_loc3_] = _loc4_;
               this.upPointBookData(_loc3_ + 1,_loc4_,false);
               _loc3_++;
            }
         }
         else
         {
            _loc1_ = PlayerManager.Instance.Self.Money - _loc1_;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = GuildMemberWeekManager.instance.model.PlayerAddPointBook[_loc3_];
               GuildMemberWeekManager.instance.model.PlayerAddPointBookBefor[_loc3_] = _loc4_;
               _loc3_++;
            }
            GuildMemberWeekManager.instance.AddRankingFrame.ChangePlayerMoneyShow(_loc1_);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
      }
   }
}

class PrivateClass
{
    
   
   function PrivateClass()
   {
      super();
   }
}
