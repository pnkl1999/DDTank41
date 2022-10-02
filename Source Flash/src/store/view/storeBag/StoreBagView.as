package store.view.storeBag
{
   import bagAndInfo.bag.BreakGoodsView;
   import bagAndInfo.bag.CellMenu;
   import bagAndInfo.bag.RichesButton;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.goods.AddPricePanel;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import store.StoreBagBgWHPoint;
   import store.StoreMainView;
   import store.data.StoreModel;
   
   public class StoreBagView extends Sprite implements Disposeable
   {
       
      
      private var _controller:StoreBagController;
      
      private var _model:StoreModel;
      
      private var _equipmentView:StoreBagListView;
      
      private var _propView:StoreBagListView;
      
      private var _singleView:StoreSingleBagListView;
      
      private var _bitmapBg:StoreBagbgbmp;
      
      private var bagBg:ScaleFrameImage;
      
      public var msg_txt:ScaleFrameImage;
      
      private var goldTxt:FilterFrameText;
      
      private var moneyTxt:FilterFrameText;
      
      private var giftTxt:FilterFrameText;
      
      private var _goldButton:RichesButton;
      
      private var _giftButton:RichesButton;
      
      private var _moneyButton:RichesButton;
      
      private var _bgPoint:StoreBagBgWHPoint;
      
      private var _bgShape:Shape;
      
      public function StoreBagView()
      {
         super();
      }
      
      public function setup(param1:StoreBagController) : void
      {
         this._controller = param1;
         this._model = this._controller.model;
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._bitmapBg = new StoreBagbgbmp();
         addChildAt(this._bitmapBg,0);
         this.bagBg = ComponentFactory.Instance.creatComponentByStylename("store.bagBG");
         this._bgPoint = ComponentFactory.Instance.creatCustomObject("store.bagBGWHPoint");
         this._bgShape = new Shape();
         this.bagBg.addChild(this._bgShape);
         addChild(this.bagBg);
         var _loc1_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("store.ShowMoneyBG");
         addChild(_loc1_);
         this.msg_txt = ComponentFactory.Instance.creatComponentByStylename("store.bagMsg");
         addChild(this.msg_txt);
         this.msg_txt.setFrame(1);
         this.moneyTxt = ComponentFactory.Instance.creatComponentByStylename("store.bagMoneyTxt");
         addChild(this.moneyTxt);
         this._goldButton = ComponentFactory.Instance.creatCustomObject("store.StoreBagView.GoldButton");
         this._goldButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
         addChild(this._goldButton);
         this.giftTxt = ComponentFactory.Instance.creatComponentByStylename("store.bagGiftTxt");
         addChild(this.giftTxt);
         this._giftButton = ComponentFactory.Instance.creatCustomObject("store.StoreBagView.GiftButton");
         this._giftButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections");
         addChild(this._giftButton);
         this._moneyButton = ComponentFactory.Instance.creatCustomObject("store.StoreBagView.MoneyButton");
         this._moneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
         addChild(this._moneyButton);
         this.goldTxt = ComponentFactory.Instance.creatComponentByStylename("store.bagGoldTxt");
         addChild(this.goldTxt);
         this._equipmentView = ComponentFactory.Instance.creatCustomObject("store.StoreBagListViewEquip");
         this._propView = ComponentFactory.Instance.creatCustomObject("store.StoreBagListViewProp");
         this._singleView = ComponentFactory.Instance.creatCustomObject("store.StoreSingleBagListView");
         this._equipmentView.setup(0,this._controller,StoreBagListView.SMALLGRID);
         this._propView.setup(1,this._controller,StoreBagListView.SMALLGRID);
         this._singleView.setup(0,this._controller,StoreSingleBagListView.SINGLEBAG);
         addChild(this._equipmentView);
         addChild(this._propView);
         addChild(this._singleView);
         this.updateMoney();
      }
      
      private function initEvents() : void
      {
         this._equipmentView.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._propView.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._singleView.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         CellMenu.instance.addEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.addEventListener(CellMenu.MOVE,this.__cellMove);
         this._model.info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function removeEvents() : void
      {
         this._equipmentView.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._propView.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         CellMenu.instance.removeEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.removeEventListener(CellMenu.MOVE,this.__cellMove);
         this._model.info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      public function setData(param1:StoreModel) : void
      {
         if(this._controller.currentPanel == StoreMainView.STRENGTH)
         {
            this._equipmentView.setData(this._model.canStrthEqpmtList);
            this._propView.setData(this._model.strthAndANchList);
            this.bagBg.setFrame(1);
            this._bgShape.graphics.clear();
            this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
            this.changeToDoubleBagView();
         }
         else if(this._controller.currentPanel == StoreMainView.COMPOSE)
         {
            this._equipmentView.setData(this._model.canCpsEquipmentList);
            this._propView.setData(this._model.cpsAndANchList);
            this.bagBg.setFrame(1);
            this._bgShape.graphics.clear();
            this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
            this.changeToDoubleBagView();
         }
         else if(this._controller.currentPanel == StoreMainView.FUSION)
         {
            this._equipmentView.setData(this._model.canRongLiangEquipmengtList);
            this._propView.setData(this._model.canRongLiangPropList);
            this.bagBg.setFrame(1);
            this._bgShape.graphics.clear();
            this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
            this.changeToDoubleBagView();
         }
         else if(this._controller.currentPanel == StoreMainView.EMBED)
         {
            this._equipmentView.setData(this._model.canEmbedEquipList);
            this._propView.setData(this._model.canEmbedPropList);
            this.bagBg.setFrame(1);
            this._bgShape.graphics.clear();
            this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
            this.changeToDoubleBagView();
         }
         else if(this._controller.currentPanel == StoreMainView.LIANGHUA)
         {
            this._equipmentView.setData(this._model.canLianhuaEquipList);
            this._propView.setData(this._model.canLianhuaPropList);
            this.bagBg.setFrame(1);
            this._bgShape.graphics.clear();
            this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
            this.changeToDoubleBagView();
         }
         else if(this._controller.currentPanel == StoreMainView.EXALT)
         {
            this._equipmentView.setData(this._model.canExaltEqpmtList);
            this._propView.setData(this._model.exaltRock);
            this.bagBg.setFrame(1);
            this._bgShape.graphics.clear();
            this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
            this.changeToDoubleBagView();
         }
         else if(this._controller.currentPanel == StoreMainView.WISHBEAD)
         {
            this._equipmentView.setData(this._model.canWishBeadEqpmtList);
            this._propView.setData(this._model.wishBeadRock);
            this.bagBg.setFrame(1);
            this._bgShape.graphics.clear();
            this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
            this.changeToDoubleBagView();
         }
		 else if(this._controller.currentPanel == StoreMainView.LatentEnergy)
		 {
			 this._equipmentView.setData(this._model.canLatentEnergyEqpmtList);
			 this._propView.setData(this._model.PotentialRock);
			 this.bagBg.setFrame(1);
			 this._bgShape.graphics.clear();
			 this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
			 this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
			 this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
			 this.changeToDoubleBagView();
		 }
		 else if(this._controller.currentPanel == StoreMainView.GemStone)
		 {
			 this.bagBg.setFrame(2);
			 this._bgShape.graphics.clear();
			 this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
			 this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
			 this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
			 this.changeToDoubleBagView();
		 }
         else
         {
            this._singleView.setData(this._model.canTransEquipmengtList);
            this.bagBg.setFrame(3);
            this._bgShape.graphics.clear();
            this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
            this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[9]),Number(this._bgPoint.pointArr[10]),Number(this._bgPoint.pointArr[11]),Number(this._bgPoint.pointArr[12]));
            this.changeToSingleBagView();
         }
      }
      
      private function changeToSingleBagView() : void
      {
         this._equipmentView.visible = false;
         this._propView.visible = false;
         this._singleView.visible = true;
      }
      
      private function changeToDoubleBagView() : void
      {
         this._equipmentView.visible = true;
         this._propView.visible = true;
         this._singleView.visible = false;
      }
      
      private function __cellClick(param1:CellEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         param1.stopImmediatePropagation();
         var _loc2_:BagCell = param1.data as BagCell;
         if(_loc2_)
         {
            _loc3_ = _loc2_.info as InventoryItemInfo;
         }
         if(_loc3_ == null)
         {
            return;
         }
         if(!_loc2_.locked)
         {
            SoundManager.instance.play("008");
            if(!EquipType.isPackage(_loc3_))
            {
               _loc2_.dragStart();
            }
         }
      }
      
      private function createBreakWin(param1:BagCell) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BreakGoodsView = new BreakGoodsView();
         _loc2_.cell = param1;
         _loc2_.show();
      }
      
      private function __cellAddPrice(param1:Event) : void
      {
         var _loc2_:BagCell = CellMenu.instance.cell;
         if(_loc2_)
         {
            AddPricePanel.Instance.setInfo(_loc2_.itemInfo,false);
            LayerManager.Instance.addToLayer(AddPricePanel.Instance,LayerManager.STAGE_DYANMIC_LAYER,true);
         }
      }
      
      private function __cellMove(param1:Event) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BagCell = CellMenu.instance.cell;
         if(_loc2_)
         {
            _loc2_.dragStart();
         }
      }
      
      public function getPropCell(param1:int) : BagCell
      {
         return this._propView.getCellByPos(param1);
      }
      
      public function getEquipCell(param1:int) : BagCell
      {
         return this._equipmentView.getCellByPos(param1);
      }
      
      public function get EquipList() : StoreBagListView
      {
         return this._equipmentView;
      }
      
      public function get PropList() : StoreBagListView
      {
         return this._propView;
      }
      
      public function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Money"] || param1.changedProperties["Gold"] || param1.changedProperties[PlayerInfo.GIFT])
         {
            this.updateMoney();
         }
      }
      
      private function updateMoney() : void
      {
         this.goldTxt.text = String(PlayerManager.Instance.Self.Gold);
         this.moneyTxt.text = String(PlayerManager.Instance.Self.Money);
         this.giftTxt.text = String(PlayerManager.Instance.Self.Gift);
      }
	  
	  public function enableCellDoubleClick(param1:Boolean, param2:Function) : void
	  {
		  if(param1 && param2)
		  {
			  this._equipmentView.addEventListener("doubleclick",param2);
			  this._propView.addEventListener("doubleclick",param2);
		  }
		  else
		  {
			  this._equipmentView.removeEventListener("doubleclick",param2);
			  this._propView.removeEventListener("doubleclick",param2);
		  }
	  }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._bitmapBg)
         {
            ObjectUtils.disposeObject(this._bitmapBg);
         }
         this._bitmapBg = null;
         if(this.bagBg)
         {
            ObjectUtils.disposeObject(this.bagBg);
         }
         this.bagBg = null;
         if(this.msg_txt)
         {
            ObjectUtils.disposeObject(this.msg_txt);
         }
         this.msg_txt = null;
         if(this._equipmentView)
         {
            ObjectUtils.disposeObject(this._equipmentView);
         }
         this._equipmentView = null;
         if(this._propView)
         {
            ObjectUtils.disposeObject(this._propView);
         }
         this._propView = null;
         if(this._singleView)
         {
            ObjectUtils.disposeObject(this._singleView);
         }
         this._singleView = null;
         if(this.goldTxt)
         {
            ObjectUtils.disposeObject(this.goldTxt);
         }
         this.goldTxt = null;
         if(this.moneyTxt)
         {
            ObjectUtils.disposeObject(this.moneyTxt);
         }
         this.moneyTxt = null;
         if(this.giftTxt)
         {
            ObjectUtils.disposeObject(this.giftTxt);
         }
         this.giftTxt = null;
         if(this._goldButton)
         {
            ObjectUtils.disposeObject(this._goldButton);
         }
         this._goldButton = null;
         if(this._giftButton)
         {
            ObjectUtils.disposeObject(this._giftButton);
         }
         this._giftButton = null;
         if(this._moneyButton)
         {
            ObjectUtils.disposeObject(this._moneyButton);
         }
         this._moneyButton = null;
         if(this._bgShape)
         {
            ObjectUtils.disposeObject(this._bgShape);
         }
         this._bgShape = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
