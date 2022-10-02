package petsBag.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.event.PetItemEvent;
   import petsBag.view.item.SkillItem;
   import road7th.data.DictionaryEvent;
   
   public class PetGameSkillPnl extends Sprite implements Disposeable
   {
      
      public static var LvVSLockArray:Array = [20,40,60];
       
      
      private var _items:Vector.<SkillItem>;
      
      private var _pet:PetInfo;
      
      public function PetGameSkillPnl(param1:PetInfo = null)
      {
         super();
         this._items = new Vector.<SkillItem>();
         this.initView();
         this.initEvent();
         this.pet = param1;
      }
      
      private function initView() : void
      {
         var _loc2_:SkillItem = null;
         var _loc3_:Point = null;
         _loc2_ = null;
         _loc3_ = null;
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new SkillItem(null,_loc1_,false);
            _loc3_ = ComponentFactory.Instance.creatCustomObject("petsBag.gameSkillPnl.point" + _loc1_);
            _loc2_.x = _loc3_.x;
            _loc2_.y = _loc3_.y;
            addChild(_loc2_);
            this._items.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].addEventListener(MouseEvent.CLICK,this.__skillItemClick);
            _loc1_++;
         }
         PetBagController.instance().petModel.addEventListener(Event.CHANGE,this.__onChange);
      }
      
      private function __onChange(param1:Event) : void
      {
         this.pet = PetBagController.instance().petModel.currentPetInfo;
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(PetItemEvent.ITEM_CLICK,this.__skillItemClick);
            _loc1_++;
         }
         PetBagController.instance().petModel.removeEventListener(Event.CHANGE,this.__onChange);
         if(this._pet)
         {
            this._pet.equipdSkills.removeEventListener(DictionaryEvent.UPDATE,this.__onUpdate);
         }
      }
      
      private function __skillItemClick(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:SkillItem = param1.currentTarget as SkillItem;
         if(_loc2_)
         {
            if(_loc2_.skillID == -1)
            {
               if(_loc2_.index != 4)
               {
                  _loc4_ = "";
                  switch(_loc2_.index)
                  {
                     case 1:
                        _loc4_ = PetconfigAnalyzer.PetCofnig.skillOpenLevel[0];
                        break;
                     case 2:
                        _loc4_ = PetconfigAnalyzer.PetCofnig.skillOpenLevel[1];
                        break;
                     case 3:
                        _loc4_ = PetconfigAnalyzer.PetCofnig.skillOpenLevel[2];
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petsBag.LevAction",_loc4_));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petsBag.VipAction"));
               }
               return;
            }
            SocketManager.Instance.out.sendEquipPetSkill(PetBagController.instance().petModel.currentPetInfo.Place,0,_loc2_.index);
         }
      }
      
      protected function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(PetBagController.instance().petModel.currentPetInfo)
               {
                  SocketManager.Instance.out.sendPaySkill(PetBagController.instance().petModel.currentPetInfo.Place);
                  break;
               }
         }
         _loc2_.dispose();
      }
      
      public function set pet(param1:PetInfo) : void
      {
         var _loc2_:SkillItem = null;
         var _loc3_:int = 0;
         this._pet = param1;
         for each(_loc2_ in this._items)
         {
            _loc2_.skillID = -1;
         }
         if(this._pet)
         {
            _loc3_ = 0;
            while(_loc3_ < this._pet.equipdSkills.length)
            {
               this._items[_loc3_].skillID = this._pet.equipdSkills[_loc3_];
               _loc3_++;
            }
         }
      }
      
      private function __onUpdate(param1:DictionaryEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._pet.equipdSkills.length)
         {
            this._items[_loc2_].skillID = this._pet.equipdSkills[_loc2_];
            _loc2_++;
         }
      }
      
      private function lockByIndex(param1:int) : void
      {
         if(param1 < 1 || param1 > 5)
         {
            return;
         }
         this._items[param1 - 1].isLock = true;
         if(PetBagController.instance().petModel.currentPetInfo && PetBagController.instance().petModel.currentPetInfo.PaySkillCount > 0)
         {
            this._items[param1 - 1].isLock = false;
         }
      }
      
      public function get UnLockItemIndex() : int
      {
         var _loc2_:SkillItem = null;
         var _loc1_:Boolean = true;
         for each(_loc2_ in this._items)
         {
            if(!_loc2_.isLock && !_loc2_.info)
            {
               _loc1_ = false;
               return _loc2_.index;
            }
         }
         if(_loc1_)
         {
            return 0;
         }
         return 0;
      }
      
      public function dispose() : void
      {
         var _loc1_:SkillItem = null;
         this.removeEvent();
         for each(_loc1_ in this._items)
         {
            if(_loc1_)
            {
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
         }
         this._pet = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
