package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionPollInfo;
   import consortion.event.ConsortionEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ConsortionPollFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _vote:BaseButton;
      
      private var _help:BaseButton;
      
      private var _mark:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _items:Vector.<ConsortionPollItem>;
      
      private var _currentItem:ConsortionPollItem;
      
      private var _helpFrame:Frame;
      
      private var _helpContent:Bitmap;
      
      private var _helpClose:TextButton;
      
      public function ConsortionPollFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.consortion.pollFrame.title");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortion.pollFrame.bg");
         this._vote = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.vote");
         this._help = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.help");
         this._mark = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.mark");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.vbox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.panel");
         addToContent(this._bg);
         addToContent(this._vote);
         addToContent(this._help);
         addToContent(this._mark);
         addToContent(this._panel);
         this._panel.setView(this._vbox);
         this.dataList = ConsortionModelControl.Instance.model.pollList;
         this._mark.text = LanguageMgr.GetTranslation("ddt.consortion.pollFrame.continueDay",PlayerManager.Instance.Self.consortiaInfo.VoteRemainDay);
         if(PlayerManager.Instance.Self.Riches < 100 || ConsortionModelControl.Instance.model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).IsVote)
         {
            this._vote.enable = false;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._vote.addEventListener(MouseEvent.CLICK,this.__voteHandler);
         this._help.addEventListener(MouseEvent.CLICK,this.__helpHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.POLL_LIST_CHANGE,this.__pollListChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.POLL_CANDIDATE,this.__consortiaPollHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._vote.removeEventListener(MouseEvent.CLICK,this.__voteHandler);
         this._help.removeEventListener(MouseEvent.CLICK,this.__helpHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.POLL_LIST_CHANGE,this.__pollListChange);
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            _loc1_++;
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.POLL_CANDIDATE,this.__consortiaPollHandler);
      }
      
      private function __consortiaPollHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.pollFrame.success"));
            ConsortionModelControl.Instance.model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).IsVote = true;
            this.dispose();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.pollFrame.fail"));
            this._vote.enable = true;
         }
      }
      
      private function __pollListChange(param1:ConsortionEvent) : void
      {
         this.dataList = ConsortionModelControl.Instance.model.pollList;
      }
      
      private function clearList() : void
      {
         var _loc1_:int = 0;
         if(this._items)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               this._items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
               this._items[_loc1_].dispose();
               this._items[_loc1_] = null;
               _loc1_++;
            }
         }
         this._items = new Vector.<ConsortionPollItem>();
      }
      
      private function set dataList(param1:Vector.<ConsortionPollInfo>) : void
      {
         var _loc3_:ConsortionPollItem = null;
         this.clearList();
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new ConsortionPollItem();
            _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            _loc3_.info = param1[_loc2_];
            this._items.push(_loc3_);
            this._vbox.addChild(_loc3_);
            _loc2_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function __itemClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentItem = param1.currentTarget as ConsortionPollItem;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            if(this._currentItem == this._items[_loc2_])
            {
               this._items[_loc2_].selected = true;
            }
            else
            {
               this._items[_loc2_].selected = false;
            }
            _loc2_++;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __voteHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._currentItem == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.pollFrame.pleaseSelceted"));
            return;
         }
         if(ConsortionModelControl.Instance.model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).IsVote)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.pollFrame.double"));
            return;
         }
         SocketManager.Instance.out.sendConsortionPoll(this._currentItem.info.pollID);
         this._vote.enable = false;
      }
      
      private function __helpHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.helpFrame");
         this._helpContent = ComponentFactory.Instance.creatBitmap("asset.consortion.pollFrame.explain");
         this._helpClose = ComponentFactory.Instance.creatComponentByStylename("consortion.pollFrame.helpFrame.close");
         this._helpFrame.addToContent(this._helpContent);
         this._helpFrame.addToContent(this._helpClose);
         this._helpFrame.escEnable = true;
         this._helpFrame.disposeChildren = true;
         this._helpFrame.titleText = LanguageMgr.GetTranslation("ddt.consortion.pollFrame.helpFrame.title");
         this._helpClose.text = LanguageMgr.GetTranslation("close");
         this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpResoponseHandler);
         this._helpClose.addEventListener(MouseEvent.CLICK,this.__closeHelpHandler);
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __helpResoponseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.helpDispose();
         }
      }
      
      private function __closeHelpHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.helpDispose();
      }
      
      private function helpDispose() : void
      {
         this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpResoponseHandler);
         this._helpClose.removeEventListener(MouseEvent.CLICK,this.__closeHelpHandler);
         this._helpFrame.dispose();
         this._helpContent = null;
         this._helpClose = null;
         if(this._helpFrame.parent)
         {
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearList();
         super.dispose();
         this._bg = null;
         this._vote = null;
         this._help = null;
         this._mark = null;
         this._vbox = null;
         this._panel = null;
         this._items = null;
         this._currentItem = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
