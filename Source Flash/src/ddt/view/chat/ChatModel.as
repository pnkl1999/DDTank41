package ddt.view.chat
{
   import cardSystem.data.CardInfo;
   import com.pickgliss.utils.StringUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.FilterWordManager;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public final class ChatModel extends EventDispatcher
   {
      
      private static const OVERCOUNT:int = 200;
       
      
      private var _clubChats:Array;
      
      private var _currentChats:Array;
      
      private var _privateChats:Array;
      
      private var _resentChats:Array;
      
      private var _linkInfoMap:Dictionary;
      
      private var _customFastReply:Vector.<String>;
      
      public function ChatModel()
      {
         super();
         this.reset();
      }
      
      public function addChat(param1:ChatData) : void
      {
         this.tryAddToCurrentChats(param1);
         this.tryAddToRecent(param1);
         this.tryAddToClubChats(param1);
         this.tryAddToPrivateChats(param1);
         param1.htmlMessage = FilterWordManager.filterWrodFromServer(param1.htmlMessage);
         dispatchEvent(new ChatEvent(ChatEvent.ADD_CHAT,param1));
      }
      
      public function get customFastReply() : Vector.<String>
      {
         return this._customFastReply;
      }
      
      public function addLink(param1:String, param2:ItemTemplateInfo) : void
      {
         this._linkInfoMap[param1] = param2;
      }
      
      public function addLinkCardInfo(param1:String, param2:CardInfo) : void
      {
         this._linkInfoMap[param1] = param2;
      }
      
      public function getLink(param1:String) : ItemTemplateInfo
      {
         return this._linkInfoMap[param1];
      }
      
      public function getLinkCardInfo(param1:String) : CardInfo
      {
         return this._linkInfoMap[param1];
      }
      
      public function removeAllLink() : void
      {
         this._linkInfoMap = new Dictionary();
      }
      
      public function getRowsByOutputChangel(param1:int) : int
      {
         return param1 == ChatOutputView.CHAT_OUPUT_CURRENT ? int(int(this._currentChats.length)) : (param1 == ChatOutputView.CHAT_OUPUT_CLUB ? int(int(this._clubChats.length)) : int(int(this._privateChats.length)));
      }
      
      public function getChatsByOutputChannel(param1:int, param2:int, param3:int) : Object
      {
         param2 = param2 < 0 ? int(int(0)) : int(int(param2));
         var _loc4_:Array = [];
         if(param1 == ChatOutputView.CHAT_OUPUT_CURRENT)
         {
            _loc4_ = this._currentChats;
         }
         else if(param1 == ChatOutputView.CHAT_OUPUT_CLUB)
         {
            _loc4_ = this._clubChats;
         }
         else if(param1 == ChatOutputView.CHAT_OUPUT_PRIVATE)
         {
            _loc4_ = this._privateChats;
         }
         if(_loc4_.length <= param3)
         {
            return {
               "offset":0,
               "result":_loc4_
            };
         }
         if(_loc4_.length <= param3 + param2)
         {
            return {
               "offset":_loc4_.length - param3,
               "result":_loc4_.slice(0,param3)
            };
         }
         return {
            "offset":param2,
            "result":_loc4_.slice(_loc4_.length - param3 - param2,_loc4_.length - param2)
         };
      }
      
      public function getInputInOutputChannel(param1:int, param2:int) : Boolean
      {
         if(param2 == ChatOutputView.CHAT_OUPUT_CLUB)
         {
            switch(param1)
            {
               case ChatInputView.CONSORTIA:
               case ChatInputView.SYS_NOTICE:
               case ChatInputView.SYS_TIP:
               case ChatInputView.BIG_BUGLE:
               case ChatInputView.SMALL_BUGLE:
               case ChatInputView.DEFY_AFFICHE:
               case ChatInputView.CROSS_NOTICE:
                  return true;
            }
         }
         else if(param2 == ChatOutputView.CHAT_OUPUT_PRIVATE)
         {
            switch(param1)
            {
               case ChatInputView.PRIVATE:
               case ChatInputView.SYS_NOTICE:
               case ChatInputView.SYS_TIP:
               case ChatInputView.BIG_BUGLE:
               case ChatInputView.SMALL_BUGLE:
               case ChatInputView.DEFY_AFFICHE:
               case ChatInputView.CROSS_NOTICE:
                  return true;
            }
         }
         else if(param2 == ChatOutputView.CHAT_OUPUT_CURRENT)
         {
            return true;
         }
         return false;
      }
      
      public function reset() : void
      {
         this._currentChats = [];
         this._clubChats = [];
         this._privateChats = [];
         this._resentChats = [];
         this._customFastReply = new Vector.<String>();
         this._linkInfoMap = new Dictionary();
      }
      
      public function get clubChats() : Array
      {
         return this._clubChats;
      }
      
      public function get currentChats() : Array
      {
         return this._currentChats;
      }
      
      public function get privateChats() : Array
      {
         return this._privateChats;
      }
      
      public function get resentChats() : Array
      {
         return this._resentChats;
      }
      
      private function checkOverCount(param1:Array) : void
      {
         if(param1.length > OVERCOUNT)
         {
            param1.shift();
         }
      }
      
      private function tryAddToClubChats(param1:ChatData) : void
      {
         if(this.getInputInOutputChannel(param1.channel,ChatOutputView.CHAT_OUPUT_CLUB))
         {
            this._clubChats.push(param1);
         }
         this.checkOverCount(this._clubChats);
      }
      
      private function tryAddToCurrentChats(param1:ChatData) : void
      {
         this._currentChats.push(param1);
         this.checkOverCount(this._currentChats);
      }
      
      private function tryAddToPrivateChats(param1:ChatData) : void
      {
         if(this.getInputInOutputChannel(param1.channel,ChatOutputView.CHAT_OUPUT_PRIVATE))
         {
            this._privateChats.push(param1);
            if(PlayerManager.Instance.Self.playerState.AutoReply != "" && !StringUtils.isEmpty(param1.sender) && param1.receiver == PlayerManager.Instance.Self.NickName && param1.isAutoReply == false)
            {
               ChatManager.Instance.sendPrivateMessage(param1.sender,FilterWordManager.filterWrod(PlayerManager.Instance.Self.playerState.AutoReply),param1.senderID,true);
            }
         }
         this.checkOverCount(this._privateChats);
      }
      
      private function tryAddToRecent(param1:ChatData) : void
      {
         if(param1.sender == PlayerManager.Instance.Self.NickName)
         {
            this._resentChats.push(param1);
         }
         this.checkOverCount(this._resentChats);
      }
   }
}
