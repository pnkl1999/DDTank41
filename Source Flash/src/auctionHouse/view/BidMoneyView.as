package auctionHouse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.ui.Keyboard;
   
   public class BidMoneyView extends Sprite implements Disposeable
   {
       
      
      public const MONEY_KEY_UP:String = "money_key_up";
      
      private var _money:FilterFrameText;
      
      private var _canMoney:Boolean;
      
      private var _canGold:Boolean;
      
      public function BidMoneyView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      public function get money() : FilterFrameText
      {
         return this._money;
      }
      
      private function initView() : void
      {
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.Browse.BidBG");
         addChild(_loc1_);
         var _loc2_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BidInputIcon");
         addChild(_loc2_);
         this._money = ComponentFactory.Instance.creat("auctionHouse.BidMoney");
         this._money.restrict = "0-9";
         addChild(this._money);
      }
      
      private function addEvent() : void
      {
         this._money.addEventListener(Event.CHANGE,this.__change);
         this._money.addEventListener(TextEvent.TEXT_INPUT,this.__inputTextM);
         this._money.addEventListener(KeyboardEvent.KEY_UP,this._moneyUp);
      }
      
	  internal function get canMoney() : Boolean
      {
         return this._canMoney;
      }
      
	  internal function get canGold() : Boolean
      {
         return this._canGold;
      }
      
      private function removeEvent() : void
      {
         this._money.removeEventListener(Event.CHANGE,this.__change);
         this._money.removeEventListener(TextEvent.TEXT_INPUT,this.__inputTextM);
         this._money.removeEventListener(KeyboardEvent.KEY_UP,this._moneyUp);
      }
      
	  internal function canMoneyBid(param1:int) : void
      {
         this._money.mouseEnabled = true;
         this._canMoney = true;
         this._canGold = false;
         this._money.text = param1.toString();
         this._money.setFocus();
         this._money.setSelection(param1.toString().length,param1.toString().length);
      }
      
	  internal function canGoldBid(param1:int) : void
      {
         this._money.text = "";
         if(this._money.stage)
         {
            this._money.stage.focus = null;
         }
         this._money.mouseEnabled = false;
         this._canGold = true;
         this._canMoney = false;
      }
      
	  internal function cannotBid() : void
      {
         this._money.mouseEnabled = false;
         this._money.text = "";
         if(this._money.stage)
         {
            this._money.stage.focus = null;
         }
         this._canGold = false;
         this._canMoney = false;
      }
      
	  internal function getData() : Number
      {
         var _loc1_:Number = NaN;
         if(!this._canGold)
         {
            if(this._canMoney)
            {
               _loc1_ = Number(this._money.text);
            }
         }
         return _loc1_;
      }
      
      private function _moneyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this._money.removeEventListener(KeyboardEvent.KEY_UP,this._moneyUp);
            dispatchEvent(new Event(this.MONEY_KEY_UP));
         }
      }
      
      private function __change(param1:Event) : void
      {
      }
      
      private function __inputTextM(param1:TextEvent) : void
      {
         if(Number(this._money.text) + Number(param1.text) > PlayerManager.Instance.Self.Money || Number(this._money.text) + Number(param1.text) == 0)
         {
            return;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._money)
         {
            ObjectUtils.disposeObject(this._money);
         }
         this._money = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
