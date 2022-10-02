package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   import pet.date.PetSkill;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.controller.PetBagController;
   import petsBag.event.PetItemEvent;
   import petsBag.view.item.SkillItem;
   import trainer.data.ArrowType;
   
   public class PetSkillPnl extends Sprite implements Disposeable
   {
       
      
      private var _petSkill:SimpleTileList;
      
      private var _petSkillScroll:ScrollPanel;
      
      private var _isWatch:Boolean = false;
      
      private var _itemInfoVec:Array;
      
      private var _itemViewVec:Vector.<SkillItem>;
      
      public function PetSkillPnl(param1:Boolean)
      {
         this._isWatch = param1;
         super();
         this._itemInfoVec = [];
         this._itemViewVec = new Vector.<SkillItem>();
         this.creatView();
      }
      
      private function creatView() : void
      {
         if(!this._isWatch)
         {
            this._petSkillScroll = ComponentFactory.Instance.creatComponentByStylename("petsBag.scrollPanel.petSkillPnl");
            addChild(this._petSkillScroll);
            this._petSkill = ComponentFactory.Instance.creatCustomObject("petsBag.simpleTileList.petSkill",[4]);
            this._petSkillScroll.setView(this._petSkill);
         }
         else
         {
            this._petSkillScroll = ComponentFactory.Instance.creatComponentByStylename("petsBag.scrollPanel.petSkillPnlWatch");
            addChild(this._petSkillScroll);
            this._petSkill = ComponentFactory.Instance.creatCustomObject("petsBag.simpleTileList.petSkill",[7]);
            this._petSkillScroll.setView(this._petSkill);
         }
      }
      
      public function set itemInfo(param1:Array) : void
      {
         this._itemInfoVec = param1;
         this._itemInfoVec.sortOn("ID",Array.NUMERIC);
         this.update();
      }
      
      public function update() : void
      {
         this.removeItems();
         this.creatItems();
      }
      
      protected function creatItems() : void
      {
         var _loc2_:SkillItem = null;
         _loc2_ = null;
         var _loc4_:PetSkillTemplateInfo = null;
         var _loc1_:int = 0;
         var _loc3_:int = 8;
         for each(_loc4_ in this._itemInfoVec)
         {
            if(_loc4_)
            {
               _loc2_ = new SkillItem(_loc4_,_loc1_++,true,this._isWatch);
               _loc2_.DoubleClickEnabled = true;
               _loc2_.iconPos = new Point(2.5,2.5);
               this._petSkill.addChild(_loc2_);
               this._itemViewVec.push(_loc2_);
            }
         }
         _loc3_ = !!this._isWatch ? int(int(14)) : int(int(8));
         while(_loc1_ < _loc3_)
         {
            _loc2_ = new SkillItem(null,_loc1_++,true,this._isWatch);
            _loc2_.iconPos = new Point(3,3);
            _loc2_.mouseChildren = false;
            _loc2_.mouseEnabled = false;
            this._petSkill.addChild(_loc2_);
            this._itemViewVec.push(_loc2_);
         }
         if(!this._isWatch)
         {
            this.initEvent();
         }
      }
      
      public function set scrollVisble(param1:Boolean) : void
      {
         this._petSkillScroll.vScrollbar.visible = param1;
      }
      
      private function removeItems() : void
      {
         var _loc1_:SkillItem = null;
         this.removeEvent();
         for each(_loc1_ in this._itemViewVec)
         {
            if(_loc1_)
            {
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
         }
         this._itemViewVec.splice(0,this._itemViewVec.length);
      }
      
      private function initEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemViewVec.length)
         {
            this._itemViewVec[_loc1_].addEventListener(PetItemEvent.ITEM_CLICK,this.__skillItemClick);
            _loc1_++;
         }
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemViewVec.length)
         {
            this._itemViewVec[_loc1_].removeEventListener(PetItemEvent.ITEM_CLICK,this.__skillItemClick);
            _loc1_++;
         }
      }
      
      private function __skillItemClick(param1:PetItemEvent) : void
      {
         if(this._isWatch)
         {
            return;
         }
         var _loc2_:PetSkill = (param1.data as SkillItem).info as PetSkill;
         if(_loc2_ && PetBagController.instance().petModel.currentPetInfo)
         {
            SocketManager.Instance.out.sendEquipPetSkill(PetBagController.instance().petModel.currentPetInfo.Place,_loc2_.ID,PetBagController.instance().getEquipdSkillIndex());
            if(PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.CHOOSE_PET_SKILL] > 0)
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CHOOSE_PET_SKILL);
               PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.CHOOSE_PET_SKILL] = 0;
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeItems();
         ObjectUtils.disposeObject(this._petSkill);
         this._petSkill = null;
         ObjectUtils.disposeObject(this._petSkillScroll);
         this._petSkillScroll = null;
         this._itemInfoVec = null;
         this._itemViewVec = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
