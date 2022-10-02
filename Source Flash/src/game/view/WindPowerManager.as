package game.view
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import game.model.WindPowerImgData;
   import road7th.comm.PackageIn;
   
   public class WindPowerManager
   {
      
      private static var _instance:WindPowerManager;
       
      
      private var _windPicMode:WindPowerImgData;
      
      public function WindPowerManager()
      {
         super();
      }
      
      public static function get Instance() : WindPowerManager
      {
         if(_instance == null)
         {
            _instance = new WindPowerManager();
         }
         return _instance;
      }
      
      public function init() : void
      {
         this._windPicMode = new WindPowerImgData();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WINDPIC,this._windPicCome);
      }
      
      private function _windPicCome(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:ByteArray = _loc2_.readByteArray();
         this._windPicMode.refeshData(_loc4_,_loc3_);
      }
      
      public function getWindPic(param1:Array) : BitmapData
      {
         return this._windPicMode.getImgBmp(param1);
      }
      
      public function getWindPicById(param1:int) : BitmapData
      {
         return this._windPicMode.getImgBmpById(param1);
      }
   }
}
