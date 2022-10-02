package consortion.view.club
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ClubView extends Sprite implements Disposeable
   {
       
      
      private var _consortiaClubPage:int = 1;
      
      private var _consortionList:ConsortionList;
      
      private var _recordList:ClubRecordList;
      
      private var _BG:MovieClip;
      
      private var _clubBG:Bitmap;
      
      private var _wordsImage:MutipleImage;
      
      private var _searchInput:TextInput;
      
      private var _searchBtn:BaseButton;
      
      private var _declareBG:Scale9CornerImage;
      
      private var _declaration:TextArea;
      
      private var _applyBtn:BaseButton;
      
      private var _randomSearchBtn:BaseButton;
      
      private var _recordGroup:SelectedButtonGroup;
      
      private var _applyRecordBtn:SelectedButton;
      
      private var _inviteRecordBtn:SelectedButton;
      
      private var _createConsortionBtn:BaseButton;
      
      public function ClubView()
      {
         super();
      }
      
      public function enterClub() : void
      {
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.clubSearchConsortions,1,6,"",Math.floor(Math.random() * 5 + 1),1);
         ConsortionModelControl.Instance.getApplyRecordList(ConsortionModelControl.Instance.applyListComplete,PlayerManager.Instance.Self.ID);
         ConsortionModelControl.Instance.getInviteRecordList(ConsortionModelControl.Instance.InventListComplete);
         this.init();
         this.initEvent();
         this.__consortionListComplete(null);
      }
      
      private function init() : void
      {
         this._BG = ClassUtils.CreatInstance("asset.consortion.BG") as MovieClip;
         PositionUtils.setPos(this._BG,"consortionClub.BG.pos");
         this._clubBG = ComponentFactory.Instance.creatBitmap("asset.club.BG");
         this._wordsImage = ComponentFactory.Instance.creatComponentByStylename("club.wordImage.mutiple");
         this._consortionList = ComponentFactory.Instance.creatComponentByStylename("club.consortionList");
         this._searchInput = ComponentFactory.Instance.creatComponentByStylename("club.searchInput");
         this._searchInput.text = LanguageMgr.GetTranslation("tank.consortia.club.searchTxt");
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("club.searchConsortionBtn");
         this._declareBG = ComponentFactory.Instance.creatComponentByStylename("club.declareBG");
         this._declaration = ComponentFactory.Instance.creatComponentByStylename("club.declaration");
         this._applyBtn = ComponentFactory.Instance.creatComponentByStylename("club.applyBtn");
         this._randomSearchBtn = ComponentFactory.Instance.creatComponentByStylename("club.randomSearchBtn");
         this._recordGroup = new SelectedButtonGroup(false);
         this._applyRecordBtn = ComponentFactory.Instance.creatComponentByStylename("club.applyRecordBtn");
         this._inviteRecordBtn = ComponentFactory.Instance.creatComponentByStylename("club.inviteRecordBtn");
         this._recordGroup.addSelectItem(this._inviteRecordBtn);
         this._recordGroup.addSelectItem(this._applyRecordBtn);
         this._recordGroup.selectIndex = 0;
         this._recordList = ComponentFactory.Instance.creatCustomObject("club.recordList");
         this._createConsortionBtn = ComponentFactory.Instance.creatComponentByStylename("club.createConsortion");
         addChild(this._BG);
         addChild(this._clubBG);
         addChild(this._wordsImage);
         addChild(this._consortionList);
         addChild(this._searchInput);
         addChild(this._searchBtn);
         addChild(this._declareBG);
         addChild(this._declaration);
         addChild(this._applyBtn);
         addChild(this._randomSearchBtn);
         addChild(this._applyRecordBtn);
         addChild(this._inviteRecordBtn);
         addChild(this._recordList);
         addChild(this._createConsortionBtn);
         this.__recordListChange(null);
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__sarchWithInputHandler);
         this._applyBtn.addEventListener(MouseEvent.CLICK,this.__applyHandler);
         this._randomSearchBtn.addEventListener(MouseEvent.CLICK,this.__randomSearchHandler);
         this._consortionList.addEventListener(ConsortionEvent.CLUB_ITEM_SELECTED,this.__selectedOneConsortion);
         this._applyRecordBtn.addEventListener(MouseEvent.CLICK,this.__recordBtnClickHandler);
         this._inviteRecordBtn.addEventListener(MouseEvent.CLICK,this.__recordBtnClickHandler);
         this._createConsortionBtn.addEventListener(MouseEvent.CLICK,this.__createConsortionHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.CONSORTIONLIST_IS_CHANGE,this.__consortionListComplete);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.INVENT_LIST_IS_CHANGE,this.__recordListChange);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__recordListChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._searchInput.removeEventListener(MouseEvent.CLICK,this.__focusInHandler);
         this._searchInput.removeEventListener(FocusEvent.FOCUS_OUT,this.__focusOutHandler);
         this._searchInput.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__sarchWithInputHandler);
         this._applyBtn.removeEventListener(MouseEvent.CLICK,this.__applyHandler);
         this._randomSearchBtn.removeEventListener(MouseEvent.CLICK,this.__randomSearchHandler);
         this._consortionList.removeEventListener(ConsortionEvent.CLUB_ITEM_SELECTED,this.__selectedOneConsortion);
         this._applyRecordBtn.removeEventListener(MouseEvent.CLICK,this.__recordBtnClickHandler);
         this._inviteRecordBtn.removeEventListener(MouseEvent.CLICK,this.__recordBtnClickHandler);
         this._createConsortionBtn.removeEventListener(MouseEvent.CLICK,this.__createConsortionHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.CONSORTIONLIST_IS_CHANGE,this.__consortionListComplete);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.INVENT_LIST_IS_CHANGE,this.__recordListChange);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__recordListChange);
      }
      
      private function __createConsortionHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:CreateConsortionFrame = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._searchInput.addEventListener(MouseEvent.CLICK,this.__focusInHandler);
         this._searchInput.addEventListener(FocusEvent.FOCUS_OUT,this.__focusOutHandler);
         this._searchInput.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function __keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.__sarchWithInputHandler(null);
         }
      }
      
      private function __recordBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.__recordListChange(null);
      }
      
      private function __recordListChange(param1:ConsortionEvent) : void
      {
         switch(this._recordGroup.selectIndex)
         {
            case 0:
               this._recordList.setData(ConsortionModelControl.Instance.model.inventList,ClubRecordList.INVITE);
               break;
            case 1:
               this._recordList.setData(ConsortionModelControl.Instance.model.myApplyList,ClubRecordList.APPLY);
         }
      }
      
      private function __applyHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade < 7)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.playerTip.notInvite"));
            return;
         }
         if(!this._consortionList.currentItem.info.OpenApply)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.applyJoinClickHandler"));
            return;
         }
         this._consortionList.currentItem.isApply = true;
         this._applyBtn.enable = false;
         this._recordGroup.selectIndex = 1;
         SocketManager.Instance.out.sendConsortiaTryIn(this._consortionList.currentItem.info.ConsortiaID);
      }
      
      private function __randomSearchHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this._consortiaClubPage;
         var _loc2_:int = ConsortionModelControl.Instance.model.consortionsListTotalCount;
         if(_loc2_ != 0)
         {
            if(this._consortiaClubPage > _loc2_)
            {
               this._consortiaClubPage = 1;
            }
         }
         else
         {
            this._consortiaClubPage = 1;
         }
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.clubSearchConsortions,this._consortiaClubPage,6);
      }
      
      private function __selectedOneConsortion(param1:ConsortionEvent) : void
      {
         this._declaration.text = this._consortionList.currentItem.info.Description;
         if(this._declaration.text == "")
         {
            this._declaration.text = LanguageMgr.GetTranslation("tank.consortia.club.text");
         }
         this._applyBtn.enable = true;
      }
      
      private function __consortionListComplete(param1:ConsortionEvent) : void
      {
         this._consortionList.setListData(ConsortionModelControl.Instance.model.consortionList);
         this._declaration.text = "";
         this._applyBtn.enable = false;
      }
      
      private function __focusInHandler(param1:MouseEvent) : void
      {
         if(this._searchInput.text == LanguageMgr.GetTranslation("tank.consortia.club.searchTxt"))
         {
            this._searchInput.text = "";
         }
      }
      
      private function __focusOutHandler(param1:FocusEvent) : void
      {
         if(this._searchInput.text == "")
         {
            this._searchInput.text = LanguageMgr.GetTranslation("tank.consortia.club.searchTxt");
         }
      }
      
      private function __sarchWithInputHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this._consortiaClubPage;
         var _loc2_:int = ConsortionModelControl.Instance.model.consortionsListTotalCount;
         if(_loc2_ != 0)
         {
            if(this._consortiaClubPage > _loc2_)
            {
               this._consortiaClubPage = 1;
            }
         }
         if(this._searchInput.text == "" || this._searchInput.text == LanguageMgr.GetTranslation("tank.consortia.club.searchTxt"))
         {
            ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.clubSearchConsortions,this._consortiaClubPage,6);
         }
         else
         {
            ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.clubSearchConsortions,this._consortiaClubPage,6,this._searchInput.text);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._consortionList = null;
         this._recordList = null;
         this._BG = null;
         this._clubBG = null;
         this._wordsImage = null;
         this._searchInput = null;
         this._searchBtn = null;
         this._declareBG = null;
         this._declaration = null;
         this._applyBtn = null;
         this._randomSearchBtn = null;
         this._recordGroup = null;
         this._applyRecordBtn = null;
         this._inviteRecordBtn = null;
         this._createConsortionBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
