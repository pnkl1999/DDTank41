package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PetExperience;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   
   public class PetFoodNumberSelectFrame extends BaseAlerFrame
   {
       
      
      private var _foodInfo:InventoryItemInfo;
      
      private var _alertInfo:AlertInfo;
      
      private var _petInfo:PetInfo;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _text:FilterFrameText;
      
      private var _needFoodText:FilterFrameText;
      
      private var maxFood:int = 0;
      
      private var neededFoodAmount:int;
      
      public function PetFoodNumberSelectFrame()
      {
         super();
         this.initView();
      }
      
      public function set petInfo(param1:PetInfo) : void
      {
         this._petInfo = param1;
      }
      
      public function set foodInfo(param1:InventoryItemInfo) : void
      {
         this._foodInfo = param1;
      }
      
      public function get foodInfo() : InventoryItemInfo
      {
         return this._foodInfo;
      }
      
      public function get amount() : int
      {
         return this._numberSelecter.currentValue;
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.pets.foodAmountSelect"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._text = ComponentFactory.Instance.creatComponentByStylename("petsBag.PetFoodNumberSelectFrame.Text");
         this._text.text = LanguageMgr.GetTranslation("ddt.pets.foodAmountTipText");
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         this._numberSelecter.addEventListener(Event.CHANGE,this.__seleterChange);
         PositionUtils.setPos(this._numberSelecter,"petsBag.PetFoodNumberSelectFrame.numberSelecterPos");
         this._needFoodText = ComponentFactory.Instance.creatComponentByStylename("petsBag.PetFoodNumberSelectFrame.NeedFoodText");
         PositionUtils.setPos(this._needFoodText,"petsBag.PetFoodNumberSelectFrame.needFoodTextPos");
         this._needFoodText.visible = false;
         addToContent(this._text);
         addToContent(this._numberSelecter);
         addToContent(this._needFoodText);
      }
      
      private function __seleterChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function show(param1:int, param2:int = 1) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:PetInfo = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this._foodInfo.Count >= param1)
         {
            _loc3_ = param1;
         }
         else
         {
            _loc3_ = this._foodInfo.Count;
         }
         this._numberSelecter.valueLimit = param2 + "," + _loc3_;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         if(this._petInfo)
         {
            _loc4_ = PetExperience.getLevelByGP(this._petInfo.GP);
            _loc5_ = PetExperience.expericence[_loc4_] - this._petInfo.GP;
            this.neededFoodAmount = int(Math.ceil(_loc5_ / Number(this._foodInfo.Property2)));
            _loc6_ = int(this._foodInfo.Property1);
            _loc7_ = PetBagController.instance().petModel.currentPetInfo;
            _loc8_ = _loc7_.Level;
            _loc9_ = PlayerManager.Instance.Self.Grade;
            if(_loc8_ == _loc9_ || _loc8_ == 65)
            {
               this._needFoodText.htmlText = LanguageMgr.GetTranslation("ddt.pets.hungerNeedFoodAmount",param1);
               this._needFoodText.visible = true;
               if(this._foodInfo.Count >= param1)
               {
                  this._numberSelecter.currentValue = param1;
               }
               else
               {
                  this._numberSelecter.currentValue = this._foodInfo.Count;
               }
               this._numberSelecter.validate();
            }
            else
            {
               this._needFoodText.htmlText = LanguageMgr.GetTranslation("ddt.pets.upgradeNeedFoodAmount",this.neededFoodAmount);
               this._needFoodText.visible = true;
               this._numberSelecter.currentValue = this.neededFoodAmount;
               this._numberSelecter.validate();
            }
         }
      }
      
      private function needMaxFood(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = PetconfigAnalyzer.PetCofnig.MaxHunger - param1;
         return int(int(Math.ceil(_loc4_ / Number(param2))));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._numberSelecter.removeEventListener(Event.CHANGE,this.__seleterChange);
         this.removeView();
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._numberSelecter);
         this._numberSelecter = null;
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         ObjectUtils.disposeObject(this._needFoodText);
         this._needFoodText = null;
      }
   }
}
