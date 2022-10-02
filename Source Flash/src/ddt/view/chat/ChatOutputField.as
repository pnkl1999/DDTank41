package ddt.view.chat
{
   import cardSystem.data.CardInfo;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.EffortManager;
   import ddt.manager.IMEManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import ddt.view.tips.CardBoxTipPanel;
   import ddt.view.tips.CardsTipPanel;
   import ddt.view.tips.GoodTip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import im.IMController;
   import im.IMView;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import lanternriddles.LanternRiddlesManager;
   import ddt.manager.MessageTipManager;
   import bagAndInfo.BagAndInfoManager;
   
   use namespace chat_system;
   
   public class ChatOutputField extends Sprite
   {
      
      public static const GAME_STYLE:String = "GAME_STYLE";
      
      public static const GAME_WIDTH:int = 288;
      
      public static const GAME_HEIGHT:int = 106;
      
      public static const NORMAL_WIDTH:int = 420;
      
      public static const NORMAL_HEIGHT:int = 128;
      
      public static const NORMAL_STYLE:String = "NORMAL_STYLE";
      
      private static var _style:String = "";
       
      
      private var _contentField:TextField;
      
      private var _nameTip:ChatNamePanel;
      
      private var _goodTip:GoodTip;
      
      private var _cardboxTip:CardBoxTipPanel;
      
      private var _cardTipPnl:CardsTipPanel;
      
      private var _goodTipPos:Sprite;
      
      private var _srcollRect:Rectangle;
      
      private var _tipStageClickCount:int = 0;
      
      private var isStyleChange:Boolean = false;
      
      private var t_text:String;
      
      private var _functionEnabled:Boolean;
      
      public function ChatOutputField()
      {
         this._goodTipPos = new Sprite();
         super();
         this.style = NORMAL_STYLE;
      }
      
      public function set functionEnabled(param1:Boolean) : void
      {
         this._functionEnabled = param1;
      }
      
      public function set contentWidth(param1:Number) : void
      {
         this._contentField.width = param1;
         this.updateScrollRect(param1,NORMAL_HEIGHT);
      }
      
      public function set contentHeight(param1:Number) : void
      {
         this._contentField.height = param1;
         this.updateScrollRect(NORMAL_WIDTH,param1);
      }
      
      public function isBottom() : Boolean
      {
         return this._contentField.scrollV == this._contentField.maxScrollV;
      }
      
      public function get scrollOffset() : int
      {
         return this._contentField.maxScrollV - this._contentField.scrollV;
      }
      
      public function set scrollOffset(param1:int) : void
      {
         this._contentField.scrollV = this._contentField.maxScrollV - param1;
         this.onScrollChanged();
      }
      
      public function setChats(param1:Array) : void
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_].htmlMessage;
            _loc3_++;
         }
         this._contentField.htmlText = _loc2_;
      }
      
      public function toBottom() : void
      {
         Helpers.delayCall(this.__delayCall);
         this._contentField.scrollV = int.MAX_VALUE;
         this.onScrollChanged();
      }
      
      chat_system function get goodTipPos() : Point
      {
         return new Point(this._goodTipPos.x,this._goodTipPos.y);
      }
      
      chat_system function showLinkGoodsInfo(param1:ItemTemplateInfo, param2:uint = 0, param3:CardInfo = null) : void
      {
         if(param1.CategoryID == EquipType.CARDBOX)
         {
            if(this._cardboxTip == null)
            {
               this._cardboxTip = new CardBoxTipPanel();
            }
            this._cardboxTip.tipData = param1;
            this.setTipPos(this._cardboxTip);
            StageReferance.stage.addChild(this._cardboxTip);
         }
         else if(param1.CategoryID == EquipType.CARDEQUIP)
         {
            if(!this._cardTipPnl)
            {
               this._cardTipPnl = new CardsTipPanel();
            }
            this._cardTipPnl.tipData = param3;
            this.setTipPos(this._cardTipPnl);
            StageReferance.stage.addChild(this._cardTipPnl);
         }
         else
         {
            if(this._goodTip == null)
            {
               this._goodTip = new GoodTip();
            }
            this._goodTip.showTip(param1);
            this.setTipPos(this._goodTip);
            StageReferance.stage.addChild(this._goodTip);
         }
         if(this._nameTip && this._nameTip.parent)
         {
            this._nameTip.parent.removeChild(this._nameTip);
         }
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
         this._tipStageClickCount = param2;
      }
      
      private function setTipPos(param1:Object) : void
      {
         param1.x = this._goodTipPos.x;
         param1.y = this._goodTipPos.y - param1.height - 10;
         if(param1.y < 0)
         {
            param1.y = 10;
         }
      }
      
      chat_system function set style(param1:String) : void
      {
         if(_style != param1)
         {
            _style = param1;
            this.disposeView();
            this.initView();
            this.initEvent();
            switch(param1)
            {
               case NORMAL_STYLE:
                  this._contentField.styleSheet = ChatFormats.styleSheet;
                  this._contentField.width = NORMAL_WIDTH;
                  this._contentField.height = NORMAL_HEIGHT;
                  break;
               case GAME_STYLE:
                  this._contentField.styleSheet = ChatFormats.gameStyleSheet;
                  this._contentField.width = GAME_WIDTH;
                  this._contentField.height = GAME_HEIGHT;
            }
            this._contentField.htmlText = this.t_text || "";
         }
      }
      
      private function __delayCall() : void
      {
         this._contentField.scrollV = this._contentField.maxScrollV;
         this.onScrollChanged();
         removeEventListener(Event.ENTER_FRAME,this.__delayCall);
      }
      
      private function __onScrollChanged(param1:Event) : void
      {
         this.onScrollChanged();
      }
      
      private function __onTextClicked(param1:TextEvent) : void
      {
         var _loc2_:Object = null;
         var _loc4_:Point = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:RegExp = null;
         var _loc12_:String = null;
         var _loc13_:Object = null;
         var _loc14_:Rectangle = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Point = null;
         var _loc18_:int = 0;
         var _loc19_:Point = null;
         var _loc20_:ItemTemplateInfo = null;
         var _loc21_:ItemTemplateInfo = null;
         var _loc22_:CardInfo = null;
         SoundManager.instance.play("008");
         this.__stageClickHandler();
         _loc2_ = {};
         var _loc3_:Array = param1.text.split("|");
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_].indexOf(":"))
            {
               _loc6_ = _loc3_[_loc5_].split(":");
               _loc2_[_loc6_[0]] = _loc6_[1];
            }
            _loc5_++;
         }
         if(int(_loc2_.clicktype) == ChatFormats.CLICK_CHANNEL)
         {
            ChatManager.Instance.inputChannel = int(_loc2_.channel);
            ChatManager.Instance.output.functionEnabled = true;
         }
         else if(int(_loc2_.clicktype) == ChatFormats.CLICK_USERNAME)
         {
            _loc7_ = PlayerManager.Instance.Self.ZoneID;
            _loc8_ = _loc2_.zoneID;
            if(_loc8_ > 0 && _loc8_ != _loc7_)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
               return;
            }
            if(IMView.IS_SHOW_SUB)
            {
               dispatchEvent(new ChatEvent(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,_loc2_.tagname));
            }
            if(IMController.Instance.isFriend(String(_loc2_.tagname)))
            {
               IMEManager.enable();
               ChatManager.Instance.output.functionEnabled = true;
               ChatManager.Instance.privateChatTo(_loc2_.tagname);
            }
            else
            {
               if(this._nameTip == null)
               {
                  this._nameTip = ComponentFactory.Instance.creatCustomObject("chat.NamePanel");
               }
               _loc9_ = String(_loc2_.tagname);
               _loc10_ = _loc9_.indexOf("$");
               if(_loc10_ > -1)
               {
                  _loc9_ = _loc9_.substr(0,_loc10_);
               }
               _loc11_ = new RegExp(_loc9_,"g");
               _loc12_ = this._contentField.text;
               _loc13_ = _loc11_.exec(_loc12_);
               while(_loc13_ != null)
               {
                  _loc15_ = _loc13_.index;
                  _loc16_ = _loc15_ + String(_loc2_.tagname).length;
                  _loc17_ = this._contentField.globalToLocal(new Point(StageReferance.stage.mouseX,StageReferance.stage.mouseY));
                  _loc18_ = this._contentField.getCharIndexAtPoint(_loc17_.x,_loc17_.y);
                  if(_loc18_ >= _loc15_ && _loc18_ <= _loc16_)
                  {
                     this._contentField.setSelection(_loc15_,_loc16_);
                     _loc14_ = this._contentField.getCharBoundaries(_loc16_);
                     _loc19_ = this._contentField.localToGlobal(new Point(_loc14_.x,_loc14_.y));
                     this._nameTip.x = _loc19_.x + _loc14_.width;
                     this._nameTip.y = _loc19_.y - this._nameTip.getHeight - (this._contentField.scrollV - 1) * 18;
                     break;
                  }
                  _loc13_ = _loc11_.exec(_loc12_);
               }
               this._nameTip.playerName = String(_loc2_.tagname);
               if(this._goodTip && this._goodTip.parent)
               {
                  this._goodTip.parent.removeChild(this._goodTip);
               }
               if(this._cardTipPnl && this._cardTipPnl.parent)
               {
                  this._cardTipPnl.parent.removeChild(this._cardTipPnl);
               }
               this._nameTip.setVisible = true;
               ChatManager.Instance.privateChatTo(_loc2_.tagname);
            }
         }
         else if(int(_loc2_.clicktype) == ChatFormats.CLICK_GOODS)
         {
            _loc4_ = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            this._goodTipPos.x = _loc4_.x;
            this._goodTipPos.y = _loc4_.y;
            _loc20_ = ItemManager.Instance.getTemplateById(_loc2_.templeteIDorItemID);
            _loc20_.BindType = _loc2_.isBind == "true" ? int(int(0)) : int(int(1));
            this.showLinkGoodsInfo(_loc20_);
         }
         else if(int(_loc2_.clicktype) == ChatFormats.CLICK_INVENTORY_GOODS)
         {
            _loc7_ = PlayerManager.Instance.Self.ZoneID;
            _loc8_ = _loc2_.zoneID;
            if(_loc8_ > 0 && _loc8_ != _loc7_)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.ViewGoodInfoUnable"));
               return;
            }
            _loc4_ = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            this._goodTipPos.x = _loc4_.x;
            this._goodTipPos.y = _loc4_.y;
            if(_loc2_.key != "null")
            {
               if(_loc2_.type == String(20) || _loc2_.type == String(18))
               {
                  _loc22_ = ChatManager.Instance.model.getLinkCardInfo(_loc2_.key);
               }
               else
               {
                  _loc21_ = ChatManager.Instance.model.getLink(_loc2_.key);
               }
            }
            else
            {
               _loc21_ = ChatManager.Instance.model.getLink(_loc2_.templeteIDorItemID);
            }
            if(_loc21_ || _loc22_)
            {
               if(_loc21_)
               {
                  this.showLinkGoodsInfo(_loc21_);
               }
               if(_loc22_)
               {
                  this.showLinkGoodsInfo(_loc22_.templateInfo,0,_loc22_);
               }
            }
            else if(_loc2_.key != "null")
            {
               if(_loc2_.type == String(20) || _loc2_.type == String(18))
               {
                  SocketManager.Instance.out.sendGetLinkGoodsInfo(4,String(_loc2_.key));
               }
               else
               {
                  SocketManager.Instance.out.sendGetLinkGoodsInfo(3,String(_loc2_.key));
               }
            }
            else
            {
               SocketManager.Instance.out.sendGetLinkGoodsInfo(2,String(_loc2_.templeteIDorItemID));
            }
         }
         else if(int(_loc2_.clicktype) == ChatFormats.CLICK_DIFF_ZONE)
         {
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.view.chatFormat.cross"));
         }
         else if(int(_loc2_.clicktype) == ChatFormats.CLICK_EFFORT)
         {
            if(!EffortManager.Instance.getMainFrameVisible())
            {
               EffortManager.Instance.isSelf = true;
               EffortManager.Instance.switchVisible();
            }
         }
		 else if(int(_loc2_.clicktype) == ChatFormats.CLICK_LANTERN_BEGIN)
		 {
			 if(StateManager.currentStateType == StateType.MAIN)
			 {
				 if(LanternRiddlesManager.instance.isBegin)
				 {
					 LanternRiddlesManager.instance.show();
				 }
				 else
				 {
					 MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.activityExpired"));
				 }
			 }
			 else
			 {
				 MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.openTips"));
			 }
		 }
		 else if(int(_loc2_.clicktype) == ChatFormats.CLICK_TIME_GIFTPACK)
		 {
			 if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.ROOM_LIST)
			 {
				 BagAndInfoManager.Instance.showBagAndInfo();
			 }
			 else
			 {
				 MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.getRewardTip"));
			 }
		 }
      }
      
      private function __stageClickHandler(param1:MouseEvent = null) : void
      {
         if(param1)
         {
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         }
         if(this._tipStageClickCount > 0)
         {
            if(this._goodTip && this._goodTip.parent)
            {
               this._goodTip.parent.removeChild(this._goodTip);
            }
            if(this._cardTipPnl && this._cardTipPnl.parent)
            {
               this._cardTipPnl.parent.removeChild(this._cardTipPnl);
            }
            if(this._cardboxTip && this._cardboxTip.parent)
            {
               this._cardboxTip.parent.removeChild(this._cardboxTip);
            }
            if(StageReferance.stage)
            {
               StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClickHandler);
            }
         }
         else
         {
            ++this._tipStageClickCount;
         }
      }
      
      private function disposeView() : void
      {
         if(this._contentField)
         {
            this.t_text = this._contentField.htmlText;
            removeChild(this._contentField);
         }
      }
      
      private function initEvent() : void
      {
         this._contentField.addEventListener(Event.SCROLL,this.__onScrollChanged);
         this._contentField.addEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      private function initView() : void
      {
         this._contentField = new TextField();
         this._contentField.multiline = true;
         this._contentField.wordWrap = true;
         this._contentField.filters = [new GlowFilter(0,1,4,4,8)];
         this._contentField.mouseWheelEnabled = false;
         Helpers.setTextfieldFormat(this._contentField,{"size":12});
         this.updateScrollRect(NORMAL_WIDTH,NORMAL_HEIGHT);
         addChild(this._contentField);
      }
      
      private function onScrollChanged() : void
      {
         dispatchEvent(new ChatEvent(ChatEvent.SCROLL_CHANG));
      }
      
      private function updateScrollRect(param1:Number, param2:Number) : void
      {
         this._srcollRect = new Rectangle(0,0,param1,param2);
         this._contentField.scrollRect = this._srcollRect;
      }
   }
}
