package guildMemberWeek.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import guildMemberWeek.view.mainFrame.GuildMemberWeekFrameLeft;
   import guildMemberWeek.view.mainFrame.GuildMemberWeekFrameRight;
   
   public class GuildMemberWeekFrame extends Frame
   {
       
      
      private var _helpBtn:BaseButton;
      
      private var _AddRankingBtn:BaseButton;
      
      private var _AddRankingSprite:Sprite;
      
      private var _AddRankingBg:Bitmap;
      
      private var _AddRankingReadyShow:DisplayObject;
      
      private var _runkingBG:ScaleFrameImage;
      
      private var _runkingSG:ScaleFrameImage;
      
      private var _AddRecordBG:ScaleFrameImage;
      
      private var _TenMBG:ScaleFrameImage;
      
      private var _panel:ScrollPanel;
      
      private var _upDataTimeTxt:FilterFrameText;
      
      private var _upExplainText:FilterFrameText;
      
      private var _dataTitleRankingText:FilterFrameText;
      
      private var _dataTitleNameText:FilterFrameText;
      
      private var _dataTitleContributeText:FilterFrameText;
      
      private var _dataTitleRankingGiftText:FilterFrameText;
      
      private var _dataTitleAddRankingGiftText:FilterFrameText;
      
      private var _ActivityStartTimeShowText:FilterFrameText;
      
      private var _ActivityEndTimeShowText:FilterFrameText;
      
      private var _ShowMyRankingText:FilterFrameText;
      
      private var _ShowMyContributeText:FilterFrameText;
      
      private var _AddRanking:GuildMemberWeekFrameRight;
      
      private var _TopTenShowSprite:GuildMemberWeekFrameLeft;
      
      private var _selfInfo:SelfInfo;
      
      public function GuildMemberWeekFrame()
      {
         this._selfInfo = PlayerManager.Instance.Self;
         super();
         this.initView();
         this.initEvent();
         this.initText();
      }
      
      public function get TopTenShowSprite() : GuildMemberWeekFrameLeft
      {
         return this._TopTenShowSprite;
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("guildMemberWeek.MainFrame.guildMemberWeek.title");
         this._runkingBG = ComponentFactory.Instance.creat("asset.guildmemberweek.MainrunkingBG.png");
         this._runkingSG = ComponentFactory.Instance.creat("asset.guildmemberweek.MainrunkingSG.png");
         this._AddRecordBG = ComponentFactory.Instance.creat("asset.guildmemberweek.MainRecordBG.png");
         this._TenMBG = ComponentFactory.Instance.creat("asset.guildmemberweek.MainTenMBG.png");
         this._AddRanking = ComponentFactory.Instance.creatCustomObject("guildmemberweek.MainFrame.GuildMemberWeekFrameRight");
         this._TopTenShowSprite = ComponentFactory.Instance.creatCustomObject("guildmemberweek.MainFrame.GuildMemberWeekFrameLeft");
         this._helpBtn = ComponentFactory.Instance.creat("guildmemberweek.help.btn");
         this._AddRankingBg = ComponentFactory.Instance.creatBitmap("asset.guildmemberweek.Main.AddPointBookText.png");
         this._AddRankingReadyShow = ComponentFactory.Instance.creat("asset.guildmemberweek.Main.AddPointBookBtnCartoon.png");
         this._AddRankingReadyShow.x = -10;
         this._AddRankingReadyShow.y = -16;
         if(PlayerManager.Instance.Self.DutyLevel <= 3)
         {
            this._AddRankingReadyShow.visible = true;
         }
         else
         {
            this._AddRankingReadyShow.visible = false;
         }
         this._AddRankingSprite = new Sprite();
         this._AddRankingSprite.addChild(this._AddRankingBg);
         this._AddRankingSprite.addChild(this._AddRankingReadyShow);
         this._AddRankingBtn = GuildMemberWeekManager.instance.returnComponentBnt(this._AddRankingSprite,false);
         this._AddRankingBtn.x = 420;
         this._AddRankingBtn.y = 410;
         this._upDataTimeTxt = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.upDataTimeTxt");
         this._upExplainText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.upExplainTxt");
         this._ActivityStartTimeShowText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.activityStartTimeTxt");
         this._ActivityEndTimeShowText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.activityEndTimeTxt");
         this._dataTitleRankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.dataTitleRankingTxt");
         this._dataTitleNameText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.dataTitleNameTxt");
         this._dataTitleContributeText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.dataTitleContributeTxt");
         this._dataTitleRankingGiftText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.dataTitleRankingGiftTxt");
         this._dataTitleAddRankingGiftText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.dataTitleAddRankingGiftTxt");
         this._ShowMyRankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.ShowMyRankingTxt");
         this._ShowMyContributeText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.ShowMyContributeTxt");
         addToContent(this._runkingBG);
         addToContent(this._runkingSG);
         addToContent(this._AddRecordBG);
         addToContent(this._TenMBG);
         addToContent(this._AddRanking);
         addToContent(this._TopTenShowSprite);
         addToContent(this._helpBtn);
         addToContent(this._AddRankingBtn);
         addToContent(this._upDataTimeTxt);
         addToContent(this._upExplainText);
         addToContent(this._ActivityStartTimeShowText);
         addToContent(this._ActivityEndTimeShowText);
         addToContent(this._dataTitleRankingText);
         addToContent(this._dataTitleNameText);
         addToContent(this._dataTitleContributeText);
         addToContent(this._dataTitleRankingGiftText);
         addToContent(this._dataTitleAddRankingGiftText);
         addToContent(this._ShowMyRankingText);
         addToContent(this._ShowMyContributeText);
      }
      
      public function upDataTimeTxt() : void
      {
         if(GuildMemberWeekManager.instance.model.upData != "no record...")
         {
            this._upDataTimeTxt.text = LanguageMgr.GetTranslation("guildMemberWeek.MainFrame.upData") + "  " + GuildMemberWeekManager.instance.model.upData;
         }
         else
         {
            this._upDataTimeTxt.text = "";
         }
      }
      
      private function initText() : void
      {
         this.upDataTimeTxt();
         this._upExplainText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainFrame.upExplain");
         this._dataTitleRankingText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.RankingLabel");
         this._dataTitleNameText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.NameLabel");
         this._dataTitleContributeText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.ContributeLabel");
         this._dataTitleRankingGiftText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.RankingGiftLabel");
         this._dataTitleAddRankingGiftText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.AddRankingGiftLabel");
         this._ActivityStartTimeShowText.text = LanguageMgr.GetTranslation("guildMemberWeek.ActivityStartTimeShow") + GuildMemberWeekManager.instance.model.ActivityStartTime;
         this._ActivityEndTimeShowText.text = LanguageMgr.GetTranslation("guildMemberWeek.ActivityEndTimeShow") + GuildMemberWeekManager.instance.model.ActivityEndTime;
         this.UpMyRanking();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onClickHelpHandler);
         this._AddRankingBtn.addEventListener(MouseEvent.CLICK,this.__onClickAddRankingHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(this._helpBtn)
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onClickHelpHandler);
         }
         if(this._AddRankingBtn)
         {
            this._AddRankingBtn.removeEventListener(MouseEvent.CLICK,this.__onClickAddRankingHandler);
         }
      }
      
      private function __onClickHelpHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("guildmemberweek.HelpPrompt");
         var _loc3_:GuildMemberWeekHelpFrame = ComponentFactory.Instance.creat("guildmemberweek.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("guildMemberWeek.MainFrame.guildMemberWeek.readme");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onClickAddRankingHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < 100)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         GuildMemberWeekManager.instance.doOpenaddRankingFrame();
      }
      
      public function UpMyRanking() : void
      {
         this._ShowMyRankingText.text = String(GuildMemberWeekManager.instance.model.MyRanking);
         this._ShowMyContributeText.text = String(GuildMemberWeekManager.instance.model.MyContribute);
      }
      
      public function ClearRecord() : void
      {
         this._AddRanking.ClearRecord();
      }
      
      public function UpRecord() : void
      {
         this._AddRanking.UpRecord();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            GuildMemberWeekManager.instance.disposeAllFrame();
         }
      }
      
      override public function dispose() : void
      {
         if(GuildMemberWeekManager.instance.model)
         {
            GuildMemberWeekManager.instance.model.PlayerAddPointBook = [0,0,0,0,0,0,0,0,0,0];
         }
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeAllChildren(this._AddRankingBtn);
         ObjectUtils.disposeObject(this._AddRankingBtn);
         this._AddRankingBtn = null;
         this._AddRankingReadyShow.visible = true;
         if(this._AddRankingSprite)
         {
            ObjectUtils.disposeAllChildren(this._AddRankingSprite);
         }
         this._AddRankingSprite = null;
         this._AddRankingBg = null;
         this._AddRankingReadyShow = null;
         super.dispose();
         this._runkingBG = null;
         this._runkingSG = null;
         this._AddRecordBG = null;
         this._TenMBG = null;
         this._helpBtn = null;
         this._upDataTimeTxt = null;
         this._upExplainText = null;
         this._ActivityStartTimeShowText = null;
         this._ActivityEndTimeShowText = null;
         this._dataTitleRankingText = null;
         this._dataTitleNameText = null;
         this._dataTitleContributeText = null;
         this._dataTitleRankingGiftText = null;
         this._dataTitleAddRankingGiftText = null;
         this._ShowMyRankingText = null;
         this._ShowMyContributeText = null;
         if(this._AddRanking)
         {
            ObjectUtils.disposeAllChildren(this._AddRanking);
         }
         this._AddRanking = null;
         if(this._TopTenShowSprite)
         {
            ObjectUtils.disposeAllChildren(this._TopTenShowSprite);
         }
         this._TopTenShowSprite = null;
      }
   }
}
