package tofflist.data
{
   public class TofflistConsortiaData
   {
       
      
      private var _playerInfo:TofflistPlayerInfo;
      
      private var _consortiaInfo:TofflistConsortiaInfo;
      
      public function TofflistConsortiaData()
      {
         super();
      }
      
      public function set playerInfo(param1:TofflistPlayerInfo) : void
      {
         this._playerInfo = param1;
      }
      
      public function get playerInfo() : TofflistPlayerInfo
      {
         return this._playerInfo;
      }
      
      public function set consortiaInfo(param1:TofflistConsortiaInfo) : void
      {
         this._consortiaInfo = param1;
      }
      
      public function get consortiaInfo() : TofflistConsortiaInfo
      {
         return this._consortiaInfo;
      }
   }
}
