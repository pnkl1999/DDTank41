package ddt.view.caddyII
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.card.CardViewII;
   import ddt.view.caddyII.reader.CaddyUpdate;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class CaddyFrame extends Frame
   {
      
      public static const VerticalOffset:int = -50;
       
      
      private var _view:RightView;
      
      private var _bag:CaddyBagView;
      
      private var _reader:CaddyUpdate;
      
      private var _moveSprite:MoveSprite;
      
      private var _closeAble:Boolean = true;
      
      private var _itemInfo:ItemTemplateInfo;
      
      private var _type:int;
      
      private var _caddyAwardCount:int = 0;
      
      private var _closed:Boolean = false;
      
      private var _selectInfo:InventoryItemInfo;
      
      public function CaddyFrame(param1:int, param2:ItemTemplateInfo = null)
      {
         super();
         this._itemInfo = param2;
         this._type = param1;
         this.initView(param1);
         this.initEvents();
      }
      
      public function setBeadType(param1:int) : void
      {
         CaddyModel.instance.beadType = param1;
      }
      
      public function setOfferType(param1:int) : void
      {
         CaddyModel.instance.offerType = param1;
      }
      
      public function setCardType(param1:int, param2:int) : void
      {
         CardViewII.instance.setCard(param1,param2);
      }
      
      private function initView(param1:int) : void
      {
         CaddyModel.instance.setup(param1);
         this._view = CaddyModel.instance.rightView;
         this._view.item = this._itemInfo;
         addToContent(this._view);
         this._bag = ComponentFactory.Instance.creatCustomObject("caddy.CaddyBagView");
         addToContent(this._bag);
         if(this._type == CaddyModel.BEAD_TYPE || this._type == CaddyModel.MYSTICAL_CARDBOX || this._type == CaddyModel.CADDY_TYPE || this._type == CaddyModel.OFFER_PACKET || this._type == CaddyModel.MY_CARDBOX || this._type == CaddyModel.CARD_CARTON)
         {
            this._reader = CaddyModel.instance.readView;
            addToContent(this._reader as DisplayObject);
         }
         this._moveSprite = ComponentFactory.Instance.creatCustomObject("caddy.MoveSprite",[this._itemInfo]);
         addToContent(this._moveSprite);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._view.addEventListener(RightView.START_TURN,this._startTurn);
         this._view.addEventListener(RightView.START_MOVE_AFTER_TURN,this._turnComplete);
         this._bag.addEventListener(CaddyBagView.NULL_CELL_POINT,this._getCellPoint);
         this._bag.addEventListener(CaddyBagView.GET_GOODSINFO,this._getGoodsInfo);
         this._moveSprite.addEventListener(MoveSprite.QUEST_CELL_POINT,this._questCellPoint);
         this._moveSprite.addEventListener(MoveSprite.MOVE_COMPLETE,this._moveComplete);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_OPNE,this.__lotteryOpen);
         ChatManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_BEAD,this.__buyBeads);
      }
      
      private function __lotteryOpen(param1:CrazyTankSocketEvent) : void
      {
         if(this._itemInfo && this._itemInfo.TemplateID == EquipType.CADDY)
         {
            this._caddyAwardCount = param1.pkg.readInt();
         }
      }
      
      private function __buyBeads(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(EquipType.isBeadFromSmeltByID(CaddyModel.instance.beadType))
         {
            ObjectUtils.disposeObject(this);
            _loc2_ = this.getOpenBeadType(CaddyModel.instance.beadType);
            if(_loc2_ >= 0)
            {
               RouletteManager.instance.useBead(_loc2_);
            }
         }
      }
      
      private function getOpenBeadType(param1:int) : int
      {
         if(EquipType.isAttackBeadFromSmeltByID(param1))
         {
            return CaddyModel.Bead_Attack;
         }
         if(EquipType.isDefenceBeadFromSmeltByID(param1))
         {
            return CaddyModel.Bead_Defense;
         }
         if(EquipType.isAttributeBeadFromSmeltByID(param1))
         {
            return CaddyModel.Bead_Attribute;
         }
         return -1;
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._view.removeEventListener(RightView.START_TURN,this._startTurn);
         this._view.removeEventListener(RightView.START_MOVE_AFTER_TURN,this._turnComplete);
         this._bag.removeEventListener(CaddyBagView.NULL_CELL_POINT,this._getCellPoint);
         this._bag.removeEventListener(CaddyBagView.GET_GOODSINFO,this._getGoodsInfo);
         this._moveSprite.removeEventListener(MoveSprite.QUEST_CELL_POINT,this._questCellPoint);
         this._moveSprite.removeEventListener(MoveSprite.MOVE_COMPLETE,this._moveComplete);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_OPNE,this.__lotteryOpen);
         ChatManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_BEAD,this.__buyBeads);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._view.openBtnEnable)
         {
            MessageTipManager.getInstance().show(CaddyModel.instance.dontClose);
            return;
         }
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            if(this._bag.checkCell())
            {
               this._showCloseAlert();
            }
            else
            {
               ObjectUtils.disposeObject(this);
            }
         }
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.sellAllNode") + this._bag.getSellAllPriceString(),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
               ObjectUtils.disposeObject(param1.currentTarget);
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               ObjectUtils.disposeObject(param1.currentTarget);
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               ObjectUtils.disposeObject(param1.currentTarget);
               ObjectUtils.disposeObject(this);
         }
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendSellAll();
         }
         else
         {
            this._showCloseAlert();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function _showCloseAlert() : void
      {
         var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.closeNode"),LanguageMgr.GetTranslation("tank.view.caddy.putInBag"),LanguageMgr.GetTranslation("tank.view.caddy.sellAll"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc1_.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _questCellPoint(param1:Event) : void
      {
         this._bag.findCell();
      }
      
      private function _turnComplete(param1:Event) : void
      {
         if(this._selectInfo.TemplateID == EquipType.BADLUCK_STONE)
         {
            this._startMove(null);
         }
         else
         {
            this._moveComplete(null);
         }
      }
      
      private function _moveComplete(param1:Event) : void
      {
         if(this._closed)
         {
            return;
         }
         this._bag.addCell();
         this._view.again();
         this._reader.update();
         this._bag.sellBtn.enable = true;
         this.closeAble = true;
         if(this._itemInfo && this._itemInfo.TemplateID == EquipType.CADDY)
         {
            if(this._caddyAwardCount == CaddyAwardModel.getInstance().silverAwardCount || this._caddyAwardCount % 10 == CaddyAwardModel.getInstance().silverAwardCount)
            {
               if(this._caddyAwardCount % 100 != 96)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.daddy.SilverAward"));
               }
            }
            else if(this._caddyAwardCount == CaddyAwardModel.getInstance().goldAwardCount || this._caddyAwardCount % 10 == CaddyAwardModel.getInstance().goldAwardCount)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.daddy.GoldAward"));
            }
         }
      }
      
      private function _startTurn(param1:CaddyEvent) : void
      {
         this._moveSprite.setInfo(param1.info);
         this._bag.sellBtn.enable = false;
         this.closeAble = false;
      }
      
      public function turnComplete(param1:Event) : void
      {
         this._moveSprite;
      }
      
      private function _startMove(param1:Event) : void
      {
         this._moveSprite.startMove();
      }
      
      private function _getCellPoint(param1:CaddyEvent) : void
      {
         this._moveSprite.setMovePoint(param1.point);
      }
      
      private function _getGoodsInfo(param1:CaddyEvent) : void
      {
         this._selectInfo = param1.info;
         if(!this._closed)
         {
            this._view.setSelectGoodsInfo(param1.info);
         }
      }
      
      public function show() : void
      {
         if(this._type == CaddyModel.BEAD_TYPE || this._type == CaddyModel.MYSTICAL_CARDBOX || this._type == CaddyModel.MY_CARDBOX || this._type == CaddyModel.CARD_CARTON)
         {
            this._view.setType(CaddyModel.instance.beadType);
         }
         titleText = CaddyModel.instance.CaddyFrameTitle;
         escEnable = true;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         y += VerticalOffset;
      }
      
      public function set closeAble(param1:Boolean) : void
      {
         this._closeAble = param1;
      }
      
      public function get closeAble() : Boolean
      {
         return this._closeAble;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         SocketManager.Instance.out.sendFinishRoulette();
         this._closed = true;
         if(this._view)
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         if(this._bag)
         {
            ObjectUtils.disposeObject(this._bag);
         }
         this._bag = null;
         if(this._moveSprite)
         {
            ObjectUtils.disposeObject(this._moveSprite);
         }
         this._moveSprite = null;
         if(this._reader)
         {
            ObjectUtils.disposeObject(this._reader);
         }
         this._reader = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
