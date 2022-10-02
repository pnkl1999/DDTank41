package church.view.weddingRoom
{
   import church.model.ChurchRoomModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class WeddingRoomMenuView extends Sprite implements Disposeable
   {
       
      
      private var _model:ChurchRoomModel;
      
      private var _menuShowName:ScaleFrameImage;
      
      private var _menuShowPao:ScaleFrameImage;
      
      private var _menuShowFire:ScaleFrameImage;
      
      private var hideConfigs:Array;
      
      private var _moonBtn:MovieClip;
      
      private var _roomNameBox:Sprite;
      
      private var _roomNameBg:Scale9CornerImage;
      
      private var _txtRoomNameGroomName:FilterFrameText;
      
      private var _txtRoomNameAnd:FilterFrameText;
      
      private var _txtRoomNameBrideName:FilterFrameText;
      
      private var _txtRoomNameWedding:FilterFrameText;
      
      public function WeddingRoomMenuView(param1:ChurchRoomModel)
      {
         this.hideConfigs = [];
         super();
         this._model = param1;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         this._menuShowName = ComponentFactory.Instance.creat("asset.church.weddingRoom.menuShowNameAsset");
         this._menuShowName.buttonMode = true;
         this._menuShowName.setFrame(1);
         addChild(this._menuShowName);
         this._menuShowPao = ComponentFactory.Instance.creat("asset.church.weddingRoom.menuShowPaoAsset");
         this._menuShowPao.buttonMode = true;
         this._menuShowPao.setFrame(1);
         addChild(this._menuShowPao);
         this._menuShowFire = ComponentFactory.Instance.creat("asset.church.weddingRoom.menuShowFireAsset");
         this._menuShowFire.buttonMode = true;
         this._menuShowFire.setFrame(1);
         addChild(this._menuShowFire);
         this.setMoonBtn();
         this.setRoomName();
      }
      
      private function removeView() : void
      {
         if(this._menuShowName)
         {
            if(this._menuShowName.parent)
            {
               this._menuShowName.parent.removeChild(this._menuShowName);
            }
            this._menuShowName.dispose();
         }
         this._menuShowName = null;
         if(this._menuShowPao)
         {
            if(this._menuShowPao.parent)
            {
               this._menuShowPao.parent.removeChild(this._menuShowPao);
            }
            this._menuShowPao.dispose();
         }
         this._menuShowPao = null;
         if(this._menuShowFire)
         {
            if(this._menuShowFire.parent)
            {
               this._menuShowFire.parent.removeChild(this._menuShowFire);
            }
            this._menuShowFire.dispose();
         }
         this._menuShowFire = null;
         if(this._roomNameBg)
         {
            if(this._roomNameBg.parent)
            {
               this._roomNameBg.parent.removeChild(this._roomNameBg);
            }
            this._roomNameBg.dispose();
         }
         this._roomNameBg = null;
         if(this._txtRoomNameGroomName)
         {
            if(this._txtRoomNameGroomName.parent)
            {
               this._txtRoomNameGroomName.parent.removeChild(this._txtRoomNameGroomName);
            }
            this._txtRoomNameGroomName.dispose();
         }
         this._txtRoomNameGroomName = null;
         if(this._txtRoomNameAnd)
         {
            if(this._txtRoomNameAnd.parent)
            {
               this._txtRoomNameAnd.parent.removeChild(this._txtRoomNameAnd);
            }
            this._txtRoomNameAnd.dispose();
         }
         this._txtRoomNameAnd = null;
         if(this._txtRoomNameBrideName)
         {
            if(this._txtRoomNameBrideName.parent)
            {
               this._txtRoomNameBrideName.parent.removeChild(this._txtRoomNameBrideName);
            }
            this._txtRoomNameBrideName.dispose();
         }
         this._txtRoomNameBrideName = null;
         if(this._txtRoomNameWedding)
         {
            if(this._txtRoomNameWedding.parent)
            {
               this._txtRoomNameWedding.parent.removeChild(this._txtRoomNameWedding);
            }
            this._txtRoomNameWedding.dispose();
         }
         this._txtRoomNameWedding = null;
         if(this._moonBtn && this._moonBtn.parent)
         {
            this._moonBtn.parent.removeChild(this._moonBtn);
         }
         this._moonBtn = null;
         if(this._roomNameBox && this._roomNameBox.parent)
         {
            this._roomNameBox.parent.removeChild(this._roomNameBox);
         }
         this._roomNameBox = null;
         this.hideConfigs = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function setEvent() : void
      {
         this._menuShowName.addEventListener(MouseEvent.CLICK,this.onMenuClick);
         this._menuShowPao.addEventListener(MouseEvent.CLICK,this.onMenuClick);
         this._menuShowFire.addEventListener(MouseEvent.CLICK,this.onMenuClick);
      }
      
      public function backupConfig() : void
      {
         this.hideConfigs[0] = !!this._model.playerNameVisible ? true : false;
         this.hideConfigs[1] = !!this._model.playerChatBallVisible ? true : false;
         this.hideConfigs[2] = !!this._model.playerFireVisible ? true : false;
         this._model.playerNameVisible = this._model.playerChatBallVisible = this._model.playerFireVisible = false;
         this._menuShowName.mouseEnabled = this._menuShowPao.mouseEnabled = this._menuShowFire.mouseEnabled = false;
         this._menuShowName.setFrame(2);
         this._menuShowPao.setFrame(2);
         this._menuShowFire.setFrame(2);
      }
      
      public function revertConfig() : void
      {
         this._model.playerNameVisible = this.hideConfigs[0];
         this._model.playerChatBallVisible = this.hideConfigs[1];
         this._model.playerFireVisible = this.hideConfigs[2];
         this._menuShowName.mouseEnabled = this._menuShowPao.mouseEnabled = this._menuShowFire.mouseEnabled = true;
         this._menuShowName.setFrame(!!this._model.playerNameVisible ? int(int(1)) : int(int(2)));
         this._menuShowPao.setFrame(!!this._model.playerChatBallVisible ? int(int(1)) : int(int(2)));
         this._menuShowFire.setFrame(!!this._model.playerFireVisible ? int(int(1)) : int(int(2)));
      }
      
      private function removeEvent() : void
      {
         this._menuShowName.removeEventListener(MouseEvent.CLICK,this.onMenuClick);
         this._menuShowPao.removeEventListener(MouseEvent.CLICK,this.onMenuClick);
         this._menuShowFire.removeEventListener(MouseEvent.CLICK,this.onMenuClick);
         this._moonBtn.removeEventListener(MouseEvent.CLICK,this.enterMoonScene);
      }
      
      private function onMenuClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._menuShowName:
               if(this._menuShowName.getFrame == 1)
               {
                  this._menuShowName.setFrame(2);
                  this._model.playerNameVisible = false;
               }
               else
               {
                  this._menuShowName.setFrame(1);
                  this._model.playerNameVisible = true;
               }
               break;
            case this._menuShowPao:
               if(this._menuShowPao.getFrame == 1)
               {
                  this._menuShowPao.setFrame(2);
                  this._model.playerChatBallVisible = false;
               }
               else
               {
                  this._menuShowPao.setFrame(1);
                  this._model.playerChatBallVisible = true;
               }
               break;
            case this._menuShowFire:
               if(this._menuShowFire.getFrame == 1)
               {
                  this._menuShowFire.setFrame(2);
                  this._model.playerFireVisible = false;
               }
               else
               {
                  this._menuShowFire.setFrame(1);
                  this._model.playerFireVisible = true;
               }
         }
      }
      
      public function resetView() : void
      {
         if(ChurchManager.instance.currentScene)
         {
            if(this._roomNameBox.parent)
            {
               removeChild(this._roomNameBox);
            }
            if(this._moonBtn.parent)
            {
               removeChild(this._moonBtn);
            }
         }
         else
         {
            addChild(this._roomNameBox);
            if(ChurchManager.instance.currentRoom.isStarted && ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_NONE)
            {
               addChild(this._moonBtn);
            }
            else if(this._moonBtn.parent)
            {
               removeChild(this._moonBtn);
            }
         }
      }
      
      private function setMoonBtn() : void
      {
         if(!this._moonBtn)
         {
            this._moonBtn = ComponentFactory.Instance.creatCustomObject("church.room.moonBtnAsset");
            this._moonBtn.buttonMode = true;
            this._moonBtn.addEventListener(MouseEvent.CLICK,this.enterMoonScene);
         }
      }
      
      private function setRoomName() : void
      {
         this._roomNameBox = new Sprite();
         this._roomNameBox.mouseEnabled = false;
         addChild(this._roomNameBox);
         this._roomNameBg = ComponentFactory.Instance.creat("church.weddingRoom.roomNameBg");
         this._roomNameBox.addChild(this._roomNameBg);
         this._txtRoomNameGroomName = ComponentFactory.Instance.creat("church.weddingRoom.roomNameGroomBrideName");
         this._txtRoomNameGroomName.text = ChurchManager.instance.currentRoom.groomName;
         this._txtRoomNameGroomName.x = 5;
         this._txtRoomNameGroomName.y = 5;
         this._roomNameBox.addChild(this._txtRoomNameGroomName);
         this._txtRoomNameAnd = ComponentFactory.Instance.creat("church.weddingRoom.roomNameWedding");
         this._txtRoomNameAnd.text = LanguageMgr.GetTranslation("yu");
         this._txtRoomNameAnd.x = this._txtRoomNameGroomName.x + this._txtRoomNameGroomName.textWidth;
         this._txtRoomNameAnd.y = 5;
         this._roomNameBox.addChild(this._txtRoomNameAnd);
         this._txtRoomNameBrideName = ComponentFactory.Instance.creat("church.weddingRoom.roomNameGroomBrideName");
         this._txtRoomNameBrideName.text = ChurchManager.instance.currentRoom.brideName;
         this._txtRoomNameBrideName.x = this._txtRoomNameAnd.x + this._txtRoomNameAnd.textWidth;
         this._txtRoomNameBrideName.y = 5;
         this._roomNameBox.addChild(this._txtRoomNameBrideName);
         this._txtRoomNameWedding = ComponentFactory.Instance.creat("church.weddingRoom.roomNameWedding");
         this._txtRoomNameWedding.x = this._txtRoomNameBrideName.x + this._txtRoomNameBrideName.textWidth;
         this._txtRoomNameWedding.y = 5;
         this._txtRoomNameWedding.text = LanguageMgr.GetTranslation("dehunli");
         this._roomNameBox.addChild(this._txtRoomNameWedding);
         this._roomNameBg.width = this._roomNameBox.width + 5;
         this._roomNameBg.height = this._roomNameBox.height;
         this._roomNameBox.x = 1000 - this._roomNameBox.width - 5;
         this._roomNameBox.y = 10;
      }
      
      private function enterMoonScene(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ChurchManager.instance.currentScene = true;
         ComponentSetting.SEND_USELOG_ID(92);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}
