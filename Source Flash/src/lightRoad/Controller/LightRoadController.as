package lightRoad.Controller
{
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import lightRoad.manager.LightRoadManager;
   
   public class LightRoadController extends BaseStateView
   {
      
      private static var _instance:LightRoadController;
       
      
      public function LightRoadController()
      {
         super();
      }
      
      public static function get Instance() : LightRoadController
      {
         if(!_instance)
         {
            _instance = new LightRoadController();
         }
         return _instance;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         LightRoadManager.instance.ShowMainFrame = true;
         StateManager.setState(StateType.MAIN);
      }
      
      override public function getType() : String
      {
         return StateType.LIGHTROAD_WINDOW;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      protected function init() : void
      {
      }
      
      override public function dispose() : void
      {
      }
   }
}
