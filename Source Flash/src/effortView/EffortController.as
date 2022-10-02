package effortView
{
   import ddt.manager.EffortManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class EffortController extends EventDispatcher
   {
       
      
      private var _currentRightViewType:int;
      
      private var _currentViewType:int;
      
      private var _isSelf:Boolean;
      
      public function EffortController()
      {
         super();
         this._currentRightViewType = 0;
         this._currentViewType = 0;
         this._isSelf = true;
      }
      
      public function set isSelf(param1:Boolean) : void
      {
         this._isSelf = param1;
      }
      
      public function set currentRightViewType(param1:int) : void
      {
         this._currentRightViewType = param1;
         if(this._isSelf)
         {
            this.updateRightView(this._currentRightViewType);
         }
         else
         {
            this.updateTempRightView(this._currentRightViewType);
         }
      }
      
      public function get currentRightViewType() : int
      {
         return this._currentRightViewType;
      }
      
      public function set currentViewType(param1:int) : void
      {
         this._currentViewType = param1;
         if(this._isSelf)
         {
            this.updateView(this._currentViewType);
         }
         else
         {
            this.updateTempView(this._currentViewType);
         }
      }
      
      public function get currentViewType() : int
      {
         return this._currentViewType;
      }
      
      private function updateRightView(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               break;
            case 1:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getRoleEffort();
               break;
            case 2:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTaskEffort();
               break;
            case 3:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getDuplicateEffort();
               break;
            case 4:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getCombatEffort();
               break;
            case 5:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getIntegrationEffort();
               break;
            case 6:
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateView(param1:int) : void
      {
         EffortManager.Instance.setEffortType(param1);
      }
      
      private function updateTempRightView(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               break;
            case 1:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTempRoleEffort();
               break;
            case 2:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTempTaskEffort();
               break;
            case 3:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTempDuplicateEffort();
               break;
            case 4:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTempCombatEffort();
               break;
            case 5:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTempIntegrationEffort();
               break;
            case 6:
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateTempView(param1:int) : void
      {
         EffortManager.Instance.setTempEffortType(param1);
      }
   }
}
