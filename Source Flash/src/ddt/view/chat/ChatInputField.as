package ddt.view.chat
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.manager.ChatManager;
   import ddt.manager.DebugManager;
   import ddt.manager.IMEManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.Helpers;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import road7th.utils.StringHelper;
   
   public class ChatInputField extends Sprite
   {
      
      public static const INPUT_MAX_CHAT:int = 100;
      
      private static const CHANNEL_SET:Array = [0,1,2,3,4,5,15];
       
      
      private var CHANNEL_KEY_SET:Array;
      
      private var _channel:int = -1;
      
      private var _currentHistoryOffset:int = 0;
      
      private var _inputField:TextField;
      
      private var _maxInputWidth:Number = 300;
      
      private var _nameTextField:TextField;
      
      private var _privateChatName:String;
      
      private var _userID:int;
      
      private var _privateChatInfo:Object;
      
      public function ChatInputField()
      {
         this.CHANNEL_KEY_SET = ["d","x","w","g","p","s","k"];
         super();
         this.initView();
      }
      
      public function get channel() : int
      {
         return this._channel;
      }
      
      public function set channel(param1:int) : void
      {
         if(this._channel == param1)
         {
            return;
         }
         this._channel = param1;
         this.setPrivateChatName("");
         this.setTextFormat(ChatFormats.getTextFormatByChannel(this._channel));
      }
      
      public function isFocus() : Boolean
      {
         var _loc1_:Boolean = false;
         if(StageReferance.stage)
         {
            _loc1_ = StageReferance.stage.focus == this._inputField;
         }
         return _loc1_;
      }
      
      public function set maxInputWidth(param1:Number) : void
      {
         this._maxInputWidth = param1;
         this.updatePosAndSize();
      }
      
      public function get privateChatName() : String
      {
         return this._privateChatName;
      }
      
      public function get privateUserID() : int
      {
         return this._userID;
      }
      
      public function get privateChatInfo() : Object
      {
         return this._privateChatInfo;
      }
      
      public function sendCurrnetText() : void
      {
         var _loc6_:int = 0;
         var _loc7_:Vector.<String> = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc1_:RegExp = /\/\S*\s?/;
         var _loc2_:Array = _loc1_.exec(this._inputField.text);
         var _loc3_:String = this._inputField.text.toLocaleLowerCase();
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(!PathManager.CROSSBUGGlLEBTNEnable())
         {
            this.CHANNEL_KEY_SET = ["d","x","w","g","p","s"];
         }
         if(_loc3_.indexOf("/") == 0)
         {
            _loc6_ = 0;
            while(_loc6_ < this.CHANNEL_KEY_SET.length)
            {
               if(_loc3_.indexOf("/" + this.CHANNEL_KEY_SET[_loc6_]) == 0)
               {
                  _loc4_ = true;
                  SoundManager.instance.play("008");
                  this._inputField.text = _loc3_.substring(2);
                  dispatchEvent(new ChatEvent(ChatEvent.INPUT_CHANNEL_CHANNGED,CHANNEL_SET[_loc6_]));
               }
               _loc6_++;
            }
            if(!_loc4_)
            {
               _loc7_ = ChatManager.Instance.model.customFastReply;
               _loc6_ = 0;
               while(_loc6_ < 5)
               {
                  if(_loc3_.indexOf("/" + String(_loc6_ + 1)) == 0 && (_loc3_.length == 2 || _loc3_.charAt(2) == " "))
                  {
                     _loc5_ = true;
                     if(_loc7_.length > _loc6_)
                     {
                        this._inputField.text = _loc7_[_loc6_];
                     }
                     else
                     {
                        this._inputField.text = "";
                     }
                     break;
                  }
                  _loc6_++;
               }
            }
            if(_loc2_ && !_loc4_ && !_loc5_)
            {
               _loc8_ = String(_loc2_[0]).replace(" ","");
               _loc8_ = _loc8_.replace("/","");
               if(_loc8_ == "")
               {
                  return;
               }
               this._inputField.text = this._inputField.text.replace(_loc1_,"");
               dispatchEvent(new ChatEvent(ChatEvent.CUSTOM_SET_PRIVATE_CHAT_TO,{
                  "channel":CHANNEL_SET[2],
                  "nickName":_loc8_
               }));
               return;
            }
         }
         if(_loc3_.substr(0,2) != "/" + this.CHANNEL_KEY_SET[2])
         {
            _loc9_ = this.parasMsgs(this._inputField.text);
            this._inputField.text = "";
            if(_loc9_ == "")
            {
               return;
            }
            dispatchEvent(new ChatEvent(ChatEvent.INPUT_TEXT_CHANGED,_loc9_));
         }
      }
      
      public function setFocus() : void
      {
         if(StageReferance.stage)
         {
            this.setTextFocus();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.__onAddToStage);
         }
      }
      
      public function setInputText(param1:String) : void
      {
         if(param1.indexOf("&lt;") > -1 || param1.indexOf("&gt;") > -1)
         {
            this._inputField.htmlText = param1;
         }
         else
         {
            this._inputField.text = param1;
         }
         this._inputField.setTextFormat(ChatFormats.getTextFormatByChannel(this._channel));
      }
      
      public function setPrivateChatName(param1:String, param2:int = 0, param3:Object = null) : void
      {
         var _loc4_:String = null;
         this.setTextFocus();
         if(this._privateChatName == param1)
         {
            return;
         }
         this._privateChatName = param1;
         this._userID = param2;
         this._privateChatInfo = param3;
         if(this._privateChatName != "")
         {
            _loc4_ = "";
            _loc4_ = this._privateChatName;
            this._nameTextField.htmlText = LanguageMgr.GetTranslation("tank.view.chat.ChatInput.usernameField.text",_loc4_);
         }
         else
         {
            this._nameTextField.text = "";
         }
         this.updatePosAndSize();
      }
      
      private function __onAddToStage(param1:Event) : void
      {
         this.setTextFocus();
         removeEventListener(Event.ADDED_TO_STAGE,arguments.callee);
      }
      
      private function __onFieldKeyDown(param1:KeyboardEvent) : void
      {
         if(this.isFocus())
         {
            param1.stopImmediatePropagation();
            param1.stopPropagation();
            if(param1.keyCode == Keyboard.UP)
            {
               --this.currentHistoryOffset;
               if(this.getHistoryChat(this.currentHistoryOffset) != "")
               {
                  this._inputField.htmlText = this.getHistoryChat(this.currentHistoryOffset);
                  this._inputField.setTextFormat(ChatFormats.getTextFormatByChannel(this._channel));
                  this._inputField.addEventListener(Event.ENTER_FRAME,this.__setSelectIndexSync);
               }
            }
            else if(param1.keyCode == Keyboard.DOWN)
            {
               ++this.currentHistoryOffset;
               this._inputField.text = this.getHistoryChat(this.currentHistoryOffset);
            }
         }
         if(param1.keyCode == Keyboard.ENTER && !ChatManager.Instance.chatDisabled)
         {
            if(this._inputField.text.substr(0,1) == "#")
            {
               DebugManager.getInstance().handle(this._inputField.text);
               this._inputField.text = "";
            }
            else if(this._inputField.text != "" && this.parasMsgs(this._inputField.text) != "" && ChatManager.Instance.input.parent != null)
            {
               if(this.isFocus())
               {
                  if(ChatManager.Instance.state != ChatManager.CHAT_SHOP_STATE)
                  {
                     SoundManager.instance.play("008");
                     this.sendCurrnetText();
                     this._currentHistoryOffset = ChatManager.Instance.model.resentChats.length;
                  }
               }
               else if(this.canUseKeyboardSetFocus())
               {
                  this.setFocus();
               }
            }
            else
            {
               ChatManager.Instance.switchVisible();
               if(this.canUseKeyboardSetFocus())
               {
                  ChatManager.Instance.setFocus();
               }
               if(ChatManager.Instance.visibleSwitchEnable)
               {
                  SoundManager.instance.play("008");
               }
            }
         }
         if(ChatManager.Instance.input.parent != null)
         {
            if(ChatManager.Instance.visibleSwitchEnable)
            {
               IMEManager.enable();
            }
         }
      }
      
      private function canUseKeyboardSetFocus() : Boolean
      {
         if(!ChatManager.Instance.focusFuncEnabled)
         {
            return false;
         }
         if(ChatManager.Instance.input.parent != null && (ChatManager.Instance.state == ChatManager.CHAT_GAME_STATE || ChatManager.Instance.state == ChatManager.CHAT_GAMEOVER_STATE))
         {
            return true;
         }
         if(ChatManager.Instance.input.parent != null && StageReferance.stage.focus == null)
         {
            return true;
         }
         return false;
      }
      
      private function __onInputFieldChange(param1:Event) : void
      {
         if(this._inputField.text)
         {
            this._inputField.text = this._inputField.text.replace("\n","").replace("\r","");
         }
      }
      
      private function __setSelectIndexSync(param1:Event) : void
      {
         this._inputField.removeEventListener(Event.ENTER_FRAME,this.__setSelectIndexSync);
         this._inputField.setSelection(this._inputField.text.length,this._inputField.text.length);
      }
      
      private function get currentHistoryOffset() : int
      {
         return this._currentHistoryOffset;
      }
      
      private function set currentHistoryOffset(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > ChatManager.Instance.model.resentChats.length - 1)
         {
            param1 = ChatManager.Instance.model.resentChats.length - 1;
         }
         this._currentHistoryOffset = param1;
      }
      
      private function getHistoryChat(param1:int) : String
      {
         if(param1 == -1)
         {
            return "";
         }
         return Helpers.deCodeString(ChatManager.Instance.model.resentChats[param1].msg);
      }
      
      private function initView() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("chat.InputFieldTextFieldStartPos");
         this._nameTextField = new TextField();
         this._nameTextField.type = TextFieldType.DYNAMIC;
         this._nameTextField.mouseEnabled = false;
         this._nameTextField.selectable = false;
         this._nameTextField.autoSize = TextFieldAutoSize.LEFT;
         this._nameTextField.x = _loc1_.x;
         this._nameTextField.y = _loc1_.y;
         addChild(this._nameTextField);
         this._inputField = new TextField();
         this._inputField.type = TextFieldType.INPUT;
         this._inputField.autoSize = TextFieldAutoSize.NONE;
         this._inputField.multiline = false;
         this._inputField.wordWrap = false;
         this._inputField.maxChars = INPUT_MAX_CHAT;
         this._inputField.x = _loc1_.x;
         this._inputField.y = _loc1_.y;
         this._inputField.height = 20;
         addChild(this._inputField);
         this._inputField.addEventListener(Event.CHANGE,this.__onInputFieldChange);
         this.setTextFormat(new TextFormat("Arial",12,65280));
         this.updatePosAndSize();
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__onFieldKeyDown,false,int.MAX_VALUE);
      }
      
      private function parasMsgs(param1:String) : String
      {
         var _loc2_:String = param1;
         _loc2_ = StringHelper.trim(_loc2_);
         _loc2_ = FilterWordManager.filterWrod(_loc2_);
         return StringHelper.rePlaceHtmlTextField(_loc2_);
      }
      
      private function setTextFocus() : void
      {
         StageReferance.stage.focus = this._inputField;
         this._inputField.setSelection(this._inputField.text.length,this._inputField.text.length);
      }
      
      private function setTextFormat(param1:TextFormat) : void
      {
         this._nameTextField.defaultTextFormat = param1;
         this._nameTextField.setTextFormat(param1);
         this._inputField.defaultTextFormat = param1;
         this._inputField.setTextFormat(param1);
      }
      
      private function updatePosAndSize() : void
      {
         this._inputField.x = 70 + this._nameTextField.textWidth;
         if(this._nameTextField.textWidth > this._maxInputWidth)
         {
            return;
         }
         this._inputField.width = this._maxInputWidth - this._nameTextField.textWidth;
      }
   }
}
