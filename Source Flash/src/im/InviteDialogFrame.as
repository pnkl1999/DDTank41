package im
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.ui.Keyboard;
   import road7th.utils.StringHelper;
   
   public class InviteDialogFrame extends AddFriendFrame
   {
       
      
      private var _userName:String;
      
      private var _inviteCaption:String;
      
      private var _inputBG:Scale9CornerImage;
      
      private var _text:String;
      
      private var _initText:String;
      
      public function InviteDialogFrame()
      {
         super();
      }
      
      override protected function initContainer() : void
      {
         _alertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("im.InviteDialogFrame.name");
         _alertInfo.showCancel = false;
         _alertInfo.submitLabel = LanguageMgr.GetTranslation("im.InviteDialogFrame.send");
         info = _alertInfo;
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("im.InviteDialogFrame.inputBg");
         addToContent(this._inputBG);
         _inputText = ComponentFactory.Instance.creat("IM.InviteDialogFrame.Textinput");
         _inputText.wordWrap = true;
         _inputText.maxChars = 50;
         this.setText(LanguageMgr.GetTranslation("IM.InviteDialogFrame.info",ServerManager.Instance.zoneName));
         _inputText.setSelection(_inputText.text.length,_inputText.text.length);
         addToContent(_inputText);
         _inputText.addEventListener(Event.CHANGE,this.__inputChange);
      }
      
      protected function __inputChange(param1:Event) : void
      {
         if(_inputText.text.length > 0)
         {
            this._text = _inputText.text;
         }
         else
         {
            this._text = this._initText;
         }
      }
      
      public function setInfo(param1:String) : void
      {
         this._userName = param1;
      }
      
      public function setText(param1:String = "") : void
      {
         _inputText.text = param1;
         this._initText = this._text = param1;
         _inputText.setSelection(_inputText.text.length,_inputText.text.length);
      }
      
      override protected function __fieldKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.submit();
            SoundManager.instance.play("008");
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            hide();
            SoundManager.instance.play("008");
         }
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
      
      override protected function submit() : void
      {
         var _loc1_:URLRequest = null;
         var _loc2_:URLVariables = null;
         var _loc3_:URLLoader = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLVariables = null;
         var _loc6_:URLLoader = null;
         if(!StringHelper.isNullOrEmpty(PathManager.CommunityInvite()))
         {
            if(!FilterWordManager.isGotForbiddenWords(this._text))
            {
               _loc1_ = new URLRequest(PathManager.CommunityInvite());
               _loc2_ = new URLVariables();
               _loc2_["fuid"] = String(PlayerManager.Instance.Self.LoginName);
               _loc2_["fnick"] = PlayerManager.Instance.Self.NickName;
               _loc2_["tuid"] = this._userName;
               _loc2_["inviteCaption"] = this._text;
               _loc2_["rid"] = PlayerManager.Instance.Self.ID;
               _loc2_["serverid"] = String(ServerManager.Instance.AgentID);
               _loc2_["rnd"] = Math.random();
               _loc1_.data = _loc2_;
               _loc3_ = new URLLoader(_loc1_);
               _loc3_.load(_loc1_);
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo"));
               _loc4_ = new URLRequest(PathManager.solveRequestPath("LogInviteFriends.ashx"));
               _loc5_ = new URLVariables();
               _loc5_["Username"] = PlayerManager.Instance.Self.NickName;
               _loc5_["InviteUsername"] = this._userName;
               _loc5_["IsSucceed"] = false;
               _loc4_.data = _loc5_;
               _loc6_ = new URLLoader(_loc4_);
               _loc6_.load(_loc4_);
               _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
               this.dispose();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo1"));
            }
         }
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this._text = null;
         _inputText.removeEventListener(Event.CHANGE,this.__inputChange);
         if(this._inputBG)
         {
            this._inputBG.dispose();
         }
         this._inputBG = null;
         super.dispose();
      }
   }
}
