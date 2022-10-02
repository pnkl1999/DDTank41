package ddt.view.academyCommon.recommend
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class AcademyApprenticeMainFrame extends BaseAlerFrame implements Disposeable
   {
      
      public static const MAX_ITEM:int = 3;
      
      public static const BOTTOM_GAP:int = 11;
       
      
      protected var _recommendTitle:Bitmap;
      
      protected var _playerContainer:HBox;
      
      protected var _titleBtn:BaseButton;
      
      protected var _alertInfo:AlertInfo;
      
      protected var _items:Array;
      
      protected var _players:Vector.<AcademyPlayerInfo>;
      
      protected var _tree9CornerImage:Scale9CornerImage;
      
      protected var _currentItem:RecommendPlayerCellView;
      
      protected var _checkBoxBtn:SelectedCheckButton;
      
      public function AcademyApprenticeMainFrame()
      {
         super();
         this.initContent();
         this.initPlayerContainer();
         this.initEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function initContent() : void
      {
         this._alertInfo = new AlertInfo();
         this._alertInfo.bottomGap = BOTTOM_GAP;
         info = this._alertInfo;
         info.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame.title");
         this._tree9CornerImage = ComponentFactory.Instance.creatComponentByStylename("AcademyApprenticeMainFrame.scale9cornerImageTree");
         addToContent(this._tree9CornerImage);
         this._recommendTitle = ComponentFactory.Instance.creatBitmap("asset.academy.recommendTitleAsset");
         addToContent(this._recommendTitle);
         this._titleBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyApprenticeMainFrame.titleBtn");
         addToContent(this._titleBtn);
         this._playerContainer = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyApprenticeMainFrame.playerContainer");
         addToContent(this._playerContainer);
         this._checkBoxBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame.checkBoxBtn");
         this._checkBoxBtn.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame.checkBoxBtnInfo");
         if(!SharedManager.Instance.isRecommend)
         {
            addToContent(this._checkBoxBtn);
         }
      }
      
      protected function initPlayerContainer() : void
      {
         var _loc2_:RecommendPlayerCellView = null;
         this._items = [];
         var _loc1_:int = 0;
         while(_loc1_ < MAX_ITEM)
         {
            _loc2_ = new RecommendPlayerCellView();
            _loc2_.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._playerContainer.addChild(_loc2_);
            this._items.push(_loc2_);
            _loc1_++;
         }
         this._players = AcademyManager.Instance.recommendPlayers;
         this.updateItem();
      }
      
      protected function initEvent() : void
      {
         this._titleBtn.addEventListener(MouseEvent.CLICK,this.__titleBtnClick);
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._checkBoxBtn.addEventListener(MouseEvent.CLICK,this.__checkBoxBtnClick);
      }
      
      private function __checkBoxBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.isRecommend = this._checkBoxBtn.selected;
         SharedManager.Instance.save();
      }
      
      protected function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentItem)
         {
            this._currentItem = param1.currentTarget as RecommendPlayerCellView;
         }
         if(this._currentItem != param1.currentTarget as RecommendPlayerCellView)
         {
            this._currentItem.isSelect = false;
         }
         this._currentItem = param1.currentTarget as RecommendPlayerCellView;
         this._currentItem.isSelect = true;
      }
      
      protected function __frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(StateManager.currentStateType == StateType.ACADEMY_REGISTRATION)
               {
               }
               AcademyManager.Instance.gotoAcademyState();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
         }
      }
      
      protected function __titleBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AcademyFrameManager.Instance.showRecommendAcademyPreviewFrame();
      }
      
      protected function updateItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < MAX_ITEM)
         {
            this._items[_loc1_].info = this._players[_loc1_];
            _loc1_++;
         }
      }
      
      private function cleanItem() : void
      {
         if(!this._items)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__itemClick);
            this._items[_loc1_].dispose();
            this._items[_loc1_] = null;
            _loc1_++;
         }
         this._playerContainer.disposeAllChildren();
         this._items = null;
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._currentItem = null;
         this.cleanItem();
         if(this._recommendTitle)
         {
            ObjectUtils.disposeObject(this._recommendTitle);
            this._recommendTitle = null;
         }
         if(this._playerContainer)
         {
            ObjectUtils.disposeObject(this._playerContainer);
            this._playerContainer = null;
         }
         if(this._checkBoxBtn)
         {
            this._checkBoxBtn.removeEventListener(MouseEvent.CLICK,this.__checkBoxBtnClick);
            this._checkBoxBtn.dispose();
            this._checkBoxBtn = null;
         }
         if(this._titleBtn)
         {
            this._titleBtn.removeEventListener(MouseEvent.CLICK,this.__titleBtnClick);
            ObjectUtils.disposeObject(this._titleBtn);
            this._titleBtn = null;
         }
         if(this._tree9CornerImage)
         {
            ObjectUtils.disposeObject(this._tree9CornerImage);
            this._tree9CornerImage = null;
         }
         super.dispose();
      }
   }
}
