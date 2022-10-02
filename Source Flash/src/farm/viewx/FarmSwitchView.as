package farm.viewx
{
   import ddt.manager.ChatManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import farm.FarmModelController;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.event.UpdatePetFarmGuildeEvent;
   import trainer.data.ArrowType;
   
   public class FarmSwitchView extends BaseStateView
   {
       
      
      private var _farmMainView:FarmMainView;
      
      public function FarmSwitchView()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this._farmMainView = new FarmMainView();
         addChild(this._farmMainView);
         MainToolBar.Instance.show();
         ChatManager.Instance.state = ChatManager.CHAT_FARM;
         addChild(ChatManager.Instance.view);
         PetBagController.instance().addEventListener(UpdatePetFarmGuildeEvent.FINISH,this.__updatePetFarmGuilde);
         FarmModelController.instance.creatSuperPetFoodPriceList();
      }
      
      private function __updatePetFarmGuilde(param1:UpdatePetFarmGuildeEvent) : void
      {
         PetBagController.instance().finishTask();
         this.petFarmGuilde();
      }
      
      private function petFarmGuilde() : void
      {
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK2))
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.OPEN_PET_BAG,50,"farmTrainer.openBagArrowPos","asset.farmTrainer.clickHere","farmTrainer.openBagTipPos",this);
         }
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         PetBagController.instance().removeEventListener(UpdatePetFarmGuildeEvent.FINISH,this.__updatePetFarmGuilde);
         super.leaving(param1);
         FarmModelController.instance.stopTimer();
         MainToolBar.Instance.hide();
         this.dispose();
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.FARM;
      }
      
      override public function refresh() : void
      {
         super.refresh();
      }
      
      override public function dispose() : void
      {
         this._farmMainView.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
