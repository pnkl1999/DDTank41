package farm.viewx
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.PNGHitAreaFactory;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import farm.view.compose.event.SelectComposeItemEvent;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import trainer.data.ArrowType;
   
   public class FarmFieldBlock extends Sprite implements Disposeable, IAcceptDrag
   {
       
      
      private var _fieldId:int;
      
      private var _info:FieldVO;
      
      private var _picPath:String;
      
      private var _field:ScaleFrameImage;
      
      private var _flag:SimpleBitmapButton;
      
      private var _hitArea:Sprite;
      
      private var _loadingasset:MovieClip;
      
      private var _loader:DisplayLoader;
      
      private var _type:int = -1;
      
      private var _plant:BaseButton;
      
      private var _countdown:CountdownView;
      
      public function FarmFieldBlock(param1:int)
      {
         super();
         this._fieldId = param1;
         this.initView();
         this.initEvent();
      }
      
      public function set flag(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._flag == null)
            {
               this._flag = ComponentFactory.Instance.creatComponentByStylename("farm.flag");
               this._flag.addEventListener(MouseEvent.CLICK,this.__flagClickHandler);
               addChild(this._flag);
            }
         }
         else
         {
            if(this._flag)
            {
               ObjectUtils.disposeObject(this._flag);
            }
            this._flag = null;
         }
      }
      
      public function get info() : FieldVO
      {
         return this._info;
      }
      
      public function set info(param1:FieldVO) : void
      {
         if(this._info != param1)
         {
            this._type = -1;
         }
         this._info = param1;
         if(this._info)
         {
            if(this._info.isDig)
            {
               this._field.setFrame(1);
               this.addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
               this.addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
               this.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
               if(this._flag)
               {
                  ObjectUtils.disposeObject(this._flag);
               }
               this._flag = null;
            }
            else
            {
               this._field.setFrame(2);
            }
            if(this._info.seedID != 0)
            {
               this.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
               this._picPath = ItemManager.Instance.getTemplateById(this._info.seedID).Pic;
               this.loadIcon(this._info.plantGrownPhase);
               this.upTips();
            }
            else
            {
               this._type = -1;
               if(this._plant)
               {
                  this._plant.visible = false;
               }
            }
         }
         else
         {
            this._type = -1;
            this._field.setFrame(2);
            if(this._flag)
            {
               ObjectUtils.disposeObject(this._flag);
            }
            this._flag = null;
            this._plant.visible = false;
         }
      }
      
      protected function __onMouseClick(param1:MouseEvent) : void
      {
         this.dispatchEvent(new FarmEvent(FarmEvent.FIELDBLOCK_CLICK));
      }
      
      private function upTips() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this._info && this._info.seedID != 0)
         {
            _loc1_ = ItemManager.Instance.getTemplateById(this.info.seedID).Name;
            _loc2_ = "";
            if(this._info.plantGrownPhase == 2)
            {
               _loc2_ = LanguageMgr.GetTranslation("ddt.farm.goods.grown",this._info.gainCount,ItemManager.Instance.getTemplateById(this._info.seedID).Property2);
            }
            else if(this._info.realNeedTime > 0)
            {
               if(this._info.realNeedTime / 60 == 0)
               {
                  _loc2_ = LanguageMgr.GetTranslation("ddt.farm.goods.mini",this._info.realNeedTime % 60);
               }
               else
               {
                  _loc2_ = LanguageMgr.GetTranslation("ddt.farm.goods.houer",int(this._info.realNeedTime / 60),this._info.realNeedTime % 60);
               }
               this._countdown.setCountdown(this._info.fieldID);
            }
            else
            {
               _loc2_ = LanguageMgr.GetTranslation("ddt.farm.goods.houer",0,0);
            }
            if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID && this._info.realNeedTime > 0)
            {
               this._countdown.setFastBtnEnable(true);
            }
            else
            {
               this._countdown.setFastBtnEnable(false);
            }
            this._plant.tipData = LanguageMgr.GetTranslation("ddt.farm.goods.name",_loc1_,_loc2_);
         }
      }
      
      private function initEvent() : void
      {
      }
      
      public function setBeginHelper(param1:int) : void
      {
         this._picPath = ItemManager.Instance.getTemplateById(param1).Pic;
         this.loadIcon(0);
         this._plant.tipData = LanguageMgr.GetTranslation("ddt.farms.fieldBlockSeedTips");
      }
      
      private function __onMouseOver(param1:MouseEvent) : void
      {
         if(this._info)
         {
            filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
      }
      
      private function __onMouseOut(param1:MouseEvent) : void
      {
         filters = [];
      }
      
      private function initView() : void
      {
         this._field = ComponentFactory.Instance.creatComponentByStylename("farm.fieldbg");
         addChild(this._field);
         this._hitArea = PNGHitAreaFactory.drawHitArea(DisplayUtils.getDisplayBitmapData(this._field));
         hitArea = this._hitArea;
         this._hitArea.alpha = 0;
         addChild(this._hitArea);
         this._plant = ComponentFactory.Instance.creatComponentByStylename("farm.plant");
         addChild(this._plant);
         this._plant.visible = false;
         this._plant.addEventListener(MouseEvent.CLICK,this.__plantClickHandler);
         FarmModelController.instance.addEventListener(FarmEvent.FRUSH_FIELD,this.__frush);
         FarmModelController.instance.addEventListener(FarmEvent.ACCELERATE_FIELD,this.__accelerate);
         this._countdown = new CountdownView();
         PositionUtils.setPos(this._countdown,"assets.farm.countdownPos");
         addChild(this._countdown);
         this._countdown.visible = false;
      }
      
      protected function __accelerate(param1:Event) : void
      {
         if(FarmModelController.instance.model.matureId == this._fieldId)
         {
            this.upTips();
         }
      }
      
      protected function __frush(param1:Event) : void
      {
         this.upTips();
      }
      
      private function __plantClickHandler(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.isFarmHelper && PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
         {
            return;
         }
         if(this._info.plantGrownPhase == 2)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            FarmModelController.instance.getHarvest(this._info.fieldID);
            this.petFarmGuilde();
            FarmModelController.instance.updateFriendListStolen();
         }
         else
         {
            param1.stopImmediatePropagation();
            this._countdown.visible = true;
            stage.addEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      protected function __onClick(param1:MouseEvent) : void
      {
         if(this._countdown)
         {
            SoundManager.instance.play("008");
            this._countdown.visible = false;
            stage.removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      private function petFarmGuilde() : void
      {
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK5))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.GAINS);
         }
      }
      
      private function loadIcon(param1:int) : void
      {
         if(this._type == param1)
         {
            return;
         }
         this._type = param1;
         this._loadingasset = ComponentFactory.Instance.creat("bagAndInfo.cell.BaseCellLoadingAsset");
         PositionUtils.setPos(this._loadingasset,"farm.farmFieldBlock.pos");
         addChild(this._loadingasset);
         if(this._loader)
         {
            this._loader = null;
         }
         if(this._plant)
         {
            ObjectUtils.disposeObject(this._plant);
            this._plant = null;
         }
         if(!this._plant)
         {
            this._plant = ComponentFactory.Instance.creatComponentByStylename("farm.plant");
            addChildAt(this._plant,this.numChildren - 2);
            this._plant.addEventListener(MouseEvent.CLICK,this.__plantClickHandler);
         }
         this._loader = LoaderManager.Instance.creatLoader(PathManager.solveFieldPlantPath(this._picPath,param1),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         LoaderManager.Instance.startLoad(this._loader);
      }
      
      private function __complete(param1:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         if(this._loader.isSuccess)
         {
            this._plant.backgound = this._loader.content as Bitmap;
            this._plant.visible = true;
            if(this._loadingasset)
            {
               ObjectUtils.disposeObject(this._loadingasset);
            }
            this._loadingasset = null;
         }
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(param1.source is FarmKillCropCell)
         {
            if(this._info && this._info.seedID != 0)
            {
               dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.KILLCROP_SHOW,this._info));
            }
            else
            {
               DragManager.acceptDrag(this);
            }
         }
         else
         {
            _loc2_ = param1.data as InventoryItemInfo;
            if(_loc2_)
            {
               if(this._info && this._info.seedID == 0 && this._info.isDig && _loc2_.CategoryID == EquipType.SEED && _loc2_.Count > 0)
               {
                  FarmModelController.instance.sowSeed(this._fieldId,_loc2_.TemplateID);
                  if(_loc2_.Count == 1)
                  {
                     return;
                  }
               }
               else if(this._info && this._info.seedID != 0 && _loc2_.CategoryID == EquipType.MANURE && _loc2_.Count > 0)
               {
                  _loc3_ = 0;
                  FarmModelController.instance.accelerateField(_loc3_,this._fieldId,_loc2_.TemplateID);
                  if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK4))
                  {
                     PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.USE_FERTILLZER);
                  }
                  if(_loc2_.Count == 1)
                  {
                     return;
                  }
               }
               DragManager.acceptDrag(this);
            }
         }
      }
      
      private function __flagClickHandler(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.isFarmHelper)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farms.fieldBlockSeedTips"));
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         FarmModelController.instance.openPayFieldFrame(this._fieldId);
      }
      
      public function dispose() : void
      {
         if(this._info && this._info.isDig)
         {
            this.removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         }
         if(this._info && this._info.isDig)
         {
            this.removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         }
         if(this._info && this._info.isDig)
         {
            this.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         }
         this._info = null;
         this._loader = null;
         FarmModelController.instance.removeEventListener(FarmEvent.FRUSH_FIELD,this.__frush);
         FarmModelController.instance.removeEventListener(FarmEvent.ACCELERATE_FIELD,this.__accelerate);
         if(this._flag)
         {
            this._flag.removeEventListener(MouseEvent.CLICK,this.__flagClickHandler);
         }
         this._plant.removeEventListener(MouseEvent.CLICK,this.__plantClickHandler);
         if(this._plant)
         {
            ObjectUtils.disposeObject(this._plant);
         }
         this._plant = null;
         if(this._field)
         {
            ObjectUtils.disposeObject(this._field);
         }
         this._field = null;
         if(this._flag)
         {
            ObjectUtils.disposeObject(this._flag);
         }
         this._flag = null;
         if(this._hitArea)
         {
            ObjectUtils.disposeObject(this._hitArea);
         }
         this._hitArea = null;
         if(this._loadingasset)
         {
            ObjectUtils.disposeObject(this._loadingasset);
         }
         this._loadingasset = null;
         if(this._countdown)
         {
            this._countdown.dispose();
            this._countdown = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
