package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.list.IDropListTarget;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import road7th.utils.StringHelper;
   
   public class NameInputDropListTarget extends Sprite implements IDropListTarget, Disposeable
   {
      
      public static const LOOK:int = 1;
      
      public static const CLOSE:int = 2;
      
      public static const CLOSE_CLICK:String = "closeClick";
      
      public static const CLEAR_CLICK:String = "clearClick";
      
      public static const LOOK_CLICK:String = "lookClick";
       
      
      private var _background:Bitmap;
      
      private var _nameInput:TextInput;
      
      private var _clearBtn:BaseButton;
      
      private var _closeBtn:BaseButton;
      
      private var _lookBtn:Bitmap;
      
      private var _isListening:Boolean;
      
      public function NameInputDropListTarget()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._background = ComponentFactory.Instance.creatBitmap("asset.core.nameInputDropListTarget.BG");
         this._nameInput = ComponentFactory.Instance.creatComponentByStylename("NameInputDropListTarget.nameInput");
         this._clearBtn = ComponentFactory.Instance.creatComponentByStylename("NameInputDropListTarget.clear");
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("NameInputDropListTarget.close");
         this._lookBtn = ComponentFactory.Instance.creatBitmap("asset.core.nameInputDropListTarget.looK");
         addChild(this._background);
         addChild(this._nameInput);
         addChild(this._clearBtn);
         addChild(this._closeBtn);
         addChild(this._lookBtn);
         this.switchView(LOOK);
      }
      
      public function set text(param1:String) : void
      {
         this._nameInput.text = param1;
      }
      
      public function get text() : String
      {
         return this._nameInput.text;
      }
      
      public function switchView(param1:int) : void
      {
         switch(param1)
         {
            case LOOK:
               this._lookBtn.visible = true;
               this._closeBtn.visible = false;
               this._clearBtn.visible = false;
               break;
            case CLOSE:
               this._lookBtn.visible = false;
               this._closeBtn.visible = true;
               this._clearBtn.visible = true;
         }
      }
      
      private function initEvent() : void
      {
         this._clearBtn.addEventListener(MouseEvent.CLICK,this.__clearhandler);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeHandler);
         this._nameInput.addEventListener(Event.CHANGE,this.__changeDropList);
         this._nameInput.addEventListener(FocusEvent.FOCUS_IN,this._focusHandler);
      }
      
      private function removeEvent() : void
      {
         this._clearBtn.removeEventListener(MouseEvent.CLICK,this.__clearhandler);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeHandler);
         this._nameInput.removeEventListener(Event.CHANGE,this.__changeDropList);
         this._nameInput.removeEventListener(FocusEvent.FOCUS_IN,this._focusHandler);
      }
      
      public function setCursor(param1:int) : void
      {
         this._nameInput.textField.setSelection(param1,param1);
      }
      
      public function get caretIndex() : int
      {
         return this._nameInput.textField.caretIndex;
      }
      
      public function setValue(param1:*) : void
      {
         if(param1)
         {
            this._nameInput.text = param1.NickName;
         }
      }
      
      public function getValueLength() : int
      {
         if(this._nameInput)
         {
            return this._nameInput.text.length;
         }
         return 0;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._background);
         this._background = null;
         if(this._nameInput)
         {
            ObjectUtils.disposeObject(this._nameInput);
         }
         this._nameInput = null;
         if(this._clearBtn)
         {
            ObjectUtils.disposeObject(this._clearBtn);
         }
         this._clearBtn = null;
         if(this._closeBtn)
         {
            ObjectUtils.disposeObject(this._closeBtn);
         }
         this._closeBtn = null;
         if(this._lookBtn)
         {
            ObjectUtils.disposeObject(this._lookBtn);
         }
         this._lookBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __clearhandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(CLEAR_CLICK));
      }
      
      protected function __closeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._nameInput.text = "";
         this.switchView(LOOK);
         dispatchEvent(new Event(CLOSE_CLICK));
      }
      
      protected function __changeDropList(param1:Event) : void
      {
         StringHelper.checkTextFieldLength(this._nameInput.textField,14);
         if(this._nameInput.text == "")
         {
            this.switchView(LOOK);
         }
         else
         {
            this.switchView(CLOSE);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function _focusHandler(param1:FocusEvent) : void
      {
         this.__changeDropList(null);
      }
   }
}
