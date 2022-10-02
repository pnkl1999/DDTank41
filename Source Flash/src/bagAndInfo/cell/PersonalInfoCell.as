package bagAndInfo.cell
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import petsBag.controller.PetBagController;
   import gemstone.info.GemstoneInfo;
   
   public class PersonalInfoCell extends BagCell
   {
	  public var gemstoneList:Vector.<GemstoneInfo>;
	   
	  private var _isGemstone:Boolean = false; 
      
      private var _shineObject:MovieClip;
      
      public function PersonalInfoCell(param1:int = 0, param2:ItemTemplateInfo = null, param3:Boolean = true)
      {
         super(param1,param2,param3);
         _bg.visible = false;
         _picPos = new Point(2,0);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         addEventListener(InteractiveEvent.CLICK,this.onClick);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(InteractiveEvent.CLICK,this.onClick);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         DoubleClickManager.Instance.disableDoubleClick(this);
      }
      
      override public function dragStart() : void
      {
         if(_info && !locked && stage && allowDrag)
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
            {
               SoundManager.instance.play("008");
               locked = true;
            }
         }
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
      }
      
      protected function onClick(param1:InteractiveEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this));
      }
      
      protected function onDoubleClick(param1:InteractiveEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(info)
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,this));
         }
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            param1.action = DragEffect.NONE;
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         if(_loc2_.Place < 29 && _loc2_.BagType != BagInfo.PROPBAG)
         {
            return;
         }
         if((_loc2_.BindType == 1 || _loc2_.BindType == 2 || _loc2_.BindType == 3) && _loc2_.IsBinds == false && _loc2_.TemplateID != EquipType.WISHBEAD_ATTACK && _loc2_.TemplateID != EquipType.WISHBEAD_DEFENSE && _loc2_.TemplateID != EquipType.WISHBEAD_AGILE)
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onBindResponse);
            temInfo = _loc2_;
            DragManager.acceptDrag(this,DragEffect.NONE);
            return;
         }
         if(_loc2_)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.Place < 31)
            {
               DragManager.acceptDrag(this);
            }
            else if(PlayerManager.Instance.Self.canEquip(_loc2_))
            {
               if(_loc2_.CategoryID == 50 && int(_loc2_.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level)
               {
                  SocketManager.Instance.out.addPetEquip(_loc2_.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               else if(_loc2_.CategoryID == 51 && int(_loc2_.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level)
               {
                  SocketManager.Instance.out.addPetEquip(_loc2_.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               else if(_loc2_.CategoryID == 52 && int(_loc2_.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level)
               {
                  SocketManager.Instance.out.addPetEquip(_loc2_.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               else
               {
                  if(_loc2_.CategoryID == 52 || _loc2_.CategoryID == 51 || _loc2_.CategoryID == 50)
                  {
                     DragManager.acceptDrag(this);
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petEquipLevelNo"));
                     return;
                  }
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc2_.Place,BagInfo.EQUIPBAG,PlayerManager.Instance.getDressEquipPlace(_loc2_),_loc2_.Count);
               }
               DragManager.acceptDrag(this,DragEffect.MOVE);
            }
            else
            {
               DragManager.acceptDrag(this,DragEffect.NONE);
            }
         }
      }
      
      override public function checkOverDate() : void
      {
         if(_bgOverDate)
         {
            _bgOverDate.visible = false;
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendDefy();
         }
      }
      
      private function __onBindResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendBindDefy();
         }
      }
      
      private function sendDefy() : void
      {
         var _loc1_:int = 0;
         if(PlayerManager.Instance.Self.canEquip(temInfo))
         {
            _loc1_ = PlayerManager.Instance.getDressEquipPlace(temInfo);
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,temInfo.Place,BagInfo.EQUIPBAG,_loc1_);
         }
      }
      
      private function sendBindDefy() : void
      {
         if(PlayerManager.Instance.Self.canEquip(temInfo))
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,temInfo.Place,BagInfo.EQUIPBAG,_place,temInfo.Count);
         }
      }
      
      private function getCellIndex(param1:ItemTemplateInfo) : Array
      {
         if(EquipType.isWeddingRing(param1))
         {
            return [9,10,16];
         }
         switch(param1.CategoryID)
         {
            case EquipType.HEAD:
               return [0];
            case EquipType.GLASS:
               return [1];
            case EquipType.HAIR:
               return [2];
            case EquipType.EFF:
               return [3];
            case EquipType.CLOTH:
               return [4];
            case EquipType.FACE:
               return [5];
            case EquipType.ARM:
               return [6];
            case EquipType.ARMLET:
            case EquipType.TEMPARMLET:
               return [7,8];
            case EquipType.RING:
            case EquipType.TEMPRING:
               return [9,10];
            case EquipType.SUITS:
               return [11];
            case EquipType.NECKLACE:
               return [12];
            case EquipType.WING:
               return [13];
            case EquipType.CHATBALL:
               return [14];
            case EquipType.OFFHAND:
               return [15];
            default:
               return [-1];
         }
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            param1.action = DragEffect.NONE;
            super.dragStop(param1);
         }
         locked = false;
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
      }
      
      public function shine() : void
      {
         if(this._shineObject == null)
         {
            this._shineObject = ComponentFactory.Instance.creatCustomObject("asset.core.playerInfoCellShine") as MovieClip;
         }
         addChild(this._shineObject);
         this._shineObject.gotoAndPlay(1);
      }
      
      public function stopShine() : void
      {
         if(this._shineObject != null && this.contains(this._shineObject))
         {
            removeChild(this._shineObject);
         }
         if(this._shineObject != null)
         {
            this._shineObject.gotoAndStop(1);
         }
      }
      
      override public function updateCount() : void
      {
         if(_tbxCount)
         {
            if(_info && itemInfo && itemInfo.Count > 1)
            {
               _tbxCount.text = String(itemInfo.Count);
               _tbxCount.visible = true;
               addChild(_tbxCount);
            }
            else
            {
               _tbxCount.visible = false;
            }
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(this._shineObject != null)
         {
            ObjectUtils.disposeAllChildren(this._shineObject);
         }
         this._shineObject = null;
         super.dispose();
      }
   }
}
