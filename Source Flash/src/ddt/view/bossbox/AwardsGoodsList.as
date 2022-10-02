package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   
   public class AwardsGoodsList extends Sprite implements Disposeable
   {
       
      
      private var _goodsList:Array;
      
      private var _list:SimpleTileList;
      
      private var panel:ScrollPanel;
      
      private var _cells:Array;
      
      public function AwardsGoodsList()
      {
         super();
         this.initList();
      }
      
      protected function initList() : void
      {
         this._list = new SimpleTileList(2);
         this._list.vSpace = 12;
         this._list.hSpace = 110;
         this.panel = ComponentFactory.Instance.creat("TimeBoxScrollpanel");
         addChild(this.panel);
      }
      
      public function show(param1:Array) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:BoxAwardsCell = null;
         var _loc5_:BoxGoodsTempInfo = null;
         this._goodsList = param1;
         this._cells = new Array();
         this._list.beginChanges();
         var _loc2_:int = 0;
         while(_loc2_ < this._goodsList.length)
         {
            if(this._goodsList[_loc2_] is InventoryItemInfo)
            {
               _loc3_ = this._goodsList[_loc2_];
               _loc3_.IsJudge = true;
            }
            else
            {
               _loc5_ = this._goodsList[_loc2_] as BoxGoodsTempInfo;
               _loc3_ = this.getTemplateInfo(_loc5_.TemplateId) as InventoryItemInfo;
               _loc3_.IsBinds = _loc5_.IsBind;
               _loc3_.LuckCompose = _loc5_.LuckCompose;
               _loc3_.DefendCompose = _loc5_.DefendCompose;
               _loc3_.AttackCompose = _loc5_.AttackCompose;
               _loc3_.AgilityCompose = _loc5_.AgilityCompose;
               _loc3_.StrengthenLevel = _loc5_.StrengthenLevel;
               _loc3_.ValidDate = _loc5_.ItemValid;
               _loc3_.IsJudge = true;
               _loc3_.Count = _loc5_.ItemCount;
            }
            _loc4_ = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
            _loc4_.info = _loc3_;
            _loc4_.count = _loc3_.Count;
            this._list.addChild(_loc4_);
            this._cells.push(_loc4_);
            _loc2_++;
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = this._goodsList.length > 6 ? int(int(ScrollPanel.ON)) : int(int(ScrollPanel.OFF));
         this.panel.commitChanges();
      }
      
      public function showForVipLevelUpAward(param1:Array) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:VipBoxAwardsCell = null;
         var _loc5_:BoxGoodsTempInfo = null;
         this._goodsList = param1;
         this._cells = new Array();
         this._list.dispose();
         this._list = new SimpleTileList(3);
         this._list.vSpace = 12;
         this._list.hSpace = 110;
         this._list.beginChanges();
         var _loc2_:int = 0;
         while(_loc2_ < this._goodsList.length)
         {
            if(this._goodsList[_loc2_] is InventoryItemInfo)
            {
               _loc3_ = this._goodsList[_loc2_];
               _loc3_.IsJudge = true;
            }
            else
            {
               _loc5_ = this._goodsList[_loc2_] as BoxGoodsTempInfo;
               _loc3_ = this.getTemplateInfo(_loc5_.TemplateId) as InventoryItemInfo;
               _loc3_.IsBinds = _loc5_.IsBind;
               _loc3_.LuckCompose = _loc5_.LuckCompose;
               _loc3_.DefendCompose = _loc5_.DefendCompose;
               _loc3_.AttackCompose = _loc5_.AttackCompose;
               _loc3_.AgilityCompose = _loc5_.AgilityCompose;
               _loc3_.StrengthenLevel = _loc5_.StrengthenLevel;
               _loc3_.ValidDate = _loc5_.ItemValid;
               _loc3_.IsJudge = true;
               _loc3_.Count = _loc5_.ItemCount;
            }
            _loc4_ = ComponentFactory.Instance.creatCustomObject("vip.BoxAwardsCell");
            _loc4_.info = _loc3_;
            _loc4_.count = _loc3_.Count;
            this._list.addChild(_loc4_);
            this._cells.push(_loc4_);
            _loc2_++;
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.width = 488;
         this.panel.height = 178;
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = ScrollPanel.OFF;
         this.panel.commitChanges();
      }
      
      public function showForVipAward(param1:Array) : void
      {
         var _loc3_:BoxAwardsCell = null;
         var _loc2_:int = 0;
         _loc3_ = null;
         this._goodsList = param1;
         this._cells = new Array();
         this._list.dispose();
         this._list = new SimpleTileList(3);
         this._list.vSpace = 12;
         this._list.hSpace = 110;
         this._list.beginChanges();
         _loc2_ = 0;
         while(_loc2_ < this._goodsList.length)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
            _loc3_.mouseChildren = false;
            _loc3_.mouseEnabled = false;
            _loc3_.info = ItemManager.Instance.getTemplateById(BoxGoodsTempInfo(this._goodsList[_loc2_]).TemplateId);
            _loc3_.count = 1;
            _loc3_.itemName = ItemManager.Instance.getTemplateById(BoxGoodsTempInfo(this._goodsList[_loc2_]).TemplateId).Name + "X" + String(BoxGoodsTempInfo(this._goodsList[_loc2_]).ItemCount);
            this._list.addChild(_loc3_);
            this._cells.push(_loc3_);
            _loc2_++;
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.width = 488;
         this.panel.height = 178;
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = ScrollPanel.OFF;
         this.panel.commitChanges();
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      public function dispose() : void
      {
         var _loc1_:BoxAwardsCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.dispose();
         }
         this._cells.splice(0,this._cells.length);
         this._cells = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this.panel)
         {
            ObjectUtils.disposeObject(this.panel);
         }
         this.panel = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
