package ddt.view.chat
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.ui.Keyboard;
   
   public class ChatFastReplyPanel extends ChatBasePanel
   {
      
      public static const SELECTED_INGAME:String = "selectedingame";
      
      private static const FASTREPLYS:Array = [LanguageMgr.GetTranslation("chat.fastRepley.Message0"),LanguageMgr.GetTranslation("chat.fastRepley.Message1"),LanguageMgr.GetTranslation("chat.fastRepley.Message2"),LanguageMgr.GetTranslation("chat.fastRepley.Message3"),LanguageMgr.GetTranslation("chat.fastRepley.Message4")];
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _box:VBox;
      
      private var _inGame:Boolean;
      
      private var _items:Vector.<ChatFastReplyItem>;
      
      private var _selected:String;
      
      private var _boundary:Bitmap;
      
      private var _inputBg:Bitmap;
      
      private var _enterBtn:SimpleBitmapButton;
      
      private var _inputBox:FilterFrameText;
      
      private var _defaultStr:String;
      
      private var _customCnt:uint;
      
      private var _isDeleting:Boolean;
      
      private var _customBg:Shape;
      
      private var _tempText:String;
      
      private var _isEditing:Boolean;
      
      public function ChatFastReplyPanel(param1:Boolean = false)
      {
         this._inGame = param1;
         super();
      }
      
      public function get isEditing() : Boolean
      {
         return this._isEditing;
      }
      
      public function set isEditing(param1:Boolean) : void
      {
         this._isEditing = param1;
      }
      
      public function get selectedWrod() : String
      {
         return this._selected;
      }
      
      override public function set setVisible(param1:Boolean) : void
      {
         super.setVisible = param1;
         if(param1)
         {
            if(ChatManager.Instance.isInGame)
            {
               this.isEditing = true;
            }
            this.fixVerticalPos();
            this._tempText = this._inputBox.text;
            this._inputBox.text = this._defaultStr;
            this._inputBox.scrollH = 0;
         }
      }
      
      public function setText() : void
      {
         visible = true;
         this._inputBox.text = this._tempText;
         y += (this._items.length - 5) * 21;
         this.isEditing = false;
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:ChatFastReplyItem = param1.currentTarget as ChatFastReplyItem;
         this._selected = _loc2_.word;
         if(this._inGame)
         {
            dispatchEvent(new Event(SELECTED_INGAME));
         }
         else
         {
            dispatchEvent(new Event(Event.SELECT));
         }
      }
      
      private function __mouseClick(param1:*) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         switch(param1.currentTarget)
         {
            case this._inputBox:
               if(this._inputBox.text == this._defaultStr)
               {
                  this._inputBox.text = "";
               }
               break;
            case this._enterBtn:
               this.createCustomItem();
               break;
            default:
               if(this._isDeleting)
               {
                  this._isDeleting = false;
                  return;
               }
               break;
         }
      }
      
      private function __deleteItem(param1:ChatEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:ChatFastReplyItem = param1.data as ChatFastReplyItem;
         var _loc3_:uint = this._items.indexOf(_loc2_);
         _loc2_.removeEventListener(MouseEvent.CLICK,this.__itemClick);
         _loc2_.dispose();
         this._items.splice(_loc3_,1);
         ChatManager.Instance.model.customFastReply.splice(_loc3_ - 5,1);
         delete SharedManager.Instance.fastReplys[_loc2_.word];
         SharedManager.Instance.save();
         --this._customCnt;
         this.updatePos(-1);
         this._isDeleting = true;
      }
      
      private function createCustomItem() : void
      {
         if(this._inputBox.text == "" || this._inputBox.text == this._defaultStr)
         {
            return;
         }
         if(this._customCnt >= 5)
         {
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("chat.FastReplyCustomCountLimit"));
            return;
         }
         var _loc1_:String = FilterWordManager.filterWrod(this._inputBox.text);
         var _loc2_:ChatFastReplyItem = new ChatFastReplyItem(_loc1_,true);
         _loc2_.addEventListener(MouseEvent.CLICK,this.__itemClick);
         _loc2_.addEventListener(ChatEvent.DELETE,this.__deleteItem);
         this._items.push(_loc2_);
         ChatManager.Instance.model.customFastReply.push(_loc2_.word);
         this._box.addChild(_loc2_);
         SharedManager.Instance.fastReplys[_loc2_.word] = _loc2_.word;
         SharedManager.Instance.save();
         ++this._customCnt;
         this.updatePos(1);
         this._inputBox.text = this._defaultStr;
         this._inputBox.scrollH = 0;
         StageReferance.stage.focus = null;
      }
      
      private function updatePos(param1:int) : void
      {
         this._inputBg.y = this._box.height + 10;
         this._enterBtn.y = this._inputBg.y + 2;
         this._inputBox.y = this._enterBtn.y + 2;
         this._bg.height = this._inputBox.y + this._inputBox.height + 6;
         this._customBg.y = this._boundary.y + this._boundary.height + 8;
         if(this._customCnt == 0)
         {
            this._customBg.height = 0;
         }
         else
         {
            this._customBg.height = this._box.height - this._customBg.y + 8;
         }
         y -= 21 * param1;
      }
      
      private function fixVerticalPos() : void
      {
         var _loc1_:uint = this._items.length - 5;
         y -= _loc1_ * 21;
      }
      
      override protected function init() : void
      {
         var _loc2_:* = null;
         var _loc3_:ChatFastReplyItem = null;
         var _loc4_:ChatFastReplyItem = null;
         super.init();
         this._defaultStr = LanguageMgr.GetTranslation("chat.FastReplyDefaultStr");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.FastReplyBg");
         this._box = ComponentFactory.Instance.creatComponentByStylename("chat.FastReplyList");
         this._boundary = ComponentFactory.Instance.creatBitmap("asset.chat.FastReplyBoundary");
         this._inputBg = ComponentFactory.Instance.creatBitmap("asset.chat.FastReplyInputBg");
         this._enterBtn = ComponentFactory.Instance.creatComponentByStylename("chat.FastReplyEnterBtn");
         this._inputBox = ComponentFactory.Instance.creatComponentByStylename("chat.FastReplyInputTxt");
         this._customBg = new Shape();
         this._customBg.graphics.beginFill(12166,0.4);
         this._customBg.graphics.drawRect(5,0,168,1);
         this._customBg.graphics.endFill();
         this._items = new Vector.<ChatFastReplyItem>();
         var _loc1_:int = 0;
         while(_loc1_ < FASTREPLYS.length)
         {
            _loc3_ = new ChatFastReplyItem(FASTREPLYS[_loc1_]);
            _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._items.push(_loc3_);
            this._box.addChild(_loc3_);
            _loc1_++;
         }
         this._box.addChild(this._boundary);
         for(_loc2_ in SharedManager.Instance.fastReplys)
         {
            _loc4_ = new ChatFastReplyItem(SharedManager.Instance.fastReplys[_loc2_],true);
            _loc4_.addEventListener(MouseEvent.CLICK,this.__itemClick);
            _loc4_.addEventListener(ChatEvent.DELETE,this.__deleteItem);
            ChatManager.Instance.model.customFastReply.push(_loc4_.word);
            this._items.push(_loc4_);
            this._box.addChild(_loc4_);
            ++this._customCnt;
         }
         this._inputBox.maxChars = 20;
         this._inputBox.text = this._defaultStr;
         this._selected = "";
         this.updatePos(0);
         this.fixVerticalPos();
         addChild(this._bg);
         addChild(this._customBg);
         addChild(this._box);
         addChild(this._inputBg);
         addChild(this._enterBtn);
         addChild(this._inputBox);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._inputBox.addEventListener(FocusEvent.FOCUS_OUT,this.__focusOut);
         this._inputBox.addEventListener(KeyboardEvent.KEY_DOWN,this.__creatItem);
         this._inputBox.addEventListener(MouseEvent.CLICK,this.__mouseClick);
         this._inputBox.addEventListener(TextEvent.TEXT_INPUT,this.__checkMaxChars);
         this._enterBtn.addEventListener(MouseEvent.CLICK,this.__mouseClick);
         addEventListener(MouseEvent.CLICK,this.__spriteClick);
      }
      
      private function __spriteClick(param1:MouseEvent) : void
      {
         this.isEditing = false;
      }
      
      private function __checkMaxChars(param1:TextEvent) : void
      {
         if(this._inputBox.length >= 20)
         {
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("chat.FastReplyCustomTextLengthLimit"));
         }
      }
      
      private function __creatItem(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            SoundManager.instance.play("008");
            this.createCustomItem();
         }
      }
      
      private function __focusOut(param1:FocusEvent) : void
      {
         if(param1.currentTarget.text == "" || param1.currentTarget.text == this._defaultStr)
         {
            param1.currentTarget.text = this._defaultStr;
         }
      }
   }
}
