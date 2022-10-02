package ddt.view.consortia
{
   import baglocked.BaglockedManager;
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
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class MyConsortiaTax extends Frame
   {
       
      
      private var _input:uint;
      
      private var _money:Number;
      
      private var _okBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _totalTicketTxt:FilterFrameText;
      
      private var _inputTicket:TextInput;
      
      private var _totalMoneyTxt:FilterFrameText;
      
      private var leaveToFillAlert:BaseAlerFrame;
      
      private var confirmAlert:BaseAlerFrame;
      
      public function MyConsortiaTax()
      {
         super();
         this.addEvent();
      }
      
      override protected function init() : void
      {
         super.init();
         escEnable = true;
         enterEnable = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.titleText");
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.core.MyConsortiaTax.taxBG");
         addToContent(_loc1_);
         this._okBtn = ComponentFactory.Instance.creat("core.MyConsortiaTax.okBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         addToContent(this._okBtn);
         this._okBtn.enable = false;
         this._cancelBtn = ComponentFactory.Instance.creat("core.MyConsortiaTax.cancelBtn");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         addToContent(this._cancelBtn);
         this._totalTicketTxt = ComponentFactory.Instance.creat("core.MyConsortiaTax.totalTicketTxt");
         addToContent(this._totalTicketTxt);
         this._inputTicket = ComponentFactory.Instance.creat("core.MyConsortiaTax.input");
         this._inputTicket.textField.restrict = "0-9";
         addToContent(this._inputTicket);
         this._totalMoneyTxt = ComponentFactory.Instance.creat("core.MyConsortiaTax.totalMoneyTxt");
         addToContent(this._totalMoneyTxt);
         this._totalTicketTxt.selectable = false;
         this._totalMoneyTxt.selectable = false;
         this._totalMoneyTxt.mouseEnabled = false;
         this._totalMoneyTxt.text = "0";
         if(PlayerManager.Instance.Self.Money == 0)
         {
            this._okBtn.enable = false;
            this._inputTicket.textField.restrict = "";
         }
      }
      
      public function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__sendOffer);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancel);
         this._inputTicket.addEventListener(Event.CHANGE,this.__input);
         this._inputTicket.addEventListener(Event.ADDED_TO_STAGE,this.__displayCursor);
         this._inputTicket.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyResponse);
      }
      
      public function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         if(this._okBtn)
         {
            this._okBtn.removeEventListener(MouseEvent.CLICK,this.__sendOffer);
         }
         if(this._cancelBtn)
         {
            this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancel);
         }
         if(this._inputTicket)
         {
            this._inputTicket.removeEventListener(Event.CHANGE,this.__input);
            this._inputTicket.removeEventListener(Event.ADDED_TO_STAGE,this.__displayCursor);
            this._inputTicket.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyResponse);
         }
      }
      
      private function __keyResponse(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.__sendOffer(null);
         }
      }
      
      private function sendSocketData() : void
      {
         var _loc1_:int = int(this._inputTicket.text);
         SocketManager.Instance.out.sendConsortiaRichOffer(_loc1_);
         this._totalMoneyTxt.text = "0";
         this._okBtn.enable = false;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      private function isTex(param1:Boolean = true) : Boolean
      {
         if(PlayerManager.Instance.Self.Money == 0 && param1)
         {
            this._inputTicket.text = "";
            this._inputTicket.textField.restrict = "";
            this._okBtn.enable = false;
            return false;
         }
         this._inputTicket.textField.restrict = "0-9";
         return true;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(this._okBtn)
         {
            ObjectUtils.disposeObject(this._okBtn);
         }
         this._okBtn = null;
         if(this._cancelBtn)
         {
            ObjectUtils.disposeObject(this._cancelBtn);
         }
         this._cancelBtn = null;
         if(this._totalTicketTxt)
         {
            ObjectUtils.disposeObject(this._totalTicketTxt);
         }
         this._totalTicketTxt = null;
         if(this._inputTicket)
         {
            ObjectUtils.disposeObject(this._inputTicket);
         }
         this._inputTicket = null;
         if(this._totalMoneyTxt)
         {
            ObjectUtils.disposeObject(this._totalMoneyTxt);
         }
         this._totalMoneyTxt = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function set TextInput(param1:String) : void
      {
         this._inputTicket.text = param1;
         this._totalMoneyTxt.text = "0";
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         if(stage)
         {
            stage.focus = this._inputTicket.textField;
         }
         this._totalTicketTxt.text = PlayerManager.Instance.Self.Money + "";
      }
      
      private function __sendOffer(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:int = int(this._inputTicket.text);
         if(_loc2_ > PlayerManager.Instance.Self.Money)
         {
            this.leaveToFillAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            LayerManager.Instance.addToLayer(this.leaveToFillAlert,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this.leaveToFillAlert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         }
         else if(Number(this._inputTicket.text) < 2)
         {
            this._inputTicket.text = "";
            this._okBtn.enable = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.input"));
         }
         else
         {
            this.confirmAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.sure"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.confirmAlert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         }
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(_loc2_ == this.leaveToFillAlert)
            {
               LeavePageManager.leaveToFillPath();
            }
            else if(_loc2_ == this.confirmAlert)
            {
               this.sendSocketData();
            }
         }
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         ObjectUtils.disposeObject(_loc2_);
         _loc2_ = null;
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __cancel(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __input(param1:Event) : void
      {
         this._okBtn.enable = true;
         if(!this.isTex())
         {
            return;
         }
         var _loc2_:int = int(this._inputTicket.text);
         this._inputTicket.textField.maxChars = 8;
         if(_loc2_ <= PlayerManager.Instance.Self.Money)
         {
            if(this._inputTicket.text == "")
            {
               this._okBtn.enable = false;
            }
            this._inputTicket.textField.restrict = "0-9";
         }
         else
         {
            this._inputTicket.text = String(PlayerManager.Instance.Self.Money);
         }
         if(_loc2_ == 0)
         {
            this._okBtn.enable = false;
            this._inputTicket.text = "";
         }
         this._money = Number((param1.currentTarget as TextInput).text) / 2;
         this._totalMoneyTxt.text = String(Math.floor(this._money));
      }
      
      private function __displayCursor(param1:Event) : void
      {
         this.isTex(false);
         this._inputTicket.setFocus();
         this._inputTicket.text = "";
         this._totalMoneyTxt.text = "0";
         this._okBtn.enable = false;
      }
   }
}
