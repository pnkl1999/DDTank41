package ddt.view.academyCommon.myAcademy
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.academyCommon.myAcademy.myAcademyItem.MyAcademyApprenticeItem;
   import ddt.view.academyCommon.myAcademy.myAcademyItem.MyAcademyMasterItem;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class MyAcademyMasterFrame extends BaseAlerFrame implements Disposeable
   {
      
      public static const ITEM_NUM:int = 3;
      
      public static const BOTTOM_GAP:int = 27;
       
      
      protected var _myAcademyTitle:Bitmap;
      
      protected var _myAcademyIcon:Bitmap;
      
      protected var _itemBG:MovieImage;
      
      protected var _titleBtn:BaseButton;
      
      protected var _myApprentice:DictionaryData;
      
      protected var _items:Vector.<MyAcademyApprenticeItem>;
      
      protected var _alertInfo:AlertInfo;
      
      protected var _currentItem:MyAcademyMasterItem;
      
      protected var _gradueteNumText:GradientText;
      
      protected var _masterHonorText:GradientText;
      
      protected var _masterHonorBG:Bitmap;
      
      public function MyAcademyMasterFrame()
      {
         super();
         this.initContent();
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
         this._myAcademyTitle = ComponentFactory.Instance.creatBitmap("asset.academyCommon.myAcademy.myAcademyTitle");
         addToContent(this._myAcademyTitle);
         this._titleBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterFrame.titleBtn");
         addToContent(this._titleBtn);
         this._masterHonorBG = ComponentFactory.Instance.creatBitmap("asset.academyCommon.myAcademy.gradueteNumBG");
         addToContent(this._masterHonorBG);
         this._gradueteNumText = ComponentFactory.Instance.creatComponentByStylename("view.common.MyAcademyMasterFrame.gradueteNumText");
         this._gradueteNumText.text = String(PlayerManager.Instance.Self.graduatesCount);
         addToContent(this._gradueteNumText);
         this._masterHonorText = ComponentFactory.Instance.creatComponentByStylename("view.common.MyAcademyMasterFrame.masterHonorText");
         this._masterHonorText.text = PlayerManager.Instance.Self.honourOfMaster;
         addToContent(this._masterHonorText);
         this._myApprentice = AcademyManager.Instance.myAcademyPlayers;
         this.initItem();
      }
      
      protected function initItem() : void
      {
         this._myAcademyIcon = ComponentFactory.Instance.creatBitmap("asset.academyCommon.myAcademy.MyAcademyApprenticeIcon");
         addToContent(this._myAcademyIcon);
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.myAcademy.myAcademyApprenticeBG");
         addToContent(this._itemBG);
         this._items = new Vector.<MyAcademyApprenticeItem>();
         var _loc1_:MyAcademyApprenticeItem = new MyAcademyApprenticeItem();
         PositionUtils.setPos(_loc1_,"academyCommon.myAcademy.MyAcademyMasterFrame.Apprentice");
         addToContent(_loc1_);
         this._items.push(_loc1_);
         var _loc2_:MyAcademyApprenticeItem = new MyAcademyApprenticeItem();
         PositionUtils.setPos(_loc2_,"academyCommon.myAcademy.MyAcademyMasterFrame.ApprenticeII");
         addToContent(_loc2_);
         this._items.push(_loc2_);
         var _loc3_:MyAcademyApprenticeItem = new MyAcademyApprenticeItem();
         PositionUtils.setPos(_loc3_,"academyCommon.myAcademy.MyAcademyMasterFrame.ApprenticeIII");
         addToContent(_loc3_);
         this._items.push(_loc3_);
         this._masterHonorBG.visible = true;
         this.updateItem();
      }
      
      protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._titleBtn.addEventListener(MouseEvent.CLICK,this.__titleBtnClick);
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].addEventListener(MouseEvent.CLICK,this.__itemClick);
            _loc1_++;
         }
         AcademyManager.Instance.myAcademyPlayers.addEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         AcademyManager.Instance.myAcademyPlayers.addEventListener(DictionaryEvent.CLEAR,this.__clearItem);
      }
      
      protected function __titleBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AcademyFrameManager.Instance.showAcademyPreviewFrame();
      }
      
      protected function __clearItem(param1:DictionaryEvent) : void
      {
         this.updateItem();
      }
      
      protected function __removeItem(param1:DictionaryEvent) : void
      {
         this.updateItem();
      }
      
      protected function updateItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._myApprentice.list.length)
         {
            this._items[_loc1_].info = this._myApprentice.list[_loc1_];
            _loc1_++;
         }
         var _loc2_:int = this._myApprentice.list.length;
         while(_loc2_ < ITEM_NUM)
         {
            this._items[_loc2_].visible = false;
            _loc2_++;
         }
      }
      
      protected function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               AcademyManager.Instance.gotoAcademyState();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
         }
      }
      
      protected function clearItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            if(this._items[_loc1_])
            {
               this._items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__itemClick);
               this._items[_loc1_].dispose();
               this._items[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      protected function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentItem)
         {
            this._currentItem = param1.currentTarget as MyAcademyMasterItem;
         }
         if(this._currentItem != param1.currentTarget as MyAcademyMasterItem)
         {
            this._currentItem.isSelect = false;
         }
         this._currentItem = param1.currentTarget as MyAcademyMasterItem;
         this._currentItem.isSelect = true;
      }
      
      override public function dispose() : void
      {
         this.clearItem();
         removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         AcademyManager.Instance.myAcademyPlayers.removeEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         AcademyManager.Instance.myAcademyPlayers.removeEventListener(DictionaryEvent.CLEAR,this.__clearItem);
         if(this._itemBG)
         {
            ObjectUtils.disposeObject(this._itemBG);
            this._itemBG = null;
         }
         if(this._myAcademyIcon)
         {
            ObjectUtils.disposeObject(this._myAcademyIcon);
            this._myAcademyIcon = null;
         }
         if(this._myAcademyTitle)
         {
            ObjectUtils.disposeObject(this._myAcademyTitle);
            this._myAcademyTitle = null;
         }
         if(this._masterHonorBG)
         {
            ObjectUtils.disposeObject(this._masterHonorBG);
            this._masterHonorBG = null;
         }
         if(this._gradueteNumText)
         {
            this._gradueteNumText.dispose();
            this._gradueteNumText = null;
         }
         if(this._masterHonorText)
         {
            this._masterHonorText.dispose();
            this._masterHonorText = null;
         }
         if(this._titleBtn)
         {
            this._titleBtn.removeEventListener(MouseEvent.CLICK,this.__titleBtnClick);
            ObjectUtils.disposeObject(this._titleBtn);
            this._titleBtn = null;
         }
         if(this._currentItem)
         {
            this._currentItem.dispose();
            this._currentItem = null;
         }
         super.dispose();
      }
   }
}
