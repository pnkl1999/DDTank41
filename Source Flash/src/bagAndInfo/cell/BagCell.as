package bagAndInfo.cell
{
   import bagAndInfo.bag.BreakGoodsBtn;
   import bagAndInfo.bag.ContinueGoodsBtn;
   import bagAndInfo.bag.SellGoodsBtn;
   import bagAndInfo.bag.SellGoodsFrame;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import petsBag.controller.PetBagController;
   import petsBag.view.item.SkillItem;
   
   public class BagCell extends BaseCell
   {
      protected var _place:int;
      
      protected var _tbxCount:FilterFrameText;
      
      protected var _bgOverDate:Bitmap;
      
      protected var _cellMouseOverBg:Bitmap;
      
      protected var _cellMouseOverFormer:Bitmap;
      
      private var _mouseOverEffBoolean:Boolean;
      
      protected var _bagType:int;
      
      protected var _isShowIsUsedBitmap:Boolean;
      
      protected var _isUsed:Boolean;
      
      protected var _isUsedBitmap:Bitmap;
      
      private var placeArr:Array;
      
      protected var temInfo:InventoryItemInfo;
      
      private var _sellFrame:SellGoodsFrame;
      
      public function BagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
         this.placeArr = [0,1,2];
         this._mouseOverEffBoolean = param5;
         super(!!Boolean(param4) ? param4 : ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellBgAsset"),param2,param3);
         this._place = param1;
      }
      
      public function set mouseOverEffBoolean(param1:Boolean) : void
      {
         this._mouseOverEffBoolean = param1;
      }
      
      public function get bagType() : int
      {
         return this._bagType;
      }
      
      public function set bagType(param1:int) : void
      {
         this._bagType = param1;
      }
      
      public function setBgVisible(param1:Boolean) : void
      {
         _bg.visible = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         locked = false;
         this._bgOverDate = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.overDateBgAsset");
         if(this._mouseOverEffBoolean == true)
         {
            this._cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
            this._cellMouseOverFormer = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverShareBG");
            addChild(this._cellMouseOverBg);
            addChild(this._cellMouseOverFormer);
         }
         addChild(this._bgOverDate);
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("BagCellCountText");
         this._tbxCount.mouseEnabled = false;
         addChild(this._tbxCount);
         this.updateCount();
         this.checkOverDate();
         this.updateBgVisible(false);
      }
      
      public function set isUsed(param1:Boolean) : void
      {
         this._isUsed = param1;
      }
      
      public function get isUsed() : Boolean
      {
         return this._isUsed;
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         if(this.itemInfo)
         {
            this.isUsed = this.itemInfo.BagType == 0 && this.itemInfo.Place < 17;
         }
         if(param1 && this._isShowIsUsedBitmap && this.isUsed)
         {
            this.addIsUsedBitmap();
         }
         else if(!param1)
         {
            if(this._isUsedBitmap)
            {
               ObjectUtils.disposeObject(this._isUsedBitmap);
            }
            this._isUsedBitmap = null;
         }
         this.updateCount();
         this.checkOverDate();
         if(info is InventoryItemInfo)
         {
            this.locked = this.info["lock"];
         }
      }
      
      protected function addIsUsedBitmap() : void
      {
         this._isUsedBitmap = ComponentFactory.Instance.creat("asset.store.isUsedBitmap");
         this._isUsedBitmap.x = 22;
         this._isUsedBitmap.y = 1;
         addChild(this._isUsedBitmap);
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         super.onMouseOver(param1);
         this.updateBgVisible(true);
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         super.onMouseOut(param1);
         this.updateBgVisible(false);
      }
      
      public function onParentMouseOver(param1:Bitmap) : void
      {
         if(!this._cellMouseOverBg)
         {
            this._cellMouseOverBg = param1;
            addChild(this._cellMouseOverBg);
            super.setChildIndex(this._cellMouseOverBg,1);
            this.updateBgVisible(true);
         }
      }
      
      public function onParentMouseOut() : void
      {
         if(this._cellMouseOverBg)
         {
            this.updateBgVisible(false);
            this._cellMouseOverBg = null;
         }
      }
      
      protected function updateBgVisible(param1:Boolean) : void
      {
         if(this._cellMouseOverBg)
         {
            this._cellMouseOverBg.visible = param1;
            this._cellMouseOverFormer.visible = param1;
            setChildIndex(this._cellMouseOverFormer,numChildren - 1);
         }
      }
      
	  override public function dragDrop(param1:DragEffect) : void
	  {
		  var _loc3_:* = null;
		  var _loc2_:* = null;
		  if(PlayerManager.Instance.Self.bagLocked)
		  {
			  BaglockedManager.Instance.show();
			  param1.action = "none";
			  super.dragStop(param1);
			  return;
		  }
		  if(param1.data is InventoryItemInfo)
		  {
			  _loc3_ = param1.data as InventoryItemInfo;
			  if(locked)
			  {
				  if(_loc3_ == this.info)
				  {
					  this.locked = false;
					  DragManager.acceptDrag(this);
				  }
				  else
				  {
					  DragManager.acceptDrag(this,"none");
				  }
			  }
			  else
			  {
				  if(this._bagType == 11 || _loc3_.BagType == 11 || this._bagType == 51 || _loc3_.BagType == 51)
				  {
					  if(param1.action == "split")
					  {
						  param1.action = "none";
					  }
					  else if(this._bagType != 11 && this._bagType != 51)
					  {
						  SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,this._bagType,this.place,_loc3_.Count);
						  param1.action = "none";
					  }
					  else if(this._bagType == _loc3_.BagType)
					  {
						  if((this._bagType == 11 || _loc3_.BagType == 11) && this.place >= PlayerManager.Instance.Self.consortiaInfo.StoreLevel * 10)
						  {
							  param1.action = "none";
						  }
						  else
						  {
							  SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,_loc3_.BagType,this.place,_loc3_.Count);
						  }
					  }
					  else if((this._bagType == 11 || _loc3_.BagType == 11) && PlayerManager.Instance.Self.consortiaInfo.StoreLevel < 1)
					  {
						  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick"));
						  param1.action = "none";
					  }
					  else
					  {
						  SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,this._bagType,this.place,_loc3_.Count);
						  param1.action = "none";
					  }
				  }
				  else if(_loc3_.BagType == this._bagType)
				  {
					  if(!this.itemInfo)
					  {
						  if(_loc3_.isMoveSpace)
						  {
							  SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,_loc3_.BagType,this.place,_loc3_.Count);
						  }
						  param1.action = "none";
						  return;
					  }
					  if(_loc3_.CategoryID == this.itemInfo.CategoryID && _loc3_.Place <= 30 && (_loc3_.BindType == 1 || _loc3_.BindType == 2 || _loc3_.BindType == 3) && this.itemInfo.IsBinds == false && EquipType.canEquip(_loc3_))
					  {
						  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2);
						  _loc2_.addEventListener("response",this.__onCellResponse);
						  this.temInfo = _loc3_;
					  }
					  else if(EquipType.isHealStone(_loc3_))
					  {
						  if(PlayerManager.Instance.Self.Grade >= int(_loc3_.Property1))
						  {
							  SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,_loc3_.BagType,this.place,_loc3_.Count);
							  param1.action = "none";
						  }
						  else if(param1.action == "move")
						  {
							  if(param1.source is BagCell)
							  {
								  BagCell(param1.source).locked = false;
							  }
						  }
						  else
						  {
							  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade",_loc3_.Property1));
						  }
					  }
					  else
					  {
						  SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,_loc3_.BagType,this.place,_loc3_.Count);
						  param1.action = "none";
					  }
				  }
				  else if(_loc3_.BagType == 12)
				  {
					  if(_loc3_.CategoryID == 20 || _loc3_.CategoryID == 34)
					  {
						  SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,this._bagType,this.place,_loc3_.Count);
					  }
					  param1.action = "none";
				  }
				  else
				  {
					  param1.action = "none";
				  }
				  DragManager.acceptDrag(this);
			  }
		  }
		  else if(param1.data is SellGoodsBtn)
		  {
			  if(!locked && _info && this._bagType != 11 && this._bagType != 51)
			  {
				  locked = true;
				  DragManager.acceptDrag(this);
			  }
		  }
		  else if(param1.data is ContinueGoodsBtn)
		  {
			  if(!locked && _info && this._bagType != 11 && this._bagType != 51)
			  {
				  locked = true;
				  DragManager.acceptDrag(this,"none");
			  }
		  }
		  else if(param1.data is BreakGoodsBtn)
		  {
			  if(!locked && _info)
			  {
				  DragManager.acceptDrag(this);
			  }
		  }
	  }
	  
	  
      public function dragDrop1(param1:DragEffect) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:BaseAlerFrame = null;
         if(param1.source is SkillItem)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            param1.action = DragEffect.NONE;
            super.dragStop(param1);
            return;
         }
         if(param1.data is InventoryItemInfo)
         {
            _loc2_ = param1.data as InventoryItemInfo;
            if(locked)
            {
               if(_loc2_ == this.info)
               {
                  this.locked = false;
                  DragManager.acceptDrag(this);
               }
               else
               {
                  DragManager.acceptDrag(this,DragEffect.NONE);
               }
            }
            else
            {
               if(this._bagType == 11 || _loc2_.BagType == 11)
               {
                  if(param1.action == DragEffect.SPLIT)
                  {
                     param1.action = DragEffect.NONE;
                  }
                  else if(this._bagType != 11)
                  {
                     SocketManager.Instance.out.sendMoveGoods(BagInfo.CONSORTIA,_loc2_.Place,this._bagType,this.place,_loc2_.Count);
                     param1.action = DragEffect.NONE;
                  }
                  else if(this._bagType == _loc2_.BagType)
                  {
                     if(this.place >= PlayerManager.Instance.Self.consortiaInfo.StoreLevel * 10)
                     {
                        param1.action = DragEffect.NONE;
                     }
                     else
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,_loc2_.BagType,this.place,_loc2_.Count);
                     }
                  }
                  else if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel < 1)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick"));
                     param1.action = DragEffect.NONE;
                  }
                  else
                  {
                     SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,this._bagType,this.place,_loc2_.Count);
                     param1.action = DragEffect.NONE;
                  }
               }
               else if(_loc2_.BagType == this._bagType)
               {
                  if(!this.itemInfo)
                  {
                     if(_loc2_.isMoveSpace)
                     {
                        if(!PetBagController.instance().petModel.currentPetInfo)
                        {
                           SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,_loc2_.BagType,this.place,_loc2_.Count);
                           param1.action = DragEffect.NONE;
                           return;
                        }
                        if(_loc2_.CategoryID == 50 && int(_loc2_.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && _loc2_.Place == 0)
                        {
                           SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,0);
                           PetBagController.instance().isEquip = false;
                        }
                        else if(_loc2_.CategoryID == 51 && int(_loc2_.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && _loc2_.Place == 1)
                        {
                           SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,1);
                           PetBagController.instance().isEquip = false;
                        }
                        else if(_loc2_.CategoryID == 52 && int(_loc2_.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && _loc2_.Place == 2)
                        {
                           SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,2);
                           PetBagController.instance().isEquip = false;
                        }
                        else
                        {
                           SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,_loc2_.BagType,this.place,_loc2_.Count);
                        }
                     }
                     param1.action = DragEffect.NONE;
                     return;
                  }
                  if(_loc2_.CategoryID == this.itemInfo.CategoryID && _loc2_.Place <= 30 && (_loc2_.BindType == 1 || _loc2_.BindType == 2 || _loc2_.BindType == 3) && this.itemInfo.IsBinds == false && EquipType.canEquip(_loc2_))
                  {
                     _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
                     _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onCellResponse);
                     this.temInfo = _loc2_;
                  }
                  else if(EquipType.isHealStone(_loc2_))
                  {
                     if(PlayerManager.Instance.Self.Grade >= int(_loc2_.Property1))
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,_loc2_.BagType,this.place,_loc2_.Count);
                        param1.action = DragEffect.NONE;
                     }
                     else if(param1.action == DragEffect.MOVE)
                     {
                        if(param1.source is BagCell)
                        {
                           BagCell(param1.source).locked = false;
                        }
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade",_loc2_.Property1));
                     }
                  }
                  else
                  {
                     if(!PetBagController.instance().petModel.currentPetInfo)
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,_loc2_.BagType,this.place,_loc2_.Count);
                        param1.action = DragEffect.NONE;
                        return;
                     }
                     if(PetBagController.instance().isEquip)
                     {
                        PetBagController.instance().isEquip = false;
                        param1.action = DragEffect.NONE;
                        DragManager.acceptDrag(this);
                        return;
                     }
                     if(_loc2_.CategoryID == 50 && int(_loc2_.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && _loc2_.Place == 0)
                     {
                        SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,0);
                     }
                     else if(_loc2_.CategoryID == 51 && int(_loc2_.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && _loc2_.Place == 1)
                     {
                        SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,1);
                     }
                     else if(_loc2_.CategoryID == 52 && int(_loc2_.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && _loc2_.Place == 2)
                     {
                        SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,2);
                     }
                     else
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,_loc2_.BagType,this.place,_loc2_.Count);
                     }
                     if(!this.isPetBagCellMove(param1.source as BagCell,this))
                     {
                        param1.action = DragEffect.NONE;
                     }
                  }
               }
               else if(_loc2_.BagType == BagInfo.STOREBAG)
               {
                  if(_loc2_.CategoryID == EquipType.TEXP || _loc2_.CategoryID == EquipType.FOOD)
                  {
                     SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,this._bagType,this.place,_loc2_.Count);
                  }
                  param1.action = DragEffect.NONE;
               }
               else
               {
                  param1.action = DragEffect.NONE;
               }
               DragManager.acceptDrag(this);
            }
         }
         else if(param1.data is SellGoodsBtn)
         {
            if(!locked && _info && this._bagType != 11)
            {
               locked = true;
               DragManager.acceptDrag(this);
            }
         }
         else if(param1.data is ContinueGoodsBtn)
         {
            if(!locked && _info && this._bagType != 11)
            {
               locked = true;
               DragManager.acceptDrag(this,DragEffect.NONE);
            }
         }
         else if(param1.data is BreakGoodsBtn)
         {
            if(!locked && _info)
            {
               DragManager.acceptDrag(this);
            }
         }
      }
      
      private function isPetBagCellMove(param1:BagCell, param2:BagCell) : Boolean
      {
         var _loc3_:InventoryItemInfo = param2.info as InventoryItemInfo;
         var _loc4_:InventoryItemInfo = param1.info as InventoryItemInfo;
         if(this.placeArr.indexOf(_loc3_.Place) != -1 && this.placeArr.indexOf(_loc4_.Place) == -1)
         {
            return false;
         }
         return true;
      }
      
      private function sendDefy() : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.canEquip(this.temInfo))
         {
            SocketManager.Instance.out.sendMoveGoods(this.temInfo.BagType,this.temInfo.Place,this.temInfo.BagType,this.place,this.temInfo.Count);
         }
      }
      
      override public function dragStart() : void
      {
         super.dragStart();
         if(_info && _pic.numChildren > 0)
         {
            dispatchEvent(new CellEvent(CellEvent.DRAGSTART,this.info,true));
         }
      }
      
	  override public function dragStop(param1:DragEffect) : void
	  {
		  var _loc3_:int = 0;
		  var _loc4_:BagCell = null;
		  SoundManager.instance.play("008");
		  dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
		  var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
		  if(param1.action == DragEffect.MOVE && param1.target == null)
		  {
			  if(_loc2_.CategoryID == 50 || _loc2_.CategoryID == 51 || _loc2_.CategoryID == 52)
			  {
				  if(param1.target is BagCell)
				  {
					  _loc4_ = param1.target as BagCell;
					  if(_loc2_.CategoryID == _loc4_.info.CategoryID)
					  {
						  if(this.placeArr.indexOf(_loc2_.Place) != -1)
						  {
							  _loc3_ = _loc4_.itemInfo.Place;
						  }
						  else
						  {
							  _loc3_ = _loc2_.Place;
						  }
						  SocketManager.Instance.out.addPetEquip(_loc3_,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
					  }
				  }
				  else
				  {
					  SocketManager.Instance.out.addPetEquip(_loc2_.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
				  }
			  }
		  }
		  if(param1.action == DragEffect.MOVE && param1.target != null)
		  {
			  if(_loc2_.CategoryID == 50 || _loc2_.CategoryID == 51 || _loc2_.CategoryID == 52)
			  {
				  param1.action = DragEffect.NONE;
				  super.dragStop(param1);
			  }
			  return;
		  }
		  if(param1.action == DragEffect.MOVE && param1.target == null)
		  {
			  if(_loc2_.CategoryID == 50 || _loc2_.CategoryID == 51 || _loc2_.CategoryID == 52)
			  {
				  param1.action = DragEffect.NONE;
				  super.dragStop(param1);
			  }
			  else if(_loc2_ && _loc2_.BagType == BagInfo.CONSORTIA)
			  {
				  param1.action = DragEffect.NONE;
				  super.dragStop(param1);
			  }
			  else if(_loc2_ && _loc2_.BagType == BagInfo.STOREBAG)
			  {
				  locked = false;
			  }
			  else if(_loc2_.CategoryID == 34)
			  {
				  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
				  param1.action = DragEffect.NONE;
				  super.dragStop(param1);
			  }
			  else
			  {
				  locked = false;
				  this.sellItem(_loc2_);
			  }
		  }
		  else if(param1.action == DragEffect.SPLIT && param1.target == null)
		  {
			  locked = false;
		  }
		  else
		  {
			  super.dragStop(param1);
		  }
	  }
	  
	  
	  

      public function dragStop1(param1:DragEffect) : void
      {
         var _loc3_:int = 0;
         var _loc4_:BagCell = null;
         SoundManager.instance.play("008");
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(param1.action == DragEffect.MOVE && param1.target == null)
         {
            if(_loc2_.CategoryID == 50 || _loc2_.CategoryID == 51 || _loc2_.CategoryID == 52)
            {
               if(param1.target is BagCell)
               {
                  _loc4_ = param1.target as BagCell;
                  if(_loc2_.CategoryID == _loc4_.info.CategoryID)
                  {
                     if(this.placeArr.indexOf(_loc2_.Place) != -1)
                     {
                        _loc3_ = _loc4_.itemInfo.Place;
                     }
                     else
                     {
                        _loc3_ = _loc2_.Place;
                     }
                     SocketManager.Instance.out.addPetEquip(_loc3_,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
                  }
               }
               else
               {
                  SocketManager.Instance.out.addPetEquip(_loc2_.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
            }
         }
         if(param1.action == DragEffect.MOVE && param1.target != null)
         {
            if(_loc2_.CategoryID == 50 || _loc2_.CategoryID == 51 || _loc2_.CategoryID == 52)
            {
               param1.action = DragEffect.NONE;
               super.dragStop(param1);
            }
            return;
         }
         if(param1.action == DragEffect.MOVE && param1.target == null)
         {
            if(_loc2_.CategoryID == 50 || _loc2_.CategoryID == 51 || _loc2_.CategoryID == 52)
            {
               param1.action = DragEffect.NONE;
               super.dragStop(param1);
            }
            else if(_loc2_ && _loc2_.BagType == BagInfo.CONSORTIA)
            {
               param1.action = DragEffect.NONE;
               super.dragStop(param1);
            }
            else if(_loc2_ && _loc2_.BagType == BagInfo.STOREBAG)
            {
               locked = false;
            }
            else if(_loc2_.CategoryID == 34)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
               param1.action = DragEffect.NONE;
               super.dragStop(param1);
            }
            else
            {
               locked = false;
               this.sellItem(_loc2_);
            }
         }
         else if(param1.action == DragEffect.SPLIT && param1.target == null)
         {
            locked = false;
         }
         else
         {
            super.dragStop(param1);
         }
      }
      
      public function dragCountStart(param1:int) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:String = null;
         if(_info && !locked && stage && param1 != 0)
         {
            _loc2_ = this.itemInfo;
            _loc3_ = DragEffect.MOVE;
            if(param1 != this.itemInfo.Count)
            {
               _loc2_ = new InventoryItemInfo();
               _loc2_.ItemID = this.itemInfo.ItemID;
               _loc2_.BagType = this.itemInfo.BagType;
               _loc2_.Place = this.itemInfo.Place;
               _loc2_.IsBinds = this.itemInfo.IsBinds;
               _loc2_.BeginDate = this.itemInfo.BeginDate;
               _loc2_.ValidDate = this.itemInfo.ValidDate;
               _loc2_.Count = param1;
               _loc2_.NeedSex = this.itemInfo.NeedSex;
               _loc3_ = DragEffect.SPLIT;
            }
            if(DragManager.startDrag(this,_loc2_,createDragImg(),stage.mouseX,stage.mouseY,_loc3_))
            {
               locked = true;
            }
         }
      }
      
      public function sellItem(param1:InventoryItemInfo = null) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(EquipType.isValuableEquip(info))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip"));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip"));
            return;
         }
         if(EquipType.isPetSpeciallFood(info))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this.showSellFrame(param1);
         }
      }
      
      private function showSellFrame(param1:InventoryItemInfo) : void
      {
         if(this._sellFrame == null)
         {
            this._sellFrame = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame");
            this._sellFrame.itemInfo = param1;
            this._sellFrame.addEventListener(SellGoodsFrame.CANCEL,this.disposeSellFrame);
            this._sellFrame.addEventListener(SellGoodsFrame.OK,this.disposeSellFrame);
         }
         LayerManager.Instance.addToLayer(this._sellFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function disposeSellFrame(param1:Event) : void
      {
         if(this._sellFrame)
         {
            this._sellFrame.dispose();
            this._sellFrame.removeEventListener(SellGoodsFrame.CANCEL,this.disposeSellFrame);
            this._sellFrame.removeEventListener(SellGoodsFrame.OK,this.disposeSellFrame);
         }
         this._sellFrame = null;
      }
      
      protected function __onCellResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(EquipType.isHealStone(info))
            {
               if(PlayerManager.Instance.Self.Grade >= int(info.Property1))
               {
                  this.sendDefy();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade",info.Property1));
               }
            }
            else
            {
               this.sendDefy();
            }
         }
      }
      
      private function getAlertInfo() : AlertInfo
      {
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.autoDispose = true;
         _loc1_.showSubmit = true;
         _loc1_.showCancel = true;
         _loc1_.enterEnable = true;
         _loc1_.escEnable = true;
         _loc1_.moveEnable = false;
         _loc1_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc1_.data = LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.sure").replace("{0}",InventoryItemInfo(_info).Count * _info.ReclaimValue + (_info.ReclaimType == 1 ? LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold") : (_info.ReclaimType == 2 ? LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken") : "")));
         return _loc1_;
      }
      
      private function confirmCancel() : void
      {
         locked = false;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         return _info as InventoryItemInfo;
      }
      
      public function replaceBg(param1:Sprite) : void
      {
         _bg = param1;
      }
      
      public function updateCount() : void
      {
         if(this._tbxCount)
         {
            if(_info && this.itemInfo && this.itemInfo.MaxCount > 1)
            {
               this._tbxCount.text = String(this.itemInfo.Count);
               this._tbxCount.visible = true;
               addChild(this._tbxCount);
            }
            else
            {
               this._tbxCount.visible = false;
            }
         }
      }
      
      public function checkOverDate() : void
      {
         if(this._bgOverDate)
         {
            if(this.itemInfo && this.itemInfo.getRemainDate() <= 0)
            {
               this._bgOverDate.visible = true;
               addChild(this._bgOverDate);
               _pic.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
            }
            else
            {
               this._bgOverDate.visible = false;
               if(_pic)
               {
                  _pic.filters = [];
               }
            }
         }
      }
      
      public function setCount(param1:int) : void
      {
         if(this._tbxCount)
         {
            this._tbxCount.text = String(param1);
            this._tbxCount.visible = true;
            this._tbxCount.x = _contentWidth - this._tbxCount.width;
            this._tbxCount.y = _contentHeight - this._tbxCount.height;
            addChild(this._tbxCount);
         }
      }
      
      public function set BGVisible(param1:Boolean) : void
      {
         _bg.visible = param1;
      }
      
      override public function dispose() : void
      {
         if(this._isUsedBitmap)
         {
            ObjectUtils.disposeObject(this._isUsedBitmap);
         }
         this._isUsedBitmap = null;
         if(this._tbxCount)
         {
            ObjectUtils.disposeObject(this._tbxCount);
         }
         this._tbxCount = null;
         if(this._bgOverDate)
         {
            ObjectUtils.disposeObject(this._bgOverDate);
         }
         this._bgOverDate = null;
         if(this._cellMouseOverBg)
         {
            ObjectUtils.disposeObject(this._cellMouseOverBg);
         }
         this._cellMouseOverBg = null;
         if(this._cellMouseOverFormer)
         {
            ObjectUtils.disposeObject(this._cellMouseOverFormer);
         }
         this._cellMouseOverFormer = null;
         super.dispose();
      }
      
      public function refreshTbxPos() : void
      {
         this._tbxCount.x = _pic.x + _contentWidth - this._tbxCount.width - 4;
         this._tbxCount.y = _pic.y + _contentHeight - this._tbxCount.height - 2;
      }
      
      public function refreshCountTxtPos() : void
      {
         if(this._tbxCount)
         {
            this._tbxCount.x = _contentWidth - this._tbxCount.width;
            this._tbxCount.y = _contentHeight - this._tbxCount.height;
         }
      }
      
      public function setCountNotVisible() : void
      {
         if(this._tbxCount)
         {
            this._tbxCount.visible = false;
         }
      }
	  
	  public function lightPic() : void
	  {
		  if(_pic)
		  {
			  _pic.filters = [];
		  }
	  }
	  
	  public function grayPic() : void
	  {
		  _pic.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
	  }
   }
}
