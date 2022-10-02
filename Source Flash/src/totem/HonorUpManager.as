package totem
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   import totem.data.HonorUpDataAnalyz;
   
   public class HonorUpManager extends EventDispatcher
   {
      
      public static const UP_COUNT_UPDATE:String = "up_count_update";
      
      private static var _instance:HonorUpManager;
       
      
      public var upCount:int = -1;
      
      private var _dataList:Array;
      
      public function HonorUpManager()
      {
         super();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HONOR_UP_COUNT,this.updateUpCount);
      }
      
      public static function get instance() : HonorUpManager
      {
         if(_instance == null)
         {
            _instance = new HonorUpManager();
         }
         return _instance;
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
      
      private function updateUpCount(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(this.upCount != -1 && this.upCount != _loc3_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.honorUp.success",this.dataList[_loc3_ - 1].honor),0,true);
         }
         this.upCount = _loc3_;
         dispatchEvent(new Event(UP_COUNT_UPDATE));
      }
      
      public function setup(param1:HonorUpDataAnalyz) : void
      {
         this._dataList = param1.dataList;
      }
   }
}
