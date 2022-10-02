package newTitle.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.EffortEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import hall.event.NewHallEvent;
   import newTitle.NewTitleControl;
   import newTitle.NewTitleManager;
   import newTitle.event.NewTitleEvent;
   import newTitle.model.NewTitleModel;
   
   public class NewTitleFrame extends Frame
   {
       
      
      private var _titleBg:Bitmap;
      
      private var _currentTitle:Bitmap;
      
      private var _titleSprite:Sprite;
      
      private var _titleTxt:FilterFrameText;
      
      private var _hideBtn:SelectedCheckButton;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _hasTitleBtn:SelectedTextButton;
      
      private var _allTitleBtn:SelectedTextButton;
      
      private var _titleList:NewTitleListView;
      
      private var _titleBottomBg:MutipleImage;
      
      private var _titleListBg:ScaleBitmapImage;
      
      private var _titleProBg:MutipleImage;
      
      private var _useBtnBg:ScaleBitmapImage;
      
      private var _useBtn:SimpleBitmapButton;
      
      private var _propertyText:FilterFrameText;
      
      private var _oldTitleText:FilterFrameText;
      
      private var _selectTitle:NewTitleModel;
      
      public function NewTitleFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.updateTitleList();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("newTitleView.titleTxt");
         this._titleBg = ComponentFactory.Instance.creat("asset.newTitle.titleBg");
         addToContent(this._titleBg);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("newTitle.currentTitleTxt");
         this._titleTxt.text = LanguageMgr.GetTranslation("newTitleView.currentTitleTxt");
         addToContent(this._titleTxt);
         this._titleBottomBg = ComponentFactory.Instance.creatComponentByStylename("newTitle.titleBottomBg");
         addToContent(this._titleBottomBg);
         this._hasTitleBtn = ComponentFactory.Instance.creatComponentByStylename("newTitle.hasTitleBtn");
         this._hasTitleBtn.text = LanguageMgr.GetTranslation("newTitleView.hasTitleTxt");
         addToContent(this._hasTitleBtn);
         this._allTitleBtn = ComponentFactory.Instance.creatComponentByStylename("newTitle.allTitleBtn");
         this._allTitleBtn.text = LanguageMgr.GetTranslation("newTitleView.allTitleTxt");
         addToContent(this._allTitleBtn);
         this._hideBtn = ComponentFactory.Instance.creatComponentByStylename("newTitle.hideBtn");
         this._hideBtn.tipData = LanguageMgr.GetTranslation("newTitleView.hideBtnTipTxt");
         this._hideBtn.selected = !NewTitleManager.instance.ShowTitle;
         addToContent(this._hideBtn);
         this._titleListBg = ComponentFactory.Instance.creatComponentByStylename("newTitle.titleListBg");
         addToContent(this._titleListBg);
         this._titleProBg = ComponentFactory.Instance.creatComponentByStylename("newTitle.titleProBg");
         addToContent(this._titleProBg);
         this.creatTitleSprite();
         this._titleList = new NewTitleListView();
         PositionUtils.setPos(this._titleList,"newTitle.listPos");
         addToContent(this._titleList);
         this._propertyText = ComponentFactory.Instance.creatComponentByStylename("newTitle.propertyText");
         addToContent(this._propertyText);
         this._oldTitleText = ComponentFactory.Instance.creatComponentByStylename("newTitle.titleText");
         this.loadIcon(NewTitleManager.instance.titleInfo[PlayerManager.Instance.Self.honorId]);
         this._useBtnBg = ComponentFactory.Instance.creatComponentByStylename("newTitle.useBtnBG");
         addToContent(this._useBtnBg);
         this._useBtn = ComponentFactory.Instance.creatComponentByStylename("newTitle.useBtn");
         addToContent(this._useBtn);
         this._selectedButtonGroup = new SelectedButtonGroup();
         this._selectedButtonGroup.addSelectItem(this._hasTitleBtn);
         this._selectedButtonGroup.addSelectItem(this._allTitleBtn);
         this._selectedButtonGroup.selectIndex = 0;
      }
      
      private function creatTitleSprite() : void
      {
         this._titleSprite = new Sprite();
         this._titleSprite.graphics.beginFill(0,0);
         this._titleSprite.graphics.drawRect(0,0,this._titleProBg.width,70);
         this._titleSprite.graphics.endFill();
         addToContent(this._titleSprite);
         PositionUtils.setPos(this._titleSprite,this._titleProBg);
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__frameEventHandler);
         this._hideBtn.addEventListener("click",this.__onHideTitleClick);
         this._selectedButtonGroup.addEventListener("change",this.__onSelectChange);
         this._useBtn.addEventListener("click",this.__onUseClick);
         EffortManager.Instance.addEventListener("finish",this.__upadteTitle);
         NewTitleControl.instance.addEventListener("titleItemClick",this.__onItemClick);
         NewTitleManager.instance.addEventListener("setSelectTitle",this.__onSetSelectTitleForCurrent);
      }
      
      private function updateTitleList() : void
      {
         this._titleList.updateOwnTitleList();
      }
      
      public function __onSetSelectTitleForCurrent(param1:NewTitleEvent) : void
      {
         ObjectUtils.disposeObject(this._currentTitle);
         this._currentTitle = null;
         this.loadIcon(this._selectTitle);
      }
      
      protected function __onUseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectTitle)
         {
            ObjectUtils.disposeAllChildren(this._titleSprite);
            this.loadIcon(this._selectTitle);
            NewTitleManager.instance.dispatchEvent(new NewTitleEvent("selectTitle",[this._selectTitle.Name]));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newTitleView.selectTitleTxt"));
         }
      }
      
      protected function __onHideTitleClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         NewTitleManager.instance.ShowTitle = !this._hideBtn.selected;
         SocketManager.Instance.out.showHideTitleState(this._hideBtn.selected);
         if(this._hideBtn.selected)
         {
            PlayerManager.Instance.Self.IsShowNewTitle = false;
         }
         else
         {
            PlayerManager.Instance.Self.IsShowNewTitle = true;
         }
         SocketManager.Instance.dispatchEvent(new NewHallEvent("newhallupdatetitle"));
      }
      
      protected function __onItemClick(param1:NewTitleEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedButtonGroup.selectIndex == 0)
         {
            this._selectTitle = EffortManager.Instance.getHonorArray()[param1.data[0]];
            this._useBtn.enable = true;
         }
         else
         {
            this._selectTitle = NewTitleManager.instance.titleArray[param1.data[0]];
            this._useBtn.enable = this.isOwnTitle(this._selectTitle.Name);
         }
         this.setPropertyText();
         ObjectUtils.disposeAllChildren(this._titleSprite);
         this.loadIcon(this._selectTitle);
      }
      
      private function setPropertyText() : void
      {
         var _loc1_:String = "";
         this._propertyText.text = LanguageMgr.GetTranslation("newTitleView.propertyTxt",this._selectTitle.Att,this._selectTitle.Def,this._selectTitle.Agi,this._selectTitle.Luck,this._selectTitle.Valid,this._selectTitle.Desc);
         if(this._selectTitle.Valid <= 0)
         {
            _loc1_ = LanguageMgr.GetTranslation("newTitleView.hasnoTitleTxt");
         }
         else if(this._selectTitle.Valid > 1825)
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
         }
         if(_loc1_.length > 0)
         {
            this._propertyText.text = this._propertyText.text.replace(this._selectTitle.Valid + LanguageMgr.GetTranslation("day"),_loc1_);
         }
      }
      
      private function isOwnTitle(param1:String) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:Array = EffortManager.Instance.getHonorArray();
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1 == _loc3_[_loc4_].Name)
            {
               _loc2_ = true;
               break;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function loadIcon(param1:NewTitleModel) : void
      {
         var _loc2_:* = null;
         if(param1 && param1.Pic && param1.Pic != "0")
         {
            _loc2_ = LoaderManager.Instance.creatLoader(PathManager.solvePath("image/title/" + param1.Pic + "/icon.png"),0);
            _loc2_.addEventListener("complete",this.__onComplete);
            LoaderManager.Instance.startLoad(_loc2_,true);
         }
         else if(param1)
         {
            this._oldTitleText.text = param1.Name;
            this._oldTitleText.x = (this._titleSprite.width - this._oldTitleText.width) / 2;
            this._oldTitleText.y = (this._titleSprite.height - this._oldTitleText.height) / 2;
            this._titleSprite.addChild(this._oldTitleText);
         }
      }
      
      protected function __onComplete(param1:LoaderEvent) : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:BaseLoader = param1.loader;
         _loc3_.removeEventListener("complete",this.__onComplete);
         _loc2_ = _loc3_.content;
         if(_loc2_)
         {
            if(!this._currentTitle && PlayerManager.Instance.Self.honorId >= NewTitleManager.FIRST_TITLEID)
            {
               this._currentTitle = new Bitmap(_loc2_.bitmapData.clone());
               this._currentTitle.x = this._titleBg.x + (this._titleBg.width - this._currentTitle.width) / 2;
               this._currentTitle.y = this._titleBg.y + (this._titleBg.height - this._currentTitle.height) / 2;
               addToContent(this._currentTitle);
            }
            else
            {
               _loc2_.x = (this._titleSprite.width - _loc2_.width) / 2;
               _loc2_.y = (this._titleSprite.height - _loc2_.height) / 2;
               this._titleSprite.addChild(_loc2_);
            }
         }
      }
      
      protected function __onSelectChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         switch(int(this._selectedButtonGroup.selectIndex))
         {
            case 0:
               this._titleList.updateOwnTitleList();
               break;
            case 1:
               this._titleList.updateAllTitleList();
         }
      }
      
      private function __upadteTitle(param1:EffortEvent) : void
      {
         if(this._selectedButtonGroup.selectIndex == 0)
         {
            this._titleList.updateOwnTitleList();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,2,true,1);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               NewTitleControl.instance.hide();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__frameEventHandler);
         this._hideBtn.removeEventListener("click",this.__onHideTitleClick);
         this._selectedButtonGroup.removeEventListener("change",this.__onSelectChange);
         this._useBtn.removeEventListener("click",this.__onUseClick);
         NewTitleControl.instance.removeEventListener("titleItemClick",this.__onItemClick);
         NewTitleManager.instance.removeEventListener("setSelectTitle",this.__onSetSelectTitleForCurrent);
         EffortManager.Instance.removeEventListener("finish",this.__upadteTitle);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._titleBg);
         this._titleBg = null;
         ObjectUtils.disposeAllChildren(this._titleSprite);
         this._titleSprite = null;
         ObjectUtils.disposeObject(this._titleTxt);
         this._titleTxt = null;
         ObjectUtils.disposeObject(this._titleBottomBg);
         this._titleBottomBg = null;
         ObjectUtils.disposeObject(this._titleListBg);
         this._titleListBg = null;
         ObjectUtils.disposeObject(this._titleProBg);
         this._titleProBg = null;
         ObjectUtils.disposeObject(this._hideBtn);
         this._hideBtn = null;
         ObjectUtils.disposeObject(this._useBtnBg);
         this._useBtnBg = null;
         ObjectUtils.disposeObject(this._useBtn);
         this._useBtn = null;
         ObjectUtils.disposeObject(this._hasTitleBtn);
         this._hasTitleBtn = null;
         ObjectUtils.disposeObject(this._propertyText);
         this._propertyText = null;
         ObjectUtils.disposeObject(this._oldTitleText);
         this._oldTitleText = null;
         ObjectUtils.disposeObject(this._allTitleBtn);
         this._allTitleBtn = null;
         ObjectUtils.disposeObject(this._titleList);
         this._titleList = null;
         ObjectUtils.disposeObject(this._currentTitle);
         this._currentTitle = null;
      }
   }
}
