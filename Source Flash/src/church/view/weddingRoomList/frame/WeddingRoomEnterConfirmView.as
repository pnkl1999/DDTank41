package church.view.weddingRoomList.frame
{
   import church.controller.ChurchRoomListController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class WeddingRoomEnterConfirmView extends BaseAlerFrame
   {
       
      
      private var _controller:ChurchRoomListController;
      
      private var _churchRoomInfo:ChurchRoomInfo;
      
      private var _bg:Scale9CornerImage;
      
      private var _bmpRoomName:Bitmap;
      
      private var _bmpGroom:Bitmap;
      
      private var _bmpBride:Bitmap;
      
      private var _bmpCount:Bitmap;
      
      private var _bmpSpareTime:Bitmap;
      
      private var _bmpLineBox:Bitmap;
      
      private var _bmpDescription:Bitmap;
      
      private var _bmpLine1:Bitmap;
      
      private var _imgLine2:Image;
      
      private var _imgLine3:Image;
      
      private var _imgLine4:Image;
      
      private var _imgLine5:Image;
      
      private var _roomNameText:FilterFrameText;
      
      private var _groomText:FilterFrameText;
      
      private var _grideText:FilterFrameText;
      
      private var _countText:FilterFrameText;
      
      private var _spareTime:FilterFrameText;
      
      private var _alertInfo:AlertInfo;
      
      private var _txtDescription:TextArea;
      
      private var _textDescriptionBg:Sprite;
      
      private var _weddingRoomEnterInputPasswordView:WeddingRoomEnterInputPasswordView;
      
      public function WeddingRoomEnterConfirmView()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      public function set controller(param1:ChurchRoomListController) : void
      {
         this._controller = param1;
      }
      
      public function set churchRoomInfo(param1:ChurchRoomInfo) : void
      {
         this._churchRoomInfo = param1;
         this._roomNameText.text = this._churchRoomInfo.roomName;
         this._groomText.text = this._churchRoomInfo.groomName;
         this._grideText.text = this._churchRoomInfo.brideName;
         this._countText.text = this._churchRoomInfo.currentNum.toString();
         var _loc2_:int = (this._churchRoomInfo.valideTimes * 60 - (TimeManager.Instance.Now().time / (1000 * 60) - this._churchRoomInfo.creactTime.time / (1000 * 60))) / 60;
         if(_loc2_ >= 0)
         {
            _loc2_ = Math.floor(_loc2_);
         }
         else
         {
            _loc2_ = Math.ceil(_loc2_);
         }
         var _loc3_:int = int(this._churchRoomInfo.valideTimes * 60 - (TimeManager.Instance.Now().time / (1000 * 60) - this._churchRoomInfo.creactTime.time / (1000 * 60))) % 60;
         if(_loc2_ < 0 || _loc3_ < 0)
         {
            this._spareTime.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.time");
         }
         else
         {
            this._spareTime.text = _loc2_.toString() + LanguageMgr.GetTranslation("hours") + _loc3_.toString() + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.minute");
         }
         this._txtDescription.text = this._churchRoomInfo.discription;
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.titleText");
         this._alertInfo.moveEnable = false;
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.into");
         info = this._alertInfo;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creat("church.main.roomEnterConfirmBg");
         addToContent(this._bg);
         this._bmpRoomName = ComponentFactory.Instance.creatBitmap("asset.church.roomEnterRoomNameAsset");
         addToContent(this._bmpRoomName);
         this._bmpGroom = ComponentFactory.Instance.creatBitmap("asset.church.roomEnterGroomAsset");
         addToContent(this._bmpGroom);
         this._bmpBride = ComponentFactory.Instance.creatBitmap("asset.church.roomEnterBrideAsset");
         addToContent(this._bmpBride);
         this._bmpCount = ComponentFactory.Instance.creatBitmap("asset.church.roomEnterCountAsset");
         addToContent(this._bmpCount);
         this._bmpSpareTime = ComponentFactory.Instance.creatBitmap("asset.church.roomEnterSpareTimeAsset");
         addToContent(this._bmpSpareTime);
         this._bmpLineBox = ComponentFactory.Instance.creatBitmap("asset.church.roomEnterLineBoxAsset");
         addToContent(this._bmpLineBox);
         this._bmpDescription = ComponentFactory.Instance.creatBitmap("asset.church.roomEnterDescriptionAsset");
         addToContent(this._bmpDescription);
         this._bmpLine1 = ComponentFactory.Instance.creatBitmap("asset.church.roomEnterLine1Asset");
         addToContent(this._bmpLine1);
         this._imgLine2 = ComponentFactory.Instance.creat("church.roomEnterLine2Asset");
         addToContent(this._imgLine2);
         this._imgLine3 = ComponentFactory.Instance.creat("church.roomEnterLine3Asset");
         addToContent(this._imgLine3);
         this._imgLine4 = ComponentFactory.Instance.creat("church.roomEnterLine4Asset");
         addToContent(this._imgLine4);
         this._imgLine5 = ComponentFactory.Instance.creat("church.roomEnterLine5Asset");
         addToContent(this._imgLine5);
         this._roomNameText = ComponentFactory.Instance.creat("church.main.roomEnterRoomNameTextAsset");
         addToContent(this._roomNameText);
         this._groomText = ComponentFactory.Instance.creat("church.main.roomEnterGroomTextAsset");
         addToContent(this._groomText);
         this._grideText = ComponentFactory.Instance.creat("church.main.roomEnterBrideTextAsset");
         addToContent(this._grideText);
         this._countText = ComponentFactory.Instance.creat("church.main.roomEnterCountTextAsset");
         addToContent(this._countText);
         this._spareTime = ComponentFactory.Instance.creat("church.main.roomEnterSpareTimeTextAsset");
         addToContent(this._spareTime);
         this._textDescriptionBg = new Sprite();
         this._textDescriptionBg.graphics.beginFill(16777215);
         this._textDescriptionBg.graphics.drawRect(0,0,238,136);
         this._textDescriptionBg.graphics.endFill();
         addToContent(this._textDescriptionBg);
         this._txtDescription = ComponentFactory.Instance.creat("church.view.weddingRoomList.frame.txtRoomEnterDescriptionAsset");
         this._textDescriptionBg.x = this._txtDescription.x;
         this._textDescriptionBg.y = this._txtDescription.y;
         addToContent(this._txtDescription);
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.enterRoomConfirm();
         }
      }
      
      private function enterRoomConfirm() : void
      {
         SoundManager.instance.play("008");
         if(this._churchRoomInfo.isLocked)
         {
            this._weddingRoomEnterInputPasswordView = ComponentFactory.Instance.creat("church.main.weddingRoomList.WeddingRoomEnterInputPasswordView");
            this._weddingRoomEnterInputPasswordView.churchRoomInfo = this._churchRoomInfo;
            this._weddingRoomEnterInputPasswordView.submitButtonEnable = false;
            this._weddingRoomEnterInputPasswordView.show();
         }
         else
         {
            SocketManager.Instance.out.sendEnterRoom(this._churchRoomInfo.id,"");
         }
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function removeView() : void
      {
         if(this._bg)
         {
            if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.dispose();
         }
         this._bg = null;
         if(this._bmpRoomName)
         {
            if(this._bmpRoomName.parent)
            {
               this._bmpRoomName.parent.removeChild(this._bmpRoomName);
            }
            this._bmpRoomName.bitmapData.dispose();
            this._bmpRoomName.bitmapData = null;
         }
         this._bmpRoomName = null;
         if(this._bmpGroom)
         {
            if(this._bmpGroom.parent)
            {
               this._bmpGroom.parent.removeChild(this._bmpGroom);
            }
            this._bmpGroom.bitmapData.dispose();
            this._bmpGroom.bitmapData = null;
         }
         this._bmpGroom = null;
         if(this._bmpBride)
         {
            if(this._bmpBride.parent)
            {
               this._bmpBride.parent.removeChild(this._bmpBride);
            }
            this._bmpBride.bitmapData.dispose();
            this._bmpBride.bitmapData = null;
         }
         this._bmpBride = null;
         if(this._bmpCount)
         {
            if(this._bmpCount.parent)
            {
               this._bmpCount.parent.removeChild(this._bmpCount);
            }
            this._bmpCount.bitmapData.dispose();
            this._bmpCount.bitmapData = null;
         }
         this._bmpCount = null;
         if(this._bmpSpareTime)
         {
            if(this._bmpSpareTime.parent)
            {
               this._bmpSpareTime.parent.removeChild(this._bmpSpareTime);
            }
            this._bmpSpareTime.bitmapData.dispose();
            this._bmpSpareTime.bitmapData = null;
         }
         this._bmpSpareTime = null;
         if(this._bmpLineBox)
         {
            if(this._bmpLineBox.parent)
            {
               this._bmpLineBox.parent.removeChild(this._bmpLineBox);
            }
            this._bmpLineBox.bitmapData.dispose();
            this._bmpLineBox.bitmapData = null;
         }
         this._bmpLineBox = null;
         if(this._bmpDescription)
         {
            if(this._bmpDescription.parent)
            {
               this._bmpDescription.parent.removeChild(this._bmpDescription);
            }
            this._bmpDescription.bitmapData.dispose();
            this._bmpDescription.bitmapData = null;
         }
         this._bmpDescription = null;
         if(this._bmpLine1)
         {
            if(this._bmpLine1.parent)
            {
               this._bmpLine1.parent.removeChild(this._bmpLine1);
            }
            this._bmpLine1.bitmapData.dispose();
            this._bmpLine1.bitmapData = null;
         }
         this._bmpLine1 = null;
         if(this._imgLine2)
         {
            if(this._imgLine2.parent)
            {
               this._imgLine2.parent.removeChild(this._imgLine2);
            }
            this._imgLine2.dispose();
         }
         this._imgLine2 = null;
         if(this._imgLine3)
         {
            if(this._imgLine3.parent)
            {
               this._imgLine3.parent.removeChild(this._imgLine3);
            }
            this._imgLine3.dispose();
         }
         this._imgLine3 = null;
         if(this._imgLine4)
         {
            if(this._imgLine4.parent)
            {
               this._imgLine4.parent.removeChild(this._imgLine4);
            }
            this._imgLine4.dispose();
         }
         this._imgLine4 = null;
         if(this._imgLine5)
         {
            if(this._imgLine5.parent)
            {
               this._imgLine5.parent.removeChild(this._imgLine5);
            }
            this._imgLine5.dispose();
         }
         this._imgLine5 = null;
         if(this._roomNameText)
         {
            if(this._roomNameText.parent)
            {
               this._roomNameText.parent.removeChild(this._roomNameText);
            }
            this._roomNameText.dispose();
         }
         this._roomNameText = null;
         if(this._groomText)
         {
            if(this._groomText.parent)
            {
               this._groomText.parent.removeChild(this._groomText);
            }
            this._groomText.dispose();
         }
         this._groomText = null;
         if(this._grideText)
         {
            if(this._grideText.parent)
            {
               this._grideText.parent.removeChild(this._grideText);
            }
            this._grideText.dispose();
         }
         this._grideText = null;
         if(this._countText)
         {
            if(this._countText.parent)
            {
               this._countText.parent.removeChild(this._countText);
            }
            this._countText.dispose();
         }
         this._countText = null;
         if(this._spareTime)
         {
            if(this._spareTime.parent)
            {
               this._spareTime.parent.removeChild(this._spareTime);
            }
            this._spareTime.dispose();
         }
         this._spareTime = null;
         this._alertInfo = null;
         this._txtDescription = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}
