package guildMemberWeek.view.ShowRankingFrame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.geom.Point;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import guildMemberWeek.view.mainFrame.GuildMemberWeekFrameLeft;
   
   public class GuildMemberWeekShowRankingFrame extends BaseAlerFrame
   {
       
      
      private var _runkingBG:ScaleFrameImage;
      
      private var _runkingSG:ScaleFrameImage;
      
      private var _dataTitleRankingText:FilterFrameText;
      
      private var _dataTitleNameText:FilterFrameText;
      
      private var _dataTitleContributeText:FilterFrameText;
      
      private var _dataTitleRankingGiftText:FilterFrameText;
      
      private var _dataTitleAddRankingGiftText:FilterFrameText;
      
      private var _ShowMyRankingText:FilterFrameText;
      
      private var _ShowMyContributeText:FilterFrameText;
      
      private var _TopTenShowSprite:GuildMemberWeekFrameLeft;
      
      public function GuildMemberWeekShowRankingFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initText();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         titleText = LanguageMgr.GetTranslation("guildMemberWeek.MainFrame.guildMemberWeek.title");
         this._runkingBG = ComponentFactory.Instance.creat("asset.guildmemberweek.MainrunkingBG.png");
         this._runkingSG = ComponentFactory.Instance.creat("asset.guildmemberweek.MainrunkingSG.png");
         this._runkingSG.y = 415;
         this._runkingSG.x = 100;
         this._TopTenShowSprite = ComponentFactory.Instance.creatCustomObject("guildmemberweek.MainFrame.GuildMemberWeekFrameLeft");
         this._dataTitleRankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.dataTitleRankingTxt");
         this._dataTitleNameText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.dataTitleNameTxt");
         this._dataTitleContributeText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.dataTitleContributeTxt");
         this._dataTitleRankingGiftText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.dataTitleRankingGiftTxt");
         this._dataTitleAddRankingGiftText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.dataTitleAddRankingGiftTxt");
         this._ShowMyRankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.ShowMyRankingTxt");
         this._ShowMyContributeText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.ShowMyContributeTxt");
         this._TopTenShowSprite.y = 53;
         _loc1_ = 12;
         this._dataTitleRankingText.y = _loc1_;
         this._dataTitleNameText.y = _loc1_;
         this._dataTitleContributeText.y = _loc1_;
         this._dataTitleRankingGiftText.y = _loc1_;
         this._dataTitleAddRankingGiftText.y = _loc1_;
         var _loc2_:Point = PositionUtils.creatPoint("guildMemberWeek.ShowRankingPos");
         _loc1_ = _loc2_.y;
         _loc3_ = _loc2_.x;
         this._ShowMyRankingText.x += _loc3_;
         this._ShowMyRankingText.y = _loc1_;
         this._ShowMyContributeText.x += _loc3_;
         this._ShowMyContributeText.y = _loc1_;
         addToContent(this._runkingBG);
         addToContent(this._runkingSG);
         addToContent(this._dataTitleRankingText);
         addToContent(this._dataTitleNameText);
         addToContent(this._dataTitleContributeText);
         addToContent(this._dataTitleRankingGiftText);
         addToContent(this._dataTitleAddRankingGiftText);
         addToContent(this._ShowMyRankingText);
         addToContent(this._ShowMyContributeText);
         addToContent(this._TopTenShowSprite);
      }
      
      private function initText() : void
      {
         this._dataTitleRankingText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.RankingLabel");
         this._dataTitleNameText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.NameLabel");
         this._dataTitleContributeText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.ContributeLabel");
         this._dataTitleRankingGiftText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.RankingGiftLabel");
         this._dataTitleAddRankingGiftText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.AddRankingGiftLabel");
         this.UpMyRanking();
         this._TopTenShowSprite.UpTop10data("Member");
         this._TopTenShowSprite.UpTop10data("PointBook");
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            GuildMemberWeekManager.instance.disposeAllFrame(true);
         }
      }
      
      public function UpMyRanking() : void
      {
         this._ShowMyRankingText.text = String(GuildMemberWeekManager.instance.model.MyRanking);
         this._ShowMyContributeText.text = String(GuildMemberWeekManager.instance.model.MyContribute);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         this._runkingBG = null;
         this._runkingSG = null;
         this._dataTitleRankingText = null;
         this._dataTitleNameText = null;
         this._dataTitleContributeText = null;
         this._dataTitleRankingGiftText = null;
         this._dataTitleAddRankingGiftText = null;
         this._ShowMyRankingText = null;
         this._ShowMyContributeText = null;
         if(this._TopTenShowSprite)
         {
            ObjectUtils.disposeAllChildren(this._TopTenShowSprite);
         }
         this._TopTenShowSprite = null;
      }
   }
}
