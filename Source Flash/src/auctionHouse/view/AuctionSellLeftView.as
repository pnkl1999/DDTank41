package auctionHouse.view
{
   import bagAndInfo.bag.BagFrame;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.MultipleLineTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class AuctionSellLeftView extends Sprite implements Disposeable
   {
       
      
      private var _bid_btn:BaseButton;
      
      private var _bidLight:Bitmap;
      
      private var _keep:FilterFrameText;
      
      private var _startMoney:FilterFrameText;
      
      private var _mouthfulM:FilterFrameText;
      
      private var name_txt:FilterFrameText;
      
      private var _selectRate:Number = 1;
      
      private var _bidTime1:SelectedButton;
      
      private var _bidTime2:SelectedButton;
      
      private var _bidTime3:SelectedButton;
      
      private var _currentTime:SelectedButton;
      
      private var _cellsItems:Vector.<AuctionCellView>;
      
      private var _cell:AuctionCellView;
      
      private var _dragArea:AuctionDragInArea;
      
      private var _bag:BagFrame;
      
      private var _cellGoodsID:int;
      
      private var _auctionObjectBg:BaseButton;
      
      private var _auctionObject:Sprite;
      
      private var _selectObjectTip:MultipleLineTip;
      
      private var _auctionObjectFrame:int = 0;
      
      private var _cellShowTipAble:Boolean = false;
      
      public function AuctionSellLeftView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:MutipleImage = ComponentFactory.Instance.creat("auctionHouse.SellLeftBG");
         addChild(_loc1_);
         var _loc2_:MutipleImage = ComponentFactory.Instance.creat("auctionHouse.SellLeftIcon0");
         addChild(_loc2_);
         var _loc3_:MutipleImage = ComponentFactory.Instance.creat("auctionHouse.SellLeftIcon1");
         addChild(_loc3_);
         this._bid_btn = ComponentFactory.Instance.creat("auctionHouse.StartBid_btn");
         this._bid_btn.enable = false;
         addChild(this._bid_btn);
         this._bidLight = ComponentFactory.Instance.creat("asset.auctionHouse.StartBidLightbtn");
         this._bidLight.visible = false;
         addChild(this._bidLight);
         this._keep = ComponentFactory.Instance.creat("auctionHouse.SellkeepText");
         addChild(this._keep);
         this._startMoney = ComponentFactory.Instance.creat("auctionHouse.startMoneyText");
         addChild(this._startMoney);
         this._mouthfulM = ComponentFactory.Instance.creat("auctionHouse.mouthfulText");
         addChild(this._mouthfulM);
         this._keep.restrict = this._startMoney.restrict = this._mouthfulM.restrict = "0-9";
         this._startMoney.maxChars = this._mouthfulM.maxChars = 9;
         this.name_txt = ComponentFactory.Instance.creat("auctionHouse.NameText");
         this._bidTime1 = ComponentFactory.Instance.creat("auctionHouse.bidTime1_btn");
         addChild(this._bidTime1);
         this._bidTime2 = ComponentFactory.Instance.creat("auctionHouse.bidTime2_btn");
         addChild(this._bidTime2);
         this._bidTime3 = ComponentFactory.Instance.creat("auctionHouse.bidTime3_btn");
         addChild(this._bidTime3);
         this._currentTime = this._bidTime1;
         this._selectRate = 1;
         this._cellsItems = new Vector.<AuctionCellView>();
         this._cell = ComponentFactory.Instance.creatCustomObject("auctionHouse.AuctionCellView");
         this._cell.buttonMode = true;
         this._cellsItems.push(this._cell);
         this._auctionObject = new Sprite();
         this._auctionObjectBg = ComponentFactory.Instance.creat("auctionHouse.auctionObjCell");
         this._auctionObjectBg.alpha = 0;
         this._auctionObject.addChild(this._auctionObjectBg);
         this._auctionObject.addChild(this.name_txt);
         addChild(this._auctionObject);
         addChild(this._cell);
         this._selectObjectTip = ComponentFactory.Instance.creatCustomObject("auctionHouse.SellSelectedBtn");
         this._selectObjectTip.tipData = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.Choose");
         this._selectObjectTip.mouseChildren = false;
         this._selectObjectTip.mouseEnabled = false;
         this._dragArea = new AuctionDragInArea(this._cellsItems);
         addChildAt(this._dragArea,0);
         this._bag = ComponentFactory.Instance.creat("auctionHouse.view.GoodsBagFrame");
         this._bag.titleText = LanguageMgr.GetTranslation("tank.auctionHouse.view.BagFrame.Choose");
         this._bag.bagView.sorGoodsEnabel = false;
         this._bag.moveEnable = true;
         this._bag.bagView.cellDoubleClickEnable = false;
         this.clear();
      }
      
      private function addEvent() : void
      {
         this._cell.addEventListener(AuctionCellView.SELECT_BID_GOOD,this.__setBidGood);
         this._cell.addEventListener(Event.CHANGE,this.__selectGood);
         this._bid_btn.addEventListener(MouseEvent.CLICK,this.__startBid);
         this._bid_btn.addEventListener(MouseEvent.MOUSE_OVER,this.__bid_btnOver);
         this._bid_btn.addEventListener(MouseEvent.MOUSE_OUT,this.__bid_btnOut);
         this._startMoney.addEventListener(Event.CHANGE,this.__change);
         this._mouthfulM.addEventListener(Event.CHANGE,this.__change);
         this._startMoney.addEventListener(TextEvent.TEXT_INPUT,this.__textInput);
         this._mouthfulM.addEventListener(TextEvent.TEXT_INPUT,this.__textInputMouth);
         this._auctionObject.addEventListener(MouseEvent.CLICK,this._onAuctionObjectClicked);
         this._cell.addEventListener(AuctionCellView.CELL_MOUSEOVER,this._onAuctionObjectOver);
         this._cell.addEventListener(AuctionCellView.CELL_MOUSEOUT,this._onAuctionObjectOut);
         this._bidTime1.addEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bidTime2.addEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bidTime3.addEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bag.addEventListener(CellEvent.DRAGSTART,this.__startShine);
         this._bag.addEventListener(CellEvent.DRAGSTOP,this.__stopShine);
         this._bag.addEventListener(CellEvent.BAG_CLOSE,this.__CellstartShine);
      }
      
      private function __selectBidTimeII(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         this.selectBidUpdate(param1.currentTarget as SelectedButton);
      }
      
      private function selectBidUpdate(param1:SelectedButton) : void
      {
         if(this._currentTime != param1)
         {
            this._currentTime.selected = false;
         }
         if(param1)
         {
            switch(param1.name)
            {
               case this._bidTime1.name:
                  this._currentTime = this._bidTime1;
                  this._selectRate = 1;
                  SoundManager.instance.play("008");
                  break;
               case this._bidTime2.name:
                  this._currentTime = this._bidTime2;
                  this._selectRate = 2;
                  SoundManager.instance.play("008");
                  break;
               case this._bidTime3.name:
                  this._currentTime = this._bidTime3;
                  this._selectRate = 3;
                  SoundManager.instance.play("008");
                  break;
               default:
                  this._currentTime = this._bidTime1;
                  this._selectRate = 1;
            }
         }
         else
         {
            this._currentTime = this._bidTime1;
            this._selectRate = 1;
         }
         if(this._currentTime)
         {
            this._currentTime.selected = true;
         }
         this.update();
      }
      
      private function removeEvent() : void
      {
         this._cell.removeEventListener(AuctionCellView.SELECT_BID_GOOD,this.__setBidGood);
         this._cell.removeEventListener(Event.CHANGE,this.__selectGood);
         this._bid_btn.removeEventListener(MouseEvent.CLICK,this.__startBid);
         this._bid_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.__bid_btnOver);
         this._bid_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.__bid_btnOut);
         this._startMoney.removeEventListener(Event.CHANGE,this.__change);
         this._mouthfulM.removeEventListener(Event.CHANGE,this.__change);
         this._startMoney.removeEventListener(TextEvent.TEXT_INPUT,this.__textInput);
         this._mouthfulM.removeEventListener(TextEvent.TEXT_INPUT,this.__textInputMouth);
         this._auctionObject.removeEventListener(MouseEvent.CLICK,this._onAuctionObjectClicked);
         this._cell.removeEventListener(AuctionCellView.CELL_MOUSEOVER,this._onAuctionObjectOver);
         this._cell.removeEventListener(AuctionCellView.CELL_MOUSEOUT,this._onAuctionObjectOut);
         this._bidTime1.removeEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bidTime2.removeEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bidTime3.removeEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bag.removeEventListener(CellEvent.DRAGSTART,this.__startShine);
         this._bag.removeEventListener(CellEvent.DRAGSTOP,this.__stopShine);
         this._bag.removeEventListener(CellEvent.BAG_CLOSE,this.__startShine);
      }
      
	  internal function addStage() : void
      {
         this._currentTime = this._bidTime1;
         this._selectRate = 1;
         this.update();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         this._cell.dragDrop(param1);
      }
      
	  internal function clear() : void
      {
         this.name_txt.text = "";
         this._startMoney.text = "";
         this._mouthfulM.text = "";
         this._keep.text = "";
         if(this._cell.getSource() && this._cell.info)
         {
            this._cell.clearLinkCell();
         }
         this._startMoney.mouseEnabled = false;
         this._mouthfulM.mouseEnabled = false;
         this.__selectBidTimeII(new MouseEvent(MouseEvent.CLICK));
         this.__stopShine(null);
      }
      
	  internal function hideReady() : void
      {
         this._bag.hide();
      }
      
      public function openBagFrame() : void
      {
         this._bag.show();
      }
      
      private function update() : void
      {
         this._keep.text = this.getKeep();
      }
      
      private function getRate() : int
      {
         return this._selectRate;
      }
      
      private function getKeep() : String
      {
         if(this._selectRate == 1)
         {
            return "100";
         }
         if(this._selectRate == 2)
         {
            return "200";
         }
         if(this._selectRate == 3)
         {
            return "300";
         }
         return "100";
      }
      
      private function _onAuctionObjectClicked(param1:Event) : void
      {
         this._auctionObject.mouseChildren = false;
         this._auctionObject.mouseEnabled = false;
         if(this._cell.info && this._bag.parent)
         {
            this._cell.onObjectClicked();
            return;
         }
         this.__setBidGood(null);
      }
      
      private function _onAuctionObjectOver(param1:Event) : void
      {
         if(this._cell.info == null)
         {
            this._selectObjectTip.x = localToGlobal(new Point(this._auctionObject.x + this._auctionObject.width / 2,this._auctionObject.y + this._auctionObject.height)).x + 10;
            this._selectObjectTip.y = localToGlobal(new Point(this._auctionObject.x + this._auctionObject.width / 2,this._auctionObject.y + this._auctionObject.height)).y + this._auctionObject.height - 5;
            LayerManager.Instance.addToLayer(this._selectObjectTip,LayerManager.GAME_TOP_LAYER);
         }
         this._auctionObjectBg.alpha = 1;
      }
      
      private function _onAuctionObjectOut(param1:Event) : void
      {
         if(this._selectObjectTip.parent)
         {
            this._selectObjectTip.parent.removeChild(this._selectObjectTip);
         }
         this._auctionObjectBg.alpha = 0;
      }
      
      private function __setBidGood(param1:Event) : void
      {
         if(this._cell && this._cell.info)
         {
            this._cellGoodsID = this._cell.info.TemplateID;
         }
         if(!this._cell.info || !this._bag.parent)
         {
            this.openBagFrame();
            SoundManager.instance.play("047");
         }
         this.__stopShine(null);
      }
      
      private function __CellstartShine(param1:CellEvent) : void
      {
         if(this._cell.info != null)
         {
            return;
         }
         this._auctionObject.addEventListener(Event.ENTER_FRAME,this._auctionObjectflash);
      }
      
      private function __startShine(param1:CellEvent) : void
      {
         this._auctionObject.addEventListener(Event.ENTER_FRAME,this._auctionObjectflash);
      }
      
      private function __stopShine(param1:CellEvent) : void
      {
         this._auctionObject.removeEventListener(Event.ENTER_FRAME,this._auctionObjectflash);
         this._auctionObjectBg.alpha = 0;
         this._auctionObjectFrame = 0;
      }
      
      private function _auctionObjectflash(param1:Event) : void
      {
         this._auctionObjectFrame += 1;
         if(this._auctionObjectFrame == 3)
         {
            this._auctionObjectBg.alpha = 1;
         }
         else if(this._auctionObjectFrame == 6)
         {
            this._auctionObjectBg.alpha = 0;
            this._auctionObjectFrame = 0;
         }
      }
      
      private function __selectGood(param1:Event) : void
      {
         if(this._cell.info)
         {
            this.initInfo();
         }
         else
         {
            this.clear();
            this._bid_btn.enable = false;
         }
      }
      
      private function initInfo() : void
      {
         var _loc1_:Object = null;
         this.name_txt.text = this._cell.info.Name;
         this._startMoney.mouseEnabled = true;
         this._mouthfulM.mouseEnabled = true;
         this._bid_btn.enable = true;
         if(SharedManager.Instance.AuctionInfos != null && SharedManager.Instance.AuctionInfos[this._cell.info.Name] != null)
         {
            _loc1_ = SharedManager.Instance.AuctionInfos[this._cell.info.Name];
            if(_loc1_)
            {
               this._mouthfulM.text = _loc1_.mouthfulPrice == 0 ? "" : _loc1_.mouthfulPrice;
               this._startMoney.text = _loc1_.startPrice;
               switch(_loc1_.time)
               {
                  case 0:
                     this.selectBidUpdate(this._bidTime1);
                     break;
                  case 1:
                     this.selectBidUpdate(this._bidTime2);
                     break;
                  case 2:
                     this.selectBidUpdate(this._bidTime3);
                     break;
                  default:
                     this.selectBidUpdate(this._bidTime1);
               }
            }
         }
         else
         {
            this.selectBidUpdate(null);
         }
      }
      
      private function __bid_btnOver(param1:MouseEvent) : void
      {
         this._bidLight.visible = true;
      }
      
      private function __bid_btnOut(param1:MouseEvent) : void
      {
         this._bidLight.visible = false;
      }
      
      private function __startBid(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("047");
         if(!this._cell.info)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.ChooseTwo"));
            return;
         }
         if(this._startMoney.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.Price"));
            return;
         }
         if(this._mouthfulM.text != "" && this._startMoney.text != "")
         {
            if(Number(this._startMoney.text) >= Number(this._mouthfulM.text))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.PriceTwo"));
               return;
            }
         }
         if(Number(this._keep.text) > PlayerManager.Instance.Self.Gold)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseV);
            return;
         }
         this.auctionGood();
      }
      
      private function _responseV(param1:FrameEvent) : void
      {
         var _loc2_:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
            _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _loc2_.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function auctionGood() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         if(this._cell.info)
         {
            _loc1_ = (this._cell.info as InventoryItemInfo).BagType;
            _loc2_ = (this._cell.info as InventoryItemInfo).Place;
            _loc3_ = Math.floor(Number(this._startMoney.text));
            _loc4_ = this._mouthfulM.text == "" ? int(int(0)) : int(int(Math.floor(Number(this._mouthfulM.text))));
            _loc5_ = this._selectRate - 1;
            _loc6_ = this._cell.goodsCount;
            SocketManager.Instance.out.auctionGood(_loc1_,_loc2_,1,_loc3_,_loc4_,_loc5_,_loc6_);
            _loc7_ = {};
            _loc7_.itemName = this._cell.info.Name;
            _loc7_.startPrice = _loc3_;
            _loc7_.mouthfulPrice = _loc4_;
            _loc7_.time = _loc5_;
            SharedManager.Instance.AuctionInfos[this._cell.info.Name] = _loc7_;
            SharedManager.Instance.save();
         }
         this.selectBidUpdate(null);
         this._startMoney.stage.focus = null;
         this._mouthfulM.stage.focus = null;
      }
      
      private function __change(param1:Event) : void
      {
         if(Number(this._startMoney.text) == 0)
         {
            this._startMoney.text = "";
         }
         this.update();
      }
      
      private function __textInput(param1:TextEvent) : void
      {
         if(Number(this._keep.text) + Number(param1.text) == 0)
         {
            if(this._keep.selectedText.length <= 0)
            {
               param1.preventDefault();
            }
         }
      }
      
      private function __textInputMouth(param1:TextEvent) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         if(Number(_loc2_.text) + Number(param1.text) == 0)
         {
            if(_loc2_.selectedText.length <= 0)
            {
               param1.preventDefault();
            }
         }
      }
      
      private function __timeChange(param1:Event) : void
      {
         this.update();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._cellsItems = null;
         if(this._dragArea)
         {
            ObjectUtils.disposeObject(this._dragArea);
         }
         this._dragArea = null;
         if(this._bid_btn)
         {
            ObjectUtils.disposeObject(this._bid_btn);
         }
         this._bid_btn = null;
         if(this._keep)
         {
            ObjectUtils.disposeObject(this._keep);
         }
         this._keep = null;
         if(this._startMoney)
         {
            ObjectUtils.disposeObject(this._startMoney);
         }
         this._startMoney = null;
         if(this._mouthfulM)
         {
            ObjectUtils.disposeObject(this._mouthfulM);
         }
         this._mouthfulM = null;
         if(this._bag)
         {
            ObjectUtils.disposeObject(this._bag);
         }
         this._bag = null;
         if(this.name_txt)
         {
            ObjectUtils.disposeObject(this.name_txt);
         }
         this.name_txt = null;
         if(this._selectObjectTip)
         {
            ObjectUtils.disposeObject(this._selectObjectTip);
         }
         this._selectObjectTip = null;
         if(this._auctionObject)
         {
            ObjectUtils.disposeObject(this._auctionObject);
         }
         this._auctionObject = null;
         if(this._bidTime1)
         {
            ObjectUtils.disposeObject(this._bidTime1);
         }
         this._bidTime1 = null;
         if(this._bidTime2)
         {
            ObjectUtils.disposeObject(this._bidTime1);
         }
         this._bidTime2 = null;
         if(this._bidTime3)
         {
            ObjectUtils.disposeObject(this._bidTime1);
         }
         this._bidTime3 = null;
         if(this._currentTime)
         {
            ObjectUtils.disposeObject(this._bidTime1);
         }
         this._currentTime = null;
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(this._auctionObjectBg)
         {
            ObjectUtils.disposeObject(this._auctionObjectBg);
         }
         this._auctionObjectBg = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
