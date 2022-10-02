package petsBag.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.info.PersonalInfoDragInArea;
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.view.item.PetBigItem;
   import petsBag.view.item.PetEquipItem;
   import petsBag.view.item.StarBar;
   
   public class ShowPet extends Sprite implements Disposeable
   {
      
      public static var isPetEquip:Boolean;
       
      
      private var _starBar:StarBar;
      
      private var _petBigItem:PetBigItem;
      
      private var _equipLockBitmapData:BitmapData;
      
      private var _vbox:VBox;
      
      private var _equipList:Array;
      
      private var _currentPetIndex:int;
      
      private var _dragDropArea:PersonalInfoDragInArea;
      
      public function ShowPet()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc2_:PetEquipItem = null;
         this._dragDropArea = new PersonalInfoDragInArea();
         this._equipList = new Array();
         this._vbox = ComponentFactory.Instance.creatCustomObject("petsBag.showPet.vbox");
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = new PetEquipItem(_loc1_);
            _loc2_.id = _loc1_;
            _loc2_.addEventListener(CellEvent.DOUBLE_CLICK,this.doubleClickHander);
            _loc2_.addEventListener(CellEvent.ITEM_CLICK,this.onClickHander);
            this._vbox.addChild(_loc2_);
            this._equipList.push(_loc2_);
            _loc1_++;
         }
         this._starBar = new StarBar();
         this._starBar.x = this._vbox.x + this._vbox.width;
         this._starBar.y = 9;
         addChild(this._starBar);
         this._petBigItem = ComponentFactory.Instance.creat("petsBag.petBigItem");
         this._petBigItem.initTips();
         addChild(this._dragDropArea);
         addChild(this._petBigItem);
         addChild(this._vbox);
      }
      
      private function __showPetTip(param1:Event) : void
      {
         if(isPetEquip == true)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ShowPet.Tip"));
         }
      }
      
      private function onClickHander(param1:CellEvent) : void
      {
         var _loc2_:BagCell = null;
         if(PlayerInfoViewControl.isOpenFromBag)
         {
            _loc2_ = param1.data as BagCell;
            PetBagController.instance().isEquip = true;
            _loc2_.dragStart();
         }
      }
      
      private function doubleClickHander(param1:CellEvent) : void
      {
         if(PlayerInfoViewControl.isOpenFromBag)
         {
            SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,param1.currentTarget.id);
         }
      }
      
      public function addPetEquip(param1:InventoryItemInfo) : void
      {
         this.getBagCell(param1.Place).initBagCell(param1);
      }
      
      public function getBagCell(param1:int) : PetEquipItem
      {
         return this._equipList[param1] as PetEquipItem;
      }
      
      public function delPetEquip(param1:int) : void
      {
         if(this.getBagCell(param1))
         {
            this.getBagCell(param1).clearBagCell();
         }
      }
      
      public function update() : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         this.clearCell();
         var _loc1_:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         if(!_loc1_)
         {
            this._starBar.starNum(!!Boolean(_loc1_) ? int(int(_loc1_.StarLevel)) : int(int(0)));
            this._petBigItem.info = _loc1_;
            return;
         }
         this._starBar.starNum(!!Boolean(_loc1_) ? int(int(_loc1_.StarLevel)) : int(int(0)));
         this._petBigItem.info = _loc1_;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = _loc1_.equipList[_loc2_];
            if(_loc3_)
            {
               _loc4_ = ItemManager.fill(_loc3_) as InventoryItemInfo;
               this.addPetEquip(_loc3_);
            }
            _loc2_++;
         }
      }
      
      public function update2(param1:PetInfo) : void
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:InventoryItemInfo = null;
         this.clearCell();
         var _loc2_:PetInfo = param1;
         if(!_loc2_)
         {
            this._starBar.starNum(!!Boolean(_loc2_) ? int(int(_loc2_.StarLevel)) : int(int(0)));
            this._petBigItem.info = _loc2_;
            return;
         }
         this._starBar.starNum(!!Boolean(_loc2_) ? int(int(_loc2_.StarLevel)) : int(int(0)));
         this._petBigItem.info = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            _loc4_ = _loc2_.equipList[_loc3_];
            if(_loc4_)
            {
               _loc5_ = ItemManager.fill(_loc4_) as InventoryItemInfo;
               this.addPetEquip(_loc4_);
            }
            _loc3_++;
         }
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = this._equipList.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.getBagCell(this._equipList[_loc2_]).removeEventListener(CellEvent.DOUBLE_CLICK,this.doubleClickHander);
            _loc2_++;
         }
      }
      
      private function clearCell() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.delPetEquip(_loc1_);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._petBigItem)
         {
            ObjectUtils.disposeObject(this._petBigItem);
            this._petBigItem = null;
         }
         if(this._equipLockBitmapData)
         {
            ObjectUtils.disposeObject(this._equipLockBitmapData);
            this._equipLockBitmapData = null;
         }
         if(this._vbox)
         {
            ObjectUtils.disposeAllChildren(this._vbox);
            ObjectUtils.disposeObject(this._vbox);
            this._vbox = null;
         }
         if(this._starBar)
         {
            ObjectUtils.disposeObject(this._starBar);
            this._starBar = null;
         }
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
