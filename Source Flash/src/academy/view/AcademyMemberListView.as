package academy.view
{
   import academy.AcademyController;
   import academy.AcademyEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AcademyMemberListView extends Sprite implements Disposeable
   {
      
      public static const ITEM_NUM:int = 12;
       
      
      private var _rightBg:Scale9CornerImage;
      
      private var _rightViewBg:MovieImage;
      
      private var _searchBG:Bitmap;
      
      private var _masterTitle:Bitmap;
      
      private var _apprenticeTitle:Bitmap;
      
      private var _searchBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _takeMasterBtn:SimpleBitmapButton;
      
      private var _freeBtn:BaseButton;
      
      private var _pageTxt:FilterFrameText;
      
      private var _searchTxt:TextInput;
      
      private var _items:Vector.<AcademyMemberItem>;
      
      private var _list:VBox;
      
      private var _controller:AcademyController;
      
      private var _currentPage:int = 1;
      
      private var _selectedItem:AcademyMemberItem;
      
      private var _takeStudentBtn:BaseButton;
      
      private var _isShowSearchInfo:Boolean = false;
      
      private var _timer:Timer;
      
      public function AcademyMemberListView(param1:AcademyController)
      {
         super();
         this._controller = param1;
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._rightBg = ComponentFactory.Instance.creatComponentByStylename("asset.AcademyPlayerPanel.rightBg");
         addChild(this._rightBg);
         this._rightViewBg = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.ListBg");
         addChild(this._rightViewBg);
         this._masterTitle = ComponentFactory.Instance.creatBitmap("asset.academy.MasterTitleAsset");
         addChild(this._masterTitle);
         this._apprenticeTitle = ComponentFactory.Instance.creatBitmap("asset.academy.ApprenticeTitleAsset");
         addChild(this._apprenticeTitle);
         this._searchBG = ComponentFactory.Instance.creatBitmap("asset.academy.search_bgAsset");
         addChild(this._searchBG);
         this._pageTxt = ComponentFactory.Instance.creat("academy.AcademyMemberListView.page");
         addChild(this._pageTxt);
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.searchBtn");
         addChild(this._searchBtn);
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.preBtn");
         addChild(this._preBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.nextBtn");
         addChild(this._nextBtn);
         this._takeStudentBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.takeStudentBtn");
         addChild(this._takeStudentBtn);
         this._takeMasterBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.takeMasterBtn");
         addChild(this._takeMasterBtn);
         this._freeBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.freeBtn");
         addChild(this._freeBtn);
         this._searchTxt = ComponentFactory.Instance.creat("academy.AcademyMemberListView.searchText");
         this._searchTxt.text = LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt");
         addChild(this._searchTxt);
         this._list = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.List");
         addChild(this._list);
         this.creatItems();
         this._controller.model.state = PlayerManager.Instance.Self.Grade >= AcademyManager.ACADEMY_LEVEL_MIN ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         this._timer = new Timer(500,1);
      }
      
      private function initEvent() : void
      {
         this._takeMasterBtn.addEventListener(MouseEvent.CLICK,this.__takeMasterClick);
         this._takeStudentBtn.addEventListener(MouseEvent.CLICK,this.__takeStudentClick);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__searchBtnClick);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._freeBtn.addEventListener(MouseEvent.CLICK,this.__freeBtnClick);
         this._controller.addEventListener(AcademyEvent.ACADEMY_UPDATE_LIST,this.__updateList);
         this._searchTxt.addEventListener(MouseEvent.CLICK,this.__searchTxtClick);
         AcademyManager.Instance.addEventListener(AcademyManager.SELF_DESCRIBE,this.__selfDescribe);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__register);
      }
      
      private function removeEvent() : void
      {
         this._takeMasterBtn.removeEventListener(MouseEvent.CLICK,this.__takeMasterClick);
         this._takeStudentBtn.removeEventListener(MouseEvent.CLICK,this.__takeStudentClick);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchBtnClick);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._freeBtn.removeEventListener(MouseEvent.CLICK,this.__freeBtnClick);
         this._controller.removeEventListener(AcademyEvent.ACADEMY_UPDATE_LIST,this.__updateList);
         this._searchTxt.removeEventListener(MouseEvent.CLICK,this.__searchTxtClick);
         AcademyManager.Instance.removeEventListener(AcademyManager.SELF_DESCRIBE,this.__selfDescribe);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__register);
      }
      
      private function __selfDescribe(param1:Event) : void
      {
         if(this._takeMasterBtn.visible && !AcademyManager.Instance.selfIsRegister)
         {
            this._takeMasterBtn.visible = false;
            this._takeStudentBtn.visible = true;
         }
      }
      
      private function __searchTxtClick(param1:MouseEvent) : void
      {
         if(this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            this._searchTxt.text = "";
         }
         else
         {
            this._searchTxt.textField.setSelection(0,this._searchTxt.text.length);
         }
      }
      
      private function creatItems() : void
      {
         var _loc2_:AcademyMemberItem = null;
         this._items = new Vector.<AcademyMemberItem>();
         var _loc1_:int = 0;
         while(_loc1_ < ITEM_NUM)
         {
            _loc2_ = new AcademyMemberItem();
            _loc2_.visible = false;
            _loc2_.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._list.addChild(_loc2_);
            this._items.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function cleanItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            (this._items[_loc1_] as AcademyMemberItem).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            this._items[_loc1_].dispose();
            _loc1_++;
         }
         this._list.disposeAllChildren();
         this._items = null;
      }
      
      private function __updateList(param1:AcademyEvent) : void
      {
         var _loc2_:Vector.<AcademyPlayerInfo> = null;
         _loc2_ = null;
         _loc2_ = this._controller.model.list;
         if(_loc2_.length == 0 && this._isShowSearchInfo)
         {
            this._isShowSearchInfo = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.registerInfoIII"));
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            this._items[_loc3_].visible = true;
            this._items[_loc3_].info = _loc2_[_loc3_];
            _loc3_++;
         }
         var _loc4_:int = _loc2_.length;
         while(_loc4_ < ITEM_NUM)
         {
            this._items[_loc4_].visible = false;
            _loc4_++;
         }
         if(this._selectedItem)
         {
            this._selectedItem.isSelect = false;
            this._selectedItem = this._items[0];
            this._selectedItem.isSelect = true;
         }
         else
         {
            this._selectedItem = this._items[0];
            this._selectedItem.isSelect = true;
         }
         this.updateLeafBtn();
         this.updateListBG();
         this.updateRegisterBtn();
      }
      
      private function __takeMasterClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedItem == null)
         {
            return;
         }
         if(AcademyManager.Instance.compareState(this._selectedItem.info.info,PlayerManager.Instance.Self))
         {
            AcademyFrameManager.Instance.showAcademyRequestMasterFrame(this._selectedItem.info.info);
         }
      }
      
      private function __takeStudentClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedItem == null)
         {
            return;
         }
         if(PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.APPRENTICE_STATE && AcademyManager.Instance.compareState(this._selectedItem.info.info,PlayerManager.Instance.Self))
         {
            AcademyFrameManager.Instance.showAcademyRequestApprenticeFrame(this._selectedItem.info.info);
         }
      }
      
      private function __freeBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AcademyFrameManager.Instance.showAcademyPreviewFrame();
      }
      
      private function __leafBtnClick(param1:MouseEvent) : void
      {
         this._timer.reset();
         this._timer.start();
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._preBtn:
               --this._currentPage;
               if(this._currentPage <= 1)
               {
                  this._currentPage = 1;
               }
               break;
            case this._nextBtn:
               ++this._currentPage;
         }
         this.updateLeafBtn();
      }
      
      private function __register(param1:TimerEvent) : void
      {
         if(this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            this._controller.loadAcademyMemberList(true,this._controller.model.state,this._currentPage);
         }
         else
         {
            this._controller.loadAcademyMemberList(true,this._controller.model.state,this._currentPage,this._searchTxt.text);
         }
      }
      
      private function updateLeafBtn() : void
      {
         if(this._controller.model.totalPage <= 0)
         {
            this._takeStudentBtn.enable = false;
            this._takeMasterBtn.enable = false;
         }
         else
         {
            this._takeStudentBtn.enable = true;
            this._takeMasterBtn.enable = true;
         }
         if(this._controller.model.totalPage <= 1)
         {
            this.setButtonState(false,false);
         }
         else if(this._currentPage == 1)
         {
            this.setButtonState(false,true);
         }
         else if(this._currentPage == this._controller.model.totalPage && this._currentPage != 0)
         {
            this.setButtonState(true,false);
         }
         else
         {
            this.setButtonState(true,true);
         }
         if(this._controller.model.totalPage == 0)
         {
            this._pageTxt.text = String(1) + " / " + String(1);
         }
         else
         {
            this._pageTxt.text = String(this._currentPage) + " / " + String(this._controller.model.totalPage);
         }
      }
      
      private function updateListBG() : void
      {
         if(this._controller.model.state)
         {
            this._masterTitle.visible = false;
            this._apprenticeTitle.visible = true;
         }
         else
         {
            this._masterTitle.visible = true;
            this._apprenticeTitle.visible = false;
         }
      }
      
      private function updateRegisterBtn() : void
      {
         if(PlayerManager.Instance.Self.Grade <= 16)
         {
            this._takeMasterBtn.visible = true;
            this._takeStudentBtn.visible = false;
         }
         else if(PlayerManager.Instance.Self.Grade >= 20)
         {
            this._takeMasterBtn.visible = false;
            this._takeStudentBtn.visible = true;
         }
      }
      
      private function setButtonState(param1:Boolean, param2:Boolean) : void
      {
         this._preBtn.mouseChildren = param1;
         this._preBtn.enable = param1;
         this._nextBtn.mouseChildren = param2;
         this._nextBtn.enable = param2;
      }
      
      private function __searchBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._searchTxt.text == "" || this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("civil.view.CivilRightView.info"));
         }
         else
         {
            this._currentPage = 1;
            this._controller.loadAcademyMemberList(true,this._controller.model.state,this._currentPage,this._searchTxt.text);
            this._isShowSearchInfo = true;
         }
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._selectedItem)
         {
            this._selectedItem = param1.currentTarget as AcademyMemberItem;
         }
         if(this._selectedItem != param1.currentTarget as AcademyMemberItem)
         {
            this._selectedItem.isSelect = false;
         }
         this._selectedItem = param1.currentTarget as AcademyMemberItem;
         this._selectedItem.isSelect = true;
         this._controller.currentAcademyInfo = this._selectedItem.info;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.cleanItem();
         if(this._list)
         {
            this._list.dispose();
            this._list = null;
         }
         if(this._rightViewBg)
         {
            ObjectUtils.disposeObject(this._rightViewBg);
            this._rightViewBg = null;
         }
         if(this._searchBG)
         {
            ObjectUtils.disposeObject(this._searchBG);
            this._searchBG = null;
         }
         if(this._pageTxt)
         {
            ObjectUtils.disposeObject(this._pageTxt);
            this._pageTxt = null;
         }
         if(this._searchBtn)
         {
            this._searchBtn.dispose();
            this._searchBtn = null;
         }
         if(this._preBtn)
         {
            this._preBtn.dispose();
            this._preBtn = null;
         }
         if(this._nextBtn)
         {
            this._nextBtn.dispose();
            this._nextBtn = null;
         }
         if(this._takeMasterBtn)
         {
            this._takeMasterBtn.dispose();
            this._takeMasterBtn = null;
         }
         if(this._searchTxt)
         {
            this._searchTxt.dispose();
            this._searchTxt = null;
         }
         if(this._freeBtn)
         {
            this._freeBtn.dispose();
            this._freeBtn = null;
         }
         if(this._selectedItem)
         {
            this._selectedItem.dispose();
            this._selectedItem = null;
         }
         if(this._rightBg)
         {
            this._rightBg.dispose();
         }
         if(this._masterTitle)
         {
            ObjectUtils.disposeObject(this._masterTitle);
            this._masterTitle = null;
         }
         if(this._apprenticeTitle)
         {
            ObjectUtils.disposeObject(this._apprenticeTitle);
            this._apprenticeTitle = null;
         }
         if(this._takeStudentBtn)
         {
            this._takeStudentBtn.dispose();
            this._takeStudentBtn = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
