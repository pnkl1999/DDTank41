package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ChatChannelPanel extends ChatBasePanel
   {
       
      
      private var _bg:Bitmap;
      
      private var _channelBtns:Vector.<BaseButton>;
      
      private var _currentChannel:Object;
      
      private const chanelMap:Array = [0,1,2,3,4,5,15];
      
      public function ChatChannelPanel()
      {
         this._channelBtns = new Vector.<BaseButton>();
         this._currentChannel = new Object();
         super();
      }
      
      private function __itemClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new ChatEvent(ChatEvent.INPUT_CHANNEL_CHANNGED,this._currentChannel[(param1.target as BaseButton).backStyle]));
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.ChannelPannelBg");
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_BigBuggleBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_SmallBuggleBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_PrivateBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_ConsortiaBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_TeamBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_CurrentBtn"));
         if(PathManager.CROSSBUGGlLEBTNEnable())
         {
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_CrossBuggleBtn"));
         }
         else
         {
            this._bg.height -= 20;
            this._bg.y += 20;
         }
         addChild(this._bg);
         var _loc1_:uint = 0;
         while(_loc1_ < this._channelBtns.length)
         {
            this._channelBtns[_loc1_].addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            this._currentChannel[this._channelBtns[_loc1_].backStyle] = this.chanelMap[_loc1_];
            addChild(this._channelBtns[_loc1_]);
            _loc1_++;
         }
      }
   }
}
