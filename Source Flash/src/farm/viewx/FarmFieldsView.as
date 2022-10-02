package farm.viewx
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.*;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import farm.view.compose.event.SelectComposeItemEvent;
   import flash.display.Sprite;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import trainer.data.ArrowType;
   
   public class FarmFieldsView extends Sprite implements Disposeable
   {
       
      
      private var _fields:Vector.<FarmFieldBlock>;
      
      private var _configmPnl:ConfirmKillCropAlertFrame;
      
      public function FarmFieldsView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         FarmModelController.instance.addEventListener(FarmEvent.FIELDS_INFO_READY,this.__fieldInfoReady);
         FarmModelController.instance.addEventListener(FarmEvent.HAS_SEEDING,this.__hasSeeding);
         FarmModelController.instance.addEventListener(FarmEvent.FRUSH_FIELD,this.__frushField);
         FarmModelController.instance.addEventListener(FarmEvent.GAIN_FIELD,this.__gainField);
         FarmModelController.instance.addEventListener(FarmEvent.ACCELERATE_FIELD,this.__accelerateField);
         FarmModelController.instance.addEventListener(FarmEvent.HELPER_SWITCH_FIELD,this.__helperSwitchHandler);
         FarmModelController.instance.addEventListener(FarmEvent.HELPER_KEY_FIELD,this.__helperKeyHandler);
         FarmModelController.instance.addEventListener(FarmEvent.KILLCROP_FIELD,this.__onKillcropField);
         FarmModelController.instance.addEventListener(FarmEvent.BEGIN_HELPER,this.__setFields);
         FarmModelController.instance.addEventListener(FarmEvent.STOP_HELPER,this.__frushField);
      }
      
      private function remvoeEvent() : void
      {
         FarmModelController.instance.removeEventListener(FarmEvent.FIELDS_INFO_READY,this.__fieldInfoReady);
         FarmModelController.instance.removeEventListener(FarmEvent.HAS_SEEDING,this.__hasSeeding);
         FarmModelController.instance.removeEventListener(FarmEvent.FRUSH_FIELD,this.__frushField);
         FarmModelController.instance.removeEventListener(FarmEvent.GAIN_FIELD,this.__gainField);
         FarmModelController.instance.removeEventListener(FarmEvent.ACCELERATE_FIELD,this.__accelerateField);
         FarmModelController.instance.removeEventListener(FarmEvent.HELPER_SWITCH_FIELD,this.__helperSwitchHandler);
         FarmModelController.instance.removeEventListener(FarmEvent.HELPER_KEY_FIELD,this.__helperKeyHandler);
         FarmModelController.instance.removeEventListener(FarmEvent.KILLCROP_FIELD,this.__onKillcropField);
         FarmModelController.instance.removeEventListener(FarmEvent.BEGIN_HELPER,this.__setFields);
         FarmModelController.instance.removeEventListener(FarmEvent.STOP_HELPER,this.__frushField);
      }
      
      private function initView() : void
      {
         var _loc2_:FarmFieldBlock = null;
         this._fields = new Vector.<FarmFieldBlock>(16);
         var _loc1_:int = 0;
         while(_loc1_ < 16)
         {
            _loc2_ = new FarmFieldBlock(_loc1_);
            PositionUtils.setPos(_loc2_,"farm.fieldsView.fieldPos" + _loc1_);
            _loc2_.addEventListener(SelectComposeItemEvent.KILLCROP_SHOW,this.__showComfigKillCrop);
            addChild(_loc2_);
            this._fields[_loc1_] = _loc2_;
            _loc1_++;
         }
         this.__fieldInfoReady(null);
      }
      
      private function __setFields(param1:FarmEvent) : void
      {
         this.setFieldByHelper();
      }
      
      public function setFieldByHelper() : void
      {
         var _loc3_:int = 0;
         if(PlayerManager.Instance.Self.ID != FarmModelController.instance.model.currentFarmerId)
         {
            return;
         }
         if(!PlayerManager.Instance.Self.isFarmHelper)
         {
            return;
         }
         var _loc1_:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         var _loc2_:int = 0;
         while(_loc2_ < FarmModelController.instance.model.fieldsInfo.length)
         {
            _loc3_ = (new Date().getTime() - _loc1_[_loc2_].payTime.getTime()) / (1000 * 60 * 60);
            if(_loc1_[_loc2_].fieldValidDate > _loc3_ || _loc1_[_loc2_].fieldValidDate == -1)
            {
               this._fields[_loc2_].setBeginHelper(FarmModelController.instance.model.helperArray[1]);
            }
            _loc2_++;
         }
      }
      
      protected function __fieldInfoReady(param1:FarmEvent) : void
      {
         this.upFields();
         this.upFlagPlace();
         this.setFieldByHelper();
      }
      
      private function __hasSeeding(param1:FarmEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 16)
         {
            if(this._fields[_loc2_].info.fieldID == FarmModelController.instance.model.seedingFieldInfo.fieldID)
            {
               this._fields[_loc2_].info = FarmModelController.instance.model.seedingFieldInfo;
               if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK4))
               {
                  PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.SEEDING);
               }
               break;
            }
            _loc2_++;
         }
         this.autoHelperHandler(FarmModelController.instance.model.seedingFieldInfo);
      }
      
      private function __frushField(param1:FarmEvent) : void
      {
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            this.upFields();
            this.upFlagPlace();
            this.setFieldByHelper();
         }
      }
      
      private function __gainField(param1:FarmEvent) : void
      {
         var _loc2_:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.gainFieldId);
         var _loc3_:int = 0;
         while(_loc3_ < 16)
         {
            if(this._fields[_loc3_].info.fieldID == FarmModelController.instance.model.gainFieldId)
            {
               this._fields[_loc3_].info = _loc2_;
               this.upFlagPlace();
               break;
            }
            _loc3_++;
         }
         if(_loc2_.isAutomatic)
         {
            this.autoHelperHandler(_loc2_);
         }
      }
      
      private function __accelerateField(param1:FarmEvent) : void
      {
         var _loc2_:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.matureId);
         var _loc3_:int = 0;
         while(_loc3_ < 16)
         {
            if(this._fields[_loc3_].info.fieldID == FarmModelController.instance.model.matureId)
            {
               this._fields[_loc3_].info = _loc2_;
               break;
            }
            _loc3_++;
         }
         this.autoHelperHandler(_loc2_);
      }
      
      private function __helperSwitchHandler(param1:FarmEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 16)
         {
            if(this._fields[_loc2_].info.fieldID == FarmModelController.instance.model.isAutoId)
            {
               this._fields[_loc2_].info = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.isAutoId);
               return;
            }
            _loc2_++;
         }
      }
      
      private function __helperKeyHandler(param1:FarmEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = FarmModelController.instance.model.batchFieldIDArray;
         for each(_loc3_ in _loc2_)
         {
            this._fields[_loc3_].info = FarmModelController.instance.model.getfieldInfoById(_loc3_);
         }
      }
      
      private function __onKillcropField(param1:FarmEvent) : void
      {
         var _loc2_:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.killCropId);
         var _loc3_:int = 0;
         while(_loc3_ < 16)
         {
            if(this._fields[_loc3_].info.fieldID == FarmModelController.instance.model.killCropId)
            {
               this._fields[_loc3_].info = _loc2_;
               return;
            }
            _loc3_++;
         }
      }
      
      private function upFields() : void
      {
         var _loc5_:int = 0;
         var _loc1_:Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
         var _loc2_:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc3_].fieldID;
            if(this._fields[_loc5_])
            {
               this._fields[_loc5_].info = _loc2_[_loc3_];
               this.autoHelperHandler(this._fields[_loc5_].info);
               _loc1_.splice(_loc1_.indexOf(_loc5_),1);
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_.length)
         {
            this._fields[_loc1_[_loc4_]].info = null;
            _loc4_++;
         }
      }
      
      private function upFlagPlace() : void
      {
         var _loc2_:Vector.<FieldVO> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Array = [8,9,10,11,12,13,14,15];
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            _loc2_ = FarmModelController.instance.model.fieldsInfo;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_].fieldID >= 8 && (_loc2_[_loc3_].isDig || _loc2_[_loc3_].seedID != 0))
               {
                  _loc1_.splice(_loc1_.indexOf(_loc2_[_loc3_].fieldID),1);
                  this._fields[_loc2_[_loc3_].fieldID].flag = false;
               }
               _loc3_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc1_.length)
            {
               if(_loc4_ == 0)
               {
                  this._fields[_loc1_[_loc4_]].flag = true;
               }
               else
               {
                  this._fields[_loc1_[_loc4_]].flag = false;
               }
               _loc4_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc1_.length)
            {
               this._fields[_loc1_[_loc5_]].flag = false;
               _loc5_++;
            }
         }
      }
      
      private function __showComfigKillCrop(param1:SelectComposeItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:FieldVO = param1.data as FieldVO;
         this._configmPnl = ComponentFactory.Instance.creatComponentByStylename("farm.confirmKillCropAlertFrame");
         this._configmPnl.cropName(ItemManager.Instance.getTemplateById(_loc2_.seedID).Name,_loc2_.isAutomatic);
         this._configmPnl.fieldId = _loc2_.fieldID;
         this._configmPnl.addEventListener(SelectComposeItemEvent.KILLCROP_CLICK,this.__killCropClick);
         LayerManager.Instance.addToLayer(this._configmPnl,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __killCropClick(param1:SelectComposeItemEvent) : void
      {
         var _loc2_:int = param1.data as int;
         if(_loc2_ != -1)
         {
            FarmModelController.instance.killCrop(_loc2_);
         }
         if(this._configmPnl)
         {
            this._configmPnl.removeEventListener(SelectComposeItemEvent.KILLCROP_CLICK,this.__killCropClick);
         }
         this.dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.KILLCROP_ICON));
      }
      
      public function autoHelperHandler(param1:FieldVO) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         var _loc4_:InventoryItemInfo = null;
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID && param1 && param1.isAutomatic)
         {
            if(param1.seedID == 0 && param1.isDig && param1.autoSeedID != 0)
            {
               _loc2_ = FarmModelController.instance.model.findItemInfo(EquipType.SEED,param1.autoSeedID);
               if(_loc2_)
               {
                  if(_loc2_.CategoryID == EquipType.SEED && _loc2_.Count > 0)
                  {
                     if(_loc2_.Count == 1)
                     {
                        return;
                     }
                  }
               }
            }
            if(param1.seedID != 0 && param1.autoFertilizerID != 0 && param1.AccelerateTime == 0)
            {
               _loc3_ = 1;
               _loc4_ = FarmModelController.instance.model.findItemInfo(EquipType.MANURE,param1.autoFertilizerID);
               if(_loc4_)
               {
                  if(_loc4_.CategoryID == EquipType.MANURE && _loc4_.Count > 0)
                  {
                     FarmModelController.instance.accelerateField(_loc3_,param1.fieldID,param1.autoFertilizerID);
                     if(_loc4_.Count == 1)
                     {
                        return;
                     }
                  }
               }
            }
            if(param1.plantGrownPhase == 2)
            {
               FarmModelController.instance.getHarvest(param1.fieldID);
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 16)
         {
            if(this._fields[_loc1_])
            {
               this._fields[_loc1_].removeEventListener(SelectComposeItemEvent.KILLCROP_SHOW,this.__showComfigKillCrop);
               ObjectUtils.disposeObject(this._fields[_loc1_]);
               this._fields[_loc1_] = null;
            }
            _loc1_++;
         }
         this.remvoeEvent();
         this._fields = null;
         if(this._configmPnl)
         {
            ObjectUtils.disposeObject(this._configmPnl);
         }
         this._configmPnl = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get fields() : Vector.<FarmFieldBlock>
      {
         return this._fields;
      }
   }
}
