package guildMemberWeek.view.addRankingFrame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import guildMemberWeek.items.AddRankingWorkItem;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class GuildMemberWeekAddRankingFrame extends BaseAlerFrame
   {
       
      
      private var _PlayerPointBookText:FilterFrameText;
      
      private var _DeductTaxExplainText:FilterFrameText;
      
      private var _BG:ScaleFrameImage;
      
      private var _DeductTaxExplainBG:ScaleFrameImage;
      
      private var _PlayerHavePointBG:ScaleFrameImage;
      
      private var _RankingText:FilterFrameText;
      
      private var _PutInPointBookExplainText:FilterFrameText;
      
      private var _GetPointBookExplainText:FilterFrameText;
      
      private var _YesBtn:TextButton;
      
      private var _NoBtn:TextButton;
      
      private var _itemList:Vector.<AddRankingWorkItem>;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      public function GuildMemberWeekAddRankingFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initText();
      }
      
      public function get itemList() : Vector.<AddRankingWorkItem>
      {
         return this._itemList;
      }
      
      public function set itemList(param1:Vector.<AddRankingWorkItem>) : void
      {
         this._itemList = param1;
      }
      
      private function initView() : void
      {
         var _loc2_:AddRankingWorkItem = null;
         titleText = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.AddRankingGiftLabel");
         this._BG = ComponentFactory.Instance.creat("asset.guildmemberweek.AddRankingFrameBG");
         this._DeductTaxExplainBG = ComponentFactory.Instance.creat("asset.guildmemberweek.AddRankingFrameExplainBG");
         this._PlayerHavePointBG = ComponentFactory.Instance.creat("asset.guildmemberweek.AddRankingFramePlayerPoint");
         this._YesBtn = ComponentFactory.Instance.creat("ddtstore.HelpFrame.EnterBtn");
         this._YesBtn.text = LanguageMgr.GetTranslation("ok");
         this._YesBtn.x = 50;
         this._YesBtn.y = 300;
         this._NoBtn = ComponentFactory.Instance.creat("ddtstore.HelpFrame.EnterBtn");
         this._NoBtn.text = LanguageMgr.GetTranslation("cancel");
         this._NoBtn.x = 270;
         this._NoBtn.y = 300;
         this._PlayerPointBookText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.PlayerPointBookTxt");
         this._DeductTaxExplainText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.DeductTaxExplainTxt");
         this._PutInPointBookExplainText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.PutInPointBookExplainLabelTxt");
         this._GetPointBookExplainText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.GetPointBookExplainLabelTxt");
         this._RankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.RankingLabelTxt");
         addToContent(this._BG);
         addToContent(this._DeductTaxExplainBG);
         addToContent(this._PlayerHavePointBG);
         addToContent(this._YesBtn);
         addToContent(this._NoBtn);
         addToContent(this._PlayerPointBookText);
         addToContent(this._DeductTaxExplainText);
         addToContent(this._RankingText);
         addToContent(this._PutInPointBookExplainText);
         addToContent(this._GetPointBookExplainText);
         this._list = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingListBox");
         this._itemList = new Vector.<AddRankingWorkItem>();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("guildmemberweek.addRanking.AddRankingWorkItem");
            _loc2_.initView(_loc1_ + 1);
            this.itemList.push(_loc2_);
            this._list.addChild(this.itemList[_loc1_]);
            _loc1_++;
         }
         this._panel = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.panel");
         this._panel.setView(this._list);
         addToContent(this._panel);
         this._panel.invalidateViewport();
      }
      
      private function initText() : void
      {
         this.ChangePlayerMoneyShow(PlayerManager.Instance.Self.Money);
         this._RankingText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.RankingLabel");
         this._DeductTaxExplainText.text = LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.DeductTaxExplain");
         this._PutInPointBookExplainText.text = LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.PutInPointBookExplainLabel");
         this._GetPointBookExplainText.text = LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.GetPointBookExplainLabel");
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._NoBtn.addEventListener(MouseEvent.CLICK,this.__CancelHandler);
         this._YesBtn.addEventListener(MouseEvent.CLICK,this.__OkHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._NoBtn.removeEventListener(MouseEvent.CLICK,this.__CancelHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.CancelThis();
         }
      }
      
      private function __CancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.CancelThis();
      }
      
      private function CancelThis() : void
      {
         SoundManager.instance.play("008");
         GuildMemberWeekManager.instance.CloseAddRankingFrame();
      }
      
      private function __OkHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.DutyLevel > 3 || !GuildMemberWeekManager.instance.model.CanAddPointBook)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.CantNotAddPointBook"));
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:int = this._itemList.length;
         var _loc4_:Array = new Array();
         while(_loc2_ < _loc3_)
         {
            _loc4_.push(this.itemList[_loc2_].AddMoney);
            _loc2_++;
         }
         GuildMemberWeekManager.instance.model.PlayerAddPointBook = _loc4_.concat();
         GuildMemberWeekManager.instance.Controller.CheckAddBookIsOK();
      }
      
      public function ChangePointBookShow(param1:int, param2:int) : void
      {
         var _loc3_:int = param1 - 1;
         this.itemList[_loc3_].ChangeGetPointBook(param2);
      }
      
      public function ChangePlayerMoneyShow(param1:Number) : void
      {
         this._PlayerPointBookText.text = String(param1);
      }
      
      private function disposeItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.itemList)
         {
            _loc1_ = 0;
            _loc2_ = this.itemList.length;
            while(_loc1_ < _loc2_)
            {
               ObjectUtils.disposeObject(this.itemList[_loc1_]);
               this.itemList[_loc1_] = null;
               _loc1_++;
            }
            this.itemList = null;
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.disposeItems();
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeAllChildren(this._panel);
         ObjectUtils.disposeAllChildren(this._list);
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         super.dispose();
         this._BG = null;
         this._DeductTaxExplainBG = null;
         this._PlayerHavePointBG = null;
         this._panel = null;
         this._YesBtn = null;
         this._NoBtn = null;
         this._PlayerPointBookText = null;
         this._DeductTaxExplainText = null;
         this._RankingText = null;
         this._PutInPointBookExplainText = null;
         this._GetPointBookExplainText = null;
      }
   }
}
