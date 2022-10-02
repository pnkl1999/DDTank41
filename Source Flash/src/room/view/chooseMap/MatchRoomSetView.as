package room.view.chooseMap
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class MatchRoomSetView extends Sprite implements Disposeable
   {
       
      
      private var _frame:BaseAlerFrame;
      
      private var _bg:Scale9CornerImage;
      
      private var _roomMode:Bitmap;
      
      private var _roomModeBlackBg:Scale9CornerImage;
      
      private var _modelIcon:Bitmap;
      
      private var _isDisposed:Boolean;
      
      private var _isReset:Boolean;
      
      private var _isChanged:Boolean = false;
      
      private var _explainTxt:FilterFrameText;
      
      private var _passTxt:TextInput;
      
      private var _checkBox:SelectedCheckButton;
      
      private var _textImage:Bitmap;
      
      private var _passBg:ScaleFrameImage;
      
      public function MatchRoomSetView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc2_:Sprite = null;
         _loc2_ = null;
         this._frame = ComponentFactory.Instance.creatComponentByStylename("room.MatchRoomSetView");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.room.MatchRoomSetViewBg");
         this._roomMode = ComponentFactory.Instance.creatBitmap("asset.room.roomTypeAsset");
         this._roomModeBlackBg = ComponentFactory.Instance.creatComponentByStylename("asset.room.challengeChooseMapViewBgTopLeft");
         this._roomModeBlackBg.x = 9;
         this._roomModeBlackBg.y = 51;
         this._modelIcon = ComponentFactory.Instance.creatBitmap("asset.roomList.mode_0");
         this._modelIcon.x = 103;
         this._modelIcon.y = 8;
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("tank.room.RoomIIMapSetPanel.room");
         _loc1_.moveEnable = false;
         _loc1_.showCancel = false;
         _loc1_.submitLabel = LanguageMgr.GetTranslation("ok");
         this._isDisposed = false;
         this._frame.info = _loc1_;
         PositionUtils.setPos(this._roomMode,"room.ChallengeChooseMapRoomModeTitlePos");
         this._roomMode.x = 3;
         this._roomMode.y = 10;
         this._passTxt = ComponentFactory.Instance.creat("roomList.pvpRoomList.passText");
         this._passTxt.x = 88;
         this._passTxt.y = 100;
         this._passTxt.text = "";
         this._passTxt.textField.restrict = "0-9 A-Z a-z";
         this._passTxt.visible = false;
         this._explainTxt = ComponentFactory.Instance.creat("roomList.pvpRoomList.ExplainText");
         this._explainTxt.x = 116;
         this._explainTxt.y = 70;
         _loc2_ = new Sprite();
         _loc2_.graphics.beginFill(16777215);
         _loc2_.graphics.drawRect(this._explainTxt.x,this._explainTxt.y,this._explainTxt.width,this._explainTxt.height);
         _loc2_.graphics.endFill();
         this._checkBox = ComponentFactory.Instance.creat("roomList.pvpRoomList.simpleSelectBtn");
         this._checkBox.x = 264;
         this._checkBox.y = 103;
         this._textImage = ComponentFactory.Instance.creatBitmap("asset.roomList.txtImage");
         this._textImage.x = 17;
         this._textImage.y = 68;
         this._passBg = ComponentFactory.Instance.creat("roomList.pvpRoomList.textBg");
         this._passBg.x = 88;
         this._passBg.y = 102;
         this._frame.addToContent(this._bg);
         this._frame.addToContent(this._roomMode);
         this._frame.addToContent(this._roomModeBlackBg);
         this._frame.addToContent(this._modelIcon);
         this._frame.addToContent(this._textImage);
         this._frame.addToContent(this._passBg);
         this._frame.addToContent(this._passTxt);
         this._frame.addToContent(this._checkBox);
         this._frame.addToContent(_loc2_);
         this._frame.addToContent(this._explainTxt);
         addChild(this._frame);
         this._checkBox.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this.updateRoomInfo();
      }
      
      private function updateRoomInfo() : void
      {
         this._explainTxt.text = RoomManager.Instance.current.Name;
         if(RoomManager.Instance.current.roomPass)
         {
            this._checkBox.selected = true;
            this._passBg.setFrame(1);
            this._passTxt.visible = true;
            this._passTxt.text = RoomManager.Instance.current.roomPass;
         }
         else
         {
            this._checkBox.selected = false;
            this._passBg.setFrame(2);
            this._passTxt.visible = false;
         }
      }
      
      private function __checkBoxClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.upadtePassTextBg();
      }
      
      private function upadtePassTextBg() : void
      {
         if(this._checkBox.selected)
         {
            this._passBg.setFrame(1);
            this._passTxt.visible = true;
            this._passTxt.setFocus();
         }
         else
         {
            this._passBg.setFrame(2);
            this._passTxt.text = "";
            this._passTxt.visible = false;
         }
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               if(FilterWordManager.IsNullorEmpty(this._explainTxt.text))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
                  SoundManager.instance.play("008");
               }
               else if(FilterWordManager.isGotForbiddenWords(this._explainTxt.text,"name"))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
                  SoundManager.instance.play("008");
               }
               else if(this._checkBox.selected && FilterWordManager.IsNullorEmpty(this._passTxt.text))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
                  SoundManager.instance.play("008");
               }
               else
               {
                  GameInSocketOut.sendGameRoomSetUp(0,RoomInfo.MATCH_ROOM,false,this._passTxt.text,this._explainTxt.text,3,0,0,RoomManager.Instance.current.isCrossZone,0);
                  RoomManager.Instance.current.roomName = this._explainTxt.text;
                  RoomManager.Instance.current.roomPass = this._passTxt.text;
                  this.hide();
               }
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.hide();
         }
      }
      
      public function showMatchRoomSetView() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         StageReferance.stage.focus = this._frame;
      }
      
      public function hide() : void
      {
         this._isChanged = false;
         parent.removeChild(this);
      }
      
      public function dispose() : void
      {
         if(!this._isDisposed)
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
            removeChild(this._frame);
            if(parent)
            {
               parent.removeChild(this);
            }
            this._frame.dispose();
            this._frame = null;
            this._bg.dispose();
            this._bg = null;
            this._roomMode = null;
            this._roomModeBlackBg.dispose();
            this._roomModeBlackBg = null;
            this._explainTxt.dispose();
            this._explainTxt = null;
            this._passTxt.dispose();
            this._passTxt = null;
            this._checkBox.dispose();
            this._checkBox = null;
            this._textImage = null;
            this._passBg.dispose();
            this._passBg = null;
            this._passBg = null;
            this._modelIcon.bitmapData.dispose();
            this._modelIcon = null;
            this._isDisposed = true;
         }
      }
   }
}
