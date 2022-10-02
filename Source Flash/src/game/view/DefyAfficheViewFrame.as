package game.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ExternalInterfaceManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import room.model.RoomInfo;
   
   public class DefyAfficheViewFrame extends Frame
   {
       
      
      private var _defyAfficheTitBg:Bitmap;
      
      private var _defyAffichebtn:TextButton;
      
      private var _defyAffichebtn1:TextButton;
      
      private var _roomInfo:RoomInfo;
      
      private var _str:String;
      
      private var _textInput:TextInput;
      
      private var _titText:FilterFrameText;
      
      private var _titleInfoText:FilterFrameText;
      
      public function DefyAfficheViewFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._defyAfficheTitBg = null;
         this._defyAffichebtn = null;
         this._defyAffichebtn1 = null;
         this._textInput = null;
         this._titText = null;
         this._titleInfoText = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function inputCheck() : Boolean
      {
         if(this._textInput.text != "")
         {
            if(FilterWordManager.isGotForbiddenWords(this._textInput.text,"name"))
            {
               MessageTipManager.getInstance().show("公告中包含非法字符");
               return false;
            }
         }
         return true;
      }
      
      public function set roomInfo(param1:RoomInfo) : void
      {
         this._roomInfo = param1;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __alertSendDefy(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertSendDefy);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.Money < 500)
               {
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.point"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
                  _loc2_.moveEnable = false;
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this.__leaveToFill);
                  return;
               }
               this.handleString();
               this._str += this._textInput.text;
               SocketManager.Instance.out.sendDefyAffiche(this._str);
               this.dispose();
               break;
         }
      }
      
      private function __cancelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      private function __leaveToFill(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertSendDefy);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __okClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this.inputCheck())
         {
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.DefyAfficheView.hint"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__alertSendDefy);
      }
      
      private function __texeInput(param1:Event) : void
      {
         var _loc2_:String = String(30 - this._textInput.text.length);
         this._titText.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheTitText",_loc2_);
      }
      
      private function handleString() : void
      {
         var _loc1_:int = 0;
         this._str = "";
         this._str = "[" + PlayerManager.Instance.Self.NickName + "]";
         this._str += LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheCaput");
         if(this._roomInfo.defyInfo)
         {
            _loc1_ = 0;
            while(_loc1_ < this._roomInfo.defyInfo[1].length)
            {
               this._str += "[" + this._roomInfo.defyInfo[1][_loc1_] + "]";
               _loc1_++;
            }
         }
         this._str += LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheLast");
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput.textField.addEventListener(Event.CHANGE,this.__texeInput);
         this._defyAffichebtn.addEventListener(MouseEvent.CLICK,this.__okClick);
         this._defyAffichebtn1.addEventListener(MouseEvent.CLICK,this.__cancelClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._defyAffichebtn.removeEventListener(MouseEvent.CLICK,this.__okClick);
         this._defyAffichebtn1.removeEventListener(MouseEvent.CLICK,this.__cancelClick);
      }
      
      private function initView() : void
      {
         var _loc1_:SelfInfo = null;
         if(PathManager.solveExternalInterfaceEnabel())
         {
            _loc1_ = PlayerManager.Instance.Self;
            ExternalInterfaceManager.sendToAgent(10,_loc1_.ID,_loc1_.NickName,ServerManager.Instance.zoneName);
         }
         titleText = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.affiche");
         this._defyAfficheTitBg = ComponentFactory.Instance.creatBitmap("asset.game.defyAfficheTitBg");
         addToContent(this._defyAfficheTitBg);
         this._titText = ComponentFactory.Instance.creatComponentByStylename("game.view.titleText");
         this._titText.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheTitText","12");
         addToContent(this._titText);
         this._titleInfoText = ComponentFactory.Instance.creatComponentByStylename("game.view.titleInfoText");
         this._titleInfoText.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheInfoText");
         addToContent(this._titleInfoText);
         this._textInput = ComponentFactory.Instance.creatComponentByStylename("game.defyAfficheTextInput");
         this._textInput.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheInfo");
         addToContent(this._textInput);
         this._defyAffichebtn = ComponentFactory.Instance.creatComponentByStylename("game.defyAffichebtn");
         this._defyAffichebtn.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
         addToContent(this._defyAffichebtn);
         this._defyAffichebtn1 = ComponentFactory.Instance.creatComponentByStylename("game.defyAffichebtn1");
         this._defyAffichebtn1.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
         addToContent(this._defyAffichebtn1);
      }
   }
}
