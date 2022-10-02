package accumulativeLogin
{
   import accumulativeLogin.view.AccumulativeLoginView;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class AccumulativeManager extends EventDispatcher
   {
      
      public static const ACCUMULATIVE_AWARD_REFRESH:String = "accumulativeLoginAwardRefresh";
      
      private static var _instance:AccumulativeManager;
       
      
      public var dataDic:Dictionary;
      
      public function AccumulativeManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : AccumulativeManager
      {
         if(_instance == null)
         {
            _instance = new AccumulativeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACCUMULATIVELOGIN_AWARD,this.__awardHandler);
      }
      
      protected function __awardHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:SelfInfo = PlayerManager.Instance.Self;
         _loc3_.accumulativeLoginDays = _loc2_.readInt();
         _loc3_.accumulativeAwardDays = _loc2_.readInt();
         dispatchEvent(new Event(ACCUMULATIVE_AWARD_REFRESH));
      }
      
      public function addAct() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.ACCUMULATIVE_LOGIN,true);
      }
      
      public function removeAct() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.ACCUMULATIVE_LOGIN,false);
      }
      
      public function loadTempleteDataComplete(param1:AccumulativeLoginAnalyer) : void
      {
         this.dataDic = param1.accumulativeloginDataDic;
      }
      
      public function showFrame() : void
      {
         var _loc1_:AccumulativeLoginView = null;
         _loc1_ = null;
         _loc1_ = new AccumulativeLoginView();
         _loc1_.init();
         _loc1_.x = -227;
         HallIconManager.instance.showCommonFrame(_loc1_,"wonderfulActivityManager.btnTxt15");
      }
   }
}
