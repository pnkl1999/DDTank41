package consortion.view.selfConsortia.consortiaTask
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class DonateFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _ownMoney:FilterFrameText;
      
      private var _taxMedal:TextInput;
      
      private var _confirm:TextButton;
      
      private var _cancel:TextButton;
      
      private var _targetValue:int;
      
      public function DonateFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         escEnable = true;
         enterEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("consortia.donateMEDAL");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.core.MyConsortiaTax.DonateBG");
         this._ownMoney = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.totalMEDALTxt");
         this._taxMedal = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaMEDAL.input");
         this._confirm = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.okBtn");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.cancelBtn");
         addToContent(this._bg);
         addToContent(this._ownMoney);
         addToContent(this._taxMedal);
         addToContent(this._confirm);
         addToContent(this._cancel);
         this._taxMedal.textField.restrict = "0-9";
         this._taxMedal.textField.maxChars = 8;
         this._confirm.text = LanguageMgr.GetTranslation("ok");
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this._confirm.enable = false;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._confirm.addEventListener(MouseEvent.CLICK,this.__confirmHanlder);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._taxMedal.addEventListener(Event.CHANGE,this.__taxChangeHandler);
         this._taxMedal.addEventListener(KeyboardEvent.KEY_DOWN,this.__enterHanlder);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._confirm.removeEventListener(MouseEvent.CLICK,this.__confirmHanlder);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._taxMedal.removeEventListener(Event.CHANGE,this.__taxChangeHandler);
         this._taxMedal.removeEventListener(KeyboardEvent.KEY_DOWN,this.__enterHanlder);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            this.dispose();
         }
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._taxMedal.setFocus();
         this._ownMoney.text = PlayerManager.Instance.Self.medal.toString();
         this._taxMedal.text = "";
      }
      
      private function __confirmHanlder(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._taxMedal != null)
         {
            _loc2_ = int(this._taxMedal.text);
            SocketManager.Instance.out.sendDonate(EquipType.MEDAL,_loc2_);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.donateOK"));
            this.dispose();
         }
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __taxChangeHandler(param1:Event) : void
      {
         if(this._taxMedal.text == "")
         {
            this._confirm.enable = false;
            return;
         }
         if(this._taxMedal.text == String(0))
         {
            this._taxMedal.text = "";
            return;
         }
         this._confirm.enable = true;
         var _loc2_:int = int(this._taxMedal.text);
         if(_loc2_ >= PlayerManager.Instance.Self.medal || _loc2_ >= this._targetValue)
         {
            this._taxMedal.text = PlayerManager.Instance.Self.medal <= this._targetValue ? PlayerManager.Instance.Self.medal.toString() : this._targetValue.toString();
         }
      }
      
      private function __enterHanlder(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(this._taxMedal.text == "")
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.plaese"));
            }
            else
            {
               this.__confirmHanlder(null);
            }
         }
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function set targetValue(param1:int) : void
      {
         this._targetValue = param1;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._ownMoney)
         {
            ObjectUtils.disposeObject(this._ownMoney);
         }
         this._ownMoney = null;
         if(this._taxMedal)
         {
            ObjectUtils.disposeObject(this._taxMedal);
         }
         this._taxMedal = null;
         if(this._confirm)
         {
            ObjectUtils.disposeObject(this._confirm);
         }
         this._confirm = null;
         if(this._cancel)
         {
            ObjectUtils.disposeObject(this._cancel);
         }
         this._cancel = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
