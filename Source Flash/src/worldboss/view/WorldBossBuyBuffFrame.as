package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import worldboss.WorldBossManager;
   import worldboss.model.WorldBossBuffInfo;
   
   public class WorldBossBuyBuffFrame extends Sprite implements Disposeable
   {
      
      public static var IsAutoShow:Boolean = true;
      
      private static var _autoBuyBuffItem:DictionaryData = new DictionaryData();
       
      
      private var _notAgainBtn:SelectedCheckButton;
      
      private var _selectedArr:Array;
      
      private var _cartList:VBox;
      
      private var _cartScroll:ScrollPanel;
      
      private var _frame:Frame;
      
      private var _innerBg:Image;
      
      private var _moneyTip:FilterFrameText;
      
      private var _moneyBg:Image;
      
      private var _money:FilterFrameText;
      
      private var _bottomBg:Image;
      
      public function WorldBossBuyBuffFrame()
      {
         this._selectedArr = new Array();
         super();
         this.init();
         this.addEvent();
      }
      
      private function drawFrame() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBuffFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("worldboss.buyBuff.FrameTitle");
         addChild(this._frame);
      }
      
      private function drawItemCountField() : void
      {
         this._notAgainBtn = ComponentFactory.Instance.creatComponentByStylename("worldbossnotAgainBtn");
         this._notAgainBtn.text = LanguageMgr.GetTranslation("worldboss.buyBuff.NotAgain");
         this._notAgainBtn.selected = !IsAutoShow;
         this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBuffFrame.bottomBg");
         //this._moneyBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.TicketTextBg");
		 this._moneyBg = ComponentFactory.Instance.creatComponentByStylename("shop.CheckOutViewBottomItemBgMoney");
         PositionUtils.setPos(this._moneyBg,"worldboss.buyBuffFrame.moneyBg");
         //this._money = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PlayerMoney");
		 this._money = ComponentFactory.Instance.creatComponentByStylename("shop.PlayerMoney");
         PositionUtils.setPos(this._money,"worldboss.buyBuffFrame.money");
         this._money.text = PlayerManager.Instance.Self.Money.toString();
         this._moneyTip = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBUffFrame.moneyTip");
         this._moneyTip.text = LanguageMgr.GetTranslation("worldboss.buyBuff.moneyTip");
         this._frame.addToContent(this._notAgainBtn);
         this._frame.addToContent(this._bottomBg);
         this._frame.addToContent(this._moneyBg);
         this._frame.addToContent(this._money);
         this._frame.addToContent(this._moneyTip);
      }
      
      protected function drawPayListField() : void
      {
         this._innerBg = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBuffFrameBg");
         this._frame.addToContent(this._innerBg);
      }
      
      protected function init() : void
      {
         this._cartList = new VBox();
         this.drawFrame();
         this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuffItemList");
         this._cartScroll.setView(this._cartList);
         this._cartScroll.vScrollProxy = ScrollPanel.ON;
         this._cartList.spacing = 5;
         this._cartList.strictSize = 80;
         this._cartList.isReverAdd = true;
         this.drawPayListField();
         this._frame.addToContent(this._cartScroll);
         this.drawItemCountField();
         this.setList();
      }
      
      private function setList() : void
      {
         var _loc3_:BuffCartItem = null;
         var _loc1_:Array = WorldBossManager.Instance.bossInfo.buffArray;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = new BuffCartItem();
            _loc3_.buffItemInfo = _loc1_[_loc2_] as WorldBossBuffInfo;
            this._cartList.addChild(_loc3_);
            this._selectedArr.push(_loc3_);
            _loc3_.selected(_autoBuyBuffItem.hasKey(_loc3_.buffID));
            _loc3_.addEventListener(Event.SELECT,this.__itemSelected);
            _loc2_++;
         }
         this._cartScroll.invalidateViewport();
         this.updatePrice();
      }
      
      private function addEvent() : void
      {
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._notAgainBtn.addEventListener(Event.SELECT,this.__againChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_BUYBUFF,this.__getBuff);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPropertyChanged);
      }
      
      protected function __onPropertyChanged(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerInfo.MONEY])
         {
            this._money.text = PlayerManager.Instance.Self.Money.toString();
         }
      }
      
      private function removeEvent() : void
      {
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._notAgainBtn.removeEventListener(Event.SELECT,this.__againChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_BUYBUFF,this.__getBuff);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPropertyChanged);
      }
      
      private function __itemSelected(param1:Event = null) : void
      {
         this.updatePrice();
         var _loc2_:BuffCartItem = param1.currentTarget as BuffCartItem;
         if(_loc2_.IsSelected)
         {
            _autoBuyBuffItem.add(_loc2_.buffID,_loc2_.buffID);
         }
         else
         {
            _autoBuyBuffItem.remove(_loc2_.buffID);
         }
      }
      
      private function updatePrice() : void
      {
         var _loc2_:BuffCartItem = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._selectedArr)
         {
            if(_loc2_.IsSelected)
            {
               _loc1_ += _loc2_.price;
            }
         }
      }
      
      private function __againChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._notAgainBtn.selected)
         {
            IsAutoShow = false;
         }
         else
         {
            IsAutoShow = true;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.buyBuff.setShowSucess"));
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      private function __getBuff(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:BuffCartItem = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.readBoolean())
         {
            _loc3_ = _loc2_.readInt();
            if(_loc3_ > 1)
            {
               this.dispose();
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc2_.readInt();
               for each(_loc6_ in this._selectedArr)
               {
                  if(_loc5_ == _loc6_.buffID)
                  {
                     WorldBossManager.Instance.bossInfo.myPlayerVO.buffID = _loc5_;
                     _loc6_.changeStatusBuy();
                  }
               }
               _loc4_++;
            }
            this.updatePrice();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this._frame);
         ObjectUtils.disposeAllChildren(this);
         this._bottomBg = null;
         this._moneyTip = null;
         this._moneyBg = null;
         this._money = null;
         this._selectedArr = null;
         this._cartList = null;
         this._cartScroll = null;
         this._innerBg = null;
         this._frame = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
