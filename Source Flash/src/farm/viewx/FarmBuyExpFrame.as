package farm.viewx
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.SuperPetFoodPriceInfo;
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class FarmBuyExpFrame extends BaseAlerFrame
   {
       
      
      private var _bg:Bitmap;
      
      private var _text:FilterFrameText;
      
      private var _currentMoney:int;
      
      private var _currentSuperPetFoodPriceInfo:SuperPetFoodPriceInfo;
      
      public function FarmBuyExpFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._currentMoney = FarmModelController.instance.getCurrentMoney();
         this._currentSuperPetFoodPriceInfo = FarmModelController.instance.getCurrentSuperPetFoodPriceInfo();
         info = new AlertInfo(LanguageMgr.GetTranslation("farm.viewx.farmBuyExpFrame.title"),LanguageMgr.GetTranslation("farm.viewx.farmBuyExpFrame.title"),"",true,false);
         this._bg = ComponentFactory.Instance.creatBitmap("asset.farm.buyExpFrameGB");
         addToContent(this._bg);
         var _loc1_:int = int(ItemManager.Instance.getTemplateById(EquipType.SUPER_PET_EXP_FOOD).Property3);
         this._text = ComponentFactory.Instance.creatComponentByStylename("Farm.FarmMainView.buyExpExplainText");
         addToContent(this._text);
         var _loc2_:String = "0";
         if(this._currentSuperPetFoodPriceInfo)
         {
            _loc2_ = this._currentSuperPetFoodPriceInfo.ItemCount.toString();
         }
         this._text.htmlText = LanguageMgr.GetTranslation("farm.viewx.farmBuyExpFrame.explain",this._currentMoney.toString(),_loc2_,_loc1_);
         addEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         FarmModelController.instance.addEventListener(FarmEvent.UPDATE_BUY_EXP_REMAIN_NUM,this.__updateNum);
         _isBand = true;
      }
      
      protected function __updateNum(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(FarmModelController.instance.model.buyExpRemainNum > 0)
         {
            this._currentMoney = FarmModelController.instance.getCurrentMoney();
            this._currentSuperPetFoodPriceInfo = FarmModelController.instance.getCurrentSuperPetFoodPriceInfo();
            if(this._currentSuperPetFoodPriceInfo == null)
            {
               return;
            }
            _loc2_ = int(ItemManager.Instance.getTemplateById(EquipType.SUPER_PET_EXP_FOOD).Property3);
            this._text.htmlText = LanguageMgr.GetTranslation("farm.viewx.farmBuyExpFrame.explain",this._currentMoney.toString(),this._currentSuperPetFoodPriceInfo.ItemCount.toString(),_loc2_);
         }
      }
      
      protected function __onFrameEvent(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SoundManager.instance.playButtonSound();
            if(_isBand)
            {
            }
            if(FarmModelController.instance.model.buyExpRemainNum <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.viewx.FarmBuyExpFrame.warning"));
               return;
            }
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this._currentMoney = FarmModelController.instance.getCurrentMoney();
            if(!(_isBand && PlayerManager.Instance.Self.Gift >= this._currentMoney))
            {
               if(PlayerManager.Instance.Self.Money < this._currentMoney)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               _isBand = false;
            }
            SocketManager.Instance.out.sendBuyPetExpItem(_isBand);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         FarmModelController.instance.removeEventListener(FarmEvent.UPDATE_BUY_EXP_REMAIN_NUM,this.__updateNum);
         super.dispose();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._text);
         this._text = null;
      }
   }
}
