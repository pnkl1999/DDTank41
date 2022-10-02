package store.forge.wishBead
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.StoreBagBgWHPoint;
   
   public class WishBeadMainView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _bagList:WishBeadBagListView;
      
      private var _proBagList:WishBeadBagListView;
      
      private var _leftDrapSprite:WishBeadLeftDragSprite;
      
      private var _rightDrapSprite:WishBeadRightDragSprite;
      
      private var _itemCell:WishBeadItemCell;
      
      private var _equipCell:WishBeadEquipCell;
      
      private var _continuousBtn:SelectedCheckButton;
      
      private var _doBtn:SimpleBitmapButton;
      
      private var _tip:WishTips;
      
      private var _helpBtn:BaseButton;
      
      private var _isDispose:Boolean = false;
      
      private var _equipBagInfo:BagInfo;
      
      public var msg_txt:ScaleFrameImage;
      
      private var bagBg:ScaleFrameImage;
      
      private var _bgShape:Shape;
      
      private var _bgPoint:StoreBagBgWHPoint;
      
      public function WishBeadMainView()
      {
         super();
         this.mouseEnabled = false;
         this.initView();
         this.initEvent();
         this.createAcceptDragSprite();
      }
      
      private function initView() : void
      {
         this.bagBg = ComponentFactory.Instance.creatComponentByStylename("store.bagBG");
         this._bgPoint = ComponentFactory.Instance.creatCustomObject("store.bagBGWHPoint");
         this._bgShape = new Shape();
         this.bagBg.addChild(this._bgShape);
         this.bagBg.x = 368;
         this.bagBg.y = 15;
         addChild(this.bagBg);
         this._bgShape.graphics.clear();
         this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
         this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
         this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
         this._bg = ComponentFactory.Instance.creatBitmap("asset.wishBead.leftViewBg");
         this.msg_txt = ComponentFactory.Instance.creatComponentByStylename("store.bagMsg1");
         this.msg_txt.x = 452;
         this.msg_txt.y = 17;
         addChild(this.msg_txt);
         this.msg_txt.setFrame(1);
         this._bagList = new WishBeadBagListView(BagInfo.EQUIPBAG,7,21);
         PositionUtils.setPos(this._bagList,"wishBeadMainView.bagListPos");
         this.refreshBagList();
         this._proBagList = new WishBeadBagListView(BagInfo.PROPBAG,7,21);
         PositionUtils.setPos(this._proBagList,"wishBeadMainView.proBagListPos");
         this._proBagList.setData(WishBeadManager.instance.getWishBeadItemData());
         this._equipCell = new WishBeadEquipCell(0,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         this._equipCell.BGVisible = false;
         PositionUtils.setPos(this._equipCell,"wishBeadMainView.equipCellPos");
         this._equipCell.setContentSize(68,68);
         this._equipCell.PicPos = new Point(-3,-5);
         this._itemCell = new WishBeadItemCell(0,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         PositionUtils.setPos(this._itemCell,"wishBeadMainView.itemCellPos");
         this._itemCell.BGVisible = false;
         this._continuousBtn = ComponentFactory.Instance.creatComponentByStylename("wishBeadMainView.continuousBtn");
         this._doBtn = ComponentFactory.Instance.creatComponentByStylename("wishBeadMainView.doBtn");
         this._doBtn.enable = false;
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("wishBeadMainView.tipTxt");
         _loc1_.text = LanguageMgr.GetTranslation("wishBeadMainView.tipTxt");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("wishBead.NodeBtn");
         addChild(this._bg);
         addChild(this._bagList);
         addChild(this._proBagList);
         addChild(this._equipCell);
         addChild(this._itemCell);
         addChild(_loc1_);
         addChild(this._continuousBtn);
         addChild(this._doBtn);
         addChild(this._helpBtn);
         this._tip = ComponentFactory.Instance.creat("store.forge.wishBead.WishTip");
         LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER).addChild(this._tip);
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      private function refreshBagList() : void
      {
         this._equipBagInfo = WishBeadManager.instance.getCanWishBeadData();
         this._bagList.setData(this._equipBagInfo);
      }
      
      private function initEvent() : void
      {
         this._bagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._bagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._equipCell.addEventListener(Event.CHANGE,this.itemEquipChangeHandler,false,0,true);
         this._proBagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._proBagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._itemCell.addEventListener(Event.CHANGE,this.itemEquipChangeHandler,false,0,true);
         this._doBtn.addEventListener(MouseEvent.CLICK,this.doHandler,false,0,true);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WISHBEADEQUIP,this.__showTip);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__clickHelp,false,0,true);
      }
      
      private function bagInfoChangeHandler(param1:BagEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc6_:BagInfo = null;
         var _loc2_:Dictionary = param1.changedSlots;
         for each(_loc4_ in _loc2_)
         {
            _loc3_ = _loc4_;
         }
         if(_loc3_ && !PlayerManager.Instance.Self.Bag.items[_loc3_.Place])
         {
            if(this._equipCell.info && (this._equipCell.info as InventoryItemInfo).Place == _loc3_.Place)
            {
               this._equipCell.info = null;
            }
            else
            {
               this.refreshBagList();
            }
         }
         else
         {
            _loc6_ = WishBeadManager.instance.getCanWishBeadData();
            if(_loc6_.items.length != this._equipBagInfo.items.length)
            {
               this._equipBagInfo = _loc6_;
               this._bagList.setData(this._equipBagInfo);
            }
         }
         var _loc5_:InventoryItemInfo = this._equipCell.itemInfo;
         if(_loc5_ && _loc5_.isGold)
         {
            this._equipCell.info = null;
            this._equipCell.info = _loc5_;
         }
      }
      
      private function __clickHelp(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:HelpPrompt = ComponentFactory.Instance.creat("wishBead.wishBeadHelp");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("wishBead.helpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("wishBead.wishBeadHelp.say");
         _loc3_.setButtonPos(174,442);
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function propInfoChangeHandler(param1:BagEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc2_:Dictionary = param1.changedSlots;
         for each(_loc4_ in _loc2_)
         {
            _loc3_ = _loc4_;
         }
         if(_loc3_ && !PlayerManager.Instance.Self.PropBag.items[_loc3_.Place])
         {
            if(this._itemCell.info && (this._itemCell.info as InventoryItemInfo).Place == _loc3_.Place)
            {
               this._itemCell.info = null;
            }
            else
            {
               this._proBagList.setData(WishBeadManager.instance.getWishBeadItemData());
            }
         }
         else
         {
            if(!this._itemCell || !this._itemCell.info)
            {
               return;
            }
            _loc5_ = this._itemCell.info as InventoryItemInfo;
            if(!PlayerManager.Instance.Self.PropBag.items[_loc5_.Place])
            {
               this._itemCell.info = null;
            }
            else
            {
               this._itemCell.setCount(_loc5_.Count);
            }
         }
      }
      
      private function __showTip(param1:CrazyTankSocketEvent) : void
      {
         this._tip.isDisplayerTip = true;
         var _loc2_:int = param1.pkg.readInt();
         switch(_loc2_)
         {
            case 0:
               this._continuousBtn.selected = false;
               this._tip.showSuccess(this.judgeAgain);
               break;
            case 1:
               this._tip.showFail(this.judgeAgain);
               break;
            case 5:
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBead.notCanWish"));
               this.judgeDoBtnStatus(false);
               break;
            case 6:
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBead.equipIsGold"));
               this.judgeDoBtnStatus(false);
               break;
            case 8:
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBead.remainTimeShort"));
               this.judgeDoBtnStatus(false);
               break;
            default:
               this.judgeDoBtnStatus(false);
         }
      }
      
      private function judgeAgain() : void
      {
         if(this._isDispose)
         {
            return;
         }
         if(this._continuousBtn.selected)
         {
            if((this._itemCell.info as InventoryItemInfo).Count <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBead.noBead"));
               return;
            }
            this.sendMess();
         }
         else
         {
            this.judgeDoBtnStatus(false);
         }
      }
      
      private function doHandler(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!this._equipCell.info)
         {
            return;
         }
         if(!this._itemCell.info)
         {
            return;
         }
         if((this._itemCell.info as InventoryItemInfo).Count <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBead.noBead"));
            return;
         }
         if(!(this._equipCell.info as InventoryItemInfo).IsBinds)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirm,false,0,true);
         }
         else
         {
            this.sendMess();
         }
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendMess();
         }
      }
      
      private function sendMess() : void
      {
         this._doBtn.enable = false;
         var _loc1_:InventoryItemInfo = this._equipCell.info as InventoryItemInfo;
         var _loc2_:InventoryItemInfo = this._itemCell.info as InventoryItemInfo;
         SocketManager.Instance.out.sendWishBeadEquip(_loc1_.Place,_loc1_.BagType,_loc1_.TemplateID,_loc2_.Place,_loc2_.BagType,_loc2_.TemplateID);
      }
      
      private function itemEquipChangeHandler(param1:Event) : void
      {
         this._continuousBtn.selected = false;
         this.judgeDoBtnStatus(true);
      }
      
      private function judgeDoBtnStatus(param1:Boolean) : void
      {
         if(this._equipCell.info && this._itemCell.info)
         {
            if(WishBeadManager.instance.getIsEquipMatchWishBead(this._itemCell.info.TemplateID,this._equipCell.info.CategoryID,param1))
            {
               this._doBtn.enable = true;
            }
            else
            {
               this._doBtn.enable = false;
            }
         }
         else
         {
            this._doBtn.enable = false;
         }
      }
      
      protected function __cellDoubleClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:String = "";
         if(param1.target == this._proBagList)
         {
            _loc2_ = WishBeadManager.ITEM_MOVE;
         }
         else
         {
            _loc2_ = WishBeadManager.EQUIP_MOVE;
         }
         var _loc3_:WishBeadEvent = new WishBeadEvent(_loc2_);
         var _loc4_:BagCell = param1.data as BagCell;
         _loc3_.info = _loc4_.info as InventoryItemInfo;
         _loc3_.moveType = 1;
         WishBeadManager.instance.dispatchEvent(_loc3_);
      }
      
      private function cellClickHandler(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BagCell = param1.data as BagCell;
         _loc2_.dragStart();
      }
      
      private function createAcceptDragSprite() : void
      {
         this._leftDrapSprite = new WishBeadLeftDragSprite();
         this._leftDrapSprite.mouseEnabled = false;
         this._leftDrapSprite.mouseChildren = false;
         this._leftDrapSprite.graphics.beginFill(0,0);
         this._leftDrapSprite.graphics.drawRect(0,0,347,404);
         this._leftDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._leftDrapSprite,"wishBeadMainView.leftDrapSpritePos");
         addChild(this._leftDrapSprite);
         this._rightDrapSprite = new WishBeadRightDragSprite();
         this._rightDrapSprite.mouseEnabled = false;
         this._rightDrapSprite.mouseChildren = false;
         this._rightDrapSprite.graphics.beginFill(0,0);
         this._rightDrapSprite.graphics.drawRect(0,0,374,407);
         this._rightDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._rightDrapSprite,"wishBeadMainView.rightDrapSpritePos");
         addChild(this._rightDrapSprite);
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1)
         {
            if(!this._isDispose)
            {
               this.refreshListData();
               PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
               PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
            }
         }
         else
         {
            this.clearCellInfo();
            PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         }
      }
      
      public function clearCellInfo() : void
      {
         if(this._equipCell)
         {
            this._equipCell.clearInfo();
         }
         if(this._itemCell)
         {
            this._itemCell.clearInfo();
         }
      }
      
      public function refreshListData() : void
      {
         if(this._bagList)
         {
            this.refreshBagList();
         }
         if(this._proBagList)
         {
            this._proBagList.setData(WishBeadManager.instance.getWishBeadItemData());
         }
      }
      
      private function removeEvent() : void
      {
         this._bagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._bagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equipCell.removeEventListener(Event.CHANGE,this.itemEquipChangeHandler);
         this._proBagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._proBagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._itemCell.removeEventListener(Event.CHANGE,this.itemEquipChangeHandler);
         this._doBtn.removeEventListener(MouseEvent.CLICK,this.doHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WISHBEADEQUIP,this.__showTip);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__clickHelp);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._tip);
         this._tip = null;
         this._bg = null;
         this._bagList = null;
         this._proBagList = null;
         this._leftDrapSprite = null;
         this._rightDrapSprite = null;
         this._itemCell = null;
         this._equipCell = null;
         this._continuousBtn = null;
         this._doBtn = null;
         this._helpBtn = null;
         this._equipBagInfo = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         this._isDispose = true;
      }
   }
}
