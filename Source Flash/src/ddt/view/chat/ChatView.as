package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import flash.display.Sprite;
   
   use namespace chat_system;
   
   public class ChatView extends Sprite
   {
       
      
      private var _input:ChatInputView;
      
      private var _output:ChatOutputView;
      
      private var _state:int = -1;
      
      private var _stateArr:Vector.<ChatViewInfo>;
      
      public function ChatView()
      {
         super();
         this.init();
      }
      
      public function get input() : ChatInputView
      {
         return this._input;
      }
      
      public function get output() : ChatOutputView
      {
         return this._output;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      private function updateViewState(param1:int) : void
      {
         if(param1 == ChatManager.CHAT_TRAINER_STATE)
         {
            ChatManager.Instance.view.parent.removeChild(ChatManager.Instance.view);
         }
         if(param1 != ChatManager.CHAT_GAMEOVER_STATE)
         {
            if(this._stateArr[param1].inputVisible)
            {
               addChild(this._input);
            }
            else if(this._input.parent)
            {
               this._input.parent.removeChild(this._input);
            }
         }
         this._input.faceEnabled = this._stateArr[param1].inputFaceEnabled;
         this._input.x = this._stateArr[param1].inputX;
         this._input.y = this._stateArr[param1].inputY;
         ChatManager.Instance.visibleSwitchEnable = this._stateArr[param1].inputVisibleSwitchEnabled;
         this._output.isLock = this._stateArr[param1].outputIsLock;
         this._output.lockEnable = this._stateArr[param1].outputLockEnabled;
         this._output.bg = this._stateArr[param1].outputBackground;
         this._output.contentField.style = this._stateArr[param1].outputContentFieldStyle;
         if(this._stateArr[param1].outputChannel != -1)
         {
            this._output.channel = this._stateArr[param1].outputChannel;
         }
         this._output.x = this._stateArr[param1].outputX;
         this._output.y = this._stateArr[param1].outputY;
         if(this._state == ChatManager.CHAT_GAME_STATE)
         {
            this._input.enableGameState = true;
            this._output.enableGameState = true;
            this._output.functionEnabled = false;
         }
         else
         {
            this._output.enableGameState = false;
         }
         this._output.updateCurrnetChannel();
      }
      
      public function set state(param1:int) : void
      {
         if(this._state == param1)
         {
            return;
         }
         if(this._state == ChatManager.CHAT_GAME_STATE)
         {
            this._input.enableGameState = false;
            this._output.enableGameState = false;
         }
         var _loc2_:int = this._state;
         this._state = param1;
         this._output.contentField.contentWidth = ChatOutputField.NORMAL_WIDTH;
         ChatManager.Instance.setFocus();
         this._input.hidePanel();
         this.updateViewState(this._state);
         this._output.setChannelBtnVisible(!this._output.isLock);
         this._output.setLockBtnTipData(this._output.isLock);
      }
      
      private function init() : void
      {
         var _loc2_:ChatViewInfo = null;
         var _loc3_:XML = null;
         this._input = ComponentFactory.Instance.creatCustomObject("chat.InputView");
         this._output = ComponentFactory.Instance.creatCustomObject("chat.OutputView");
         this._stateArr = new Vector.<ChatViewInfo>();
         var _loc1_:int = 0;
         while(_loc1_ <= 30)
         {
            _loc2_ = new ChatViewInfo();
            _loc3_ = ComponentFactory.Instance.getCustomStyle("chatViewInfo.state_" + String(_loc1_));
            if(!_loc3_)
            {
               this._stateArr.push(_loc2_);
            }
            else
            {
               ObjectUtils.copyPorpertiesByXML(_loc2_,_loc3_);
               this._stateArr.push(_loc2_);
            }
            _loc1_++;
         }
         addChild(this._output);
         addChild(this._input);
      }
   }
}
