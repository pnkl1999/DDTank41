package lottery.contorller
{
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import lottery.view.CardChooseView;
   
   public class CardLotteryContorller extends BaseStateView
   {
       
      
      private var _view:CardChooseView;
      
      public function CardLotteryContorller()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this.init();
         MainToolBar.Instance.show();
      }
      
      private function init() : void
      {
         this._view = new CardChooseView();
         addChild(this._view);
      }
      
      override public function dispose() : void
      {
      }
      
      public function get model() : *
      {
         return null;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         MainToolBar.Instance.hide();
         super.leaving(param1);
         this.dispose();
      }
      
      override public function getType() : String
      {
         return StateType.LOTTERY_CARD;
      }
      
      override public function getBackType() : String
      {
         return StateType.LOTTERY_HALL;
      }
   }
}
