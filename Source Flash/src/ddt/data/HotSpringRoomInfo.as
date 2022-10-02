package ddt.data
{
   public class HotSpringRoomInfo
   {
       
      
      private var _roomID:int;
      
      private var _roomNumber:int;
      
      private var _roomType:int;
      
      private var _roomName:String;
      
      private var _playerID:int;
      
      private var _playerName:String;
      
      private var _roomIsPassword:Boolean;
      
      private var _roomPassword:String;
      
      private var _effectiveTime:int;
      
      private var _maxCount:int;
      
      private var _curCount:int;
      
      private var _mapIndex:int;
      
      private var _startTime:Date;
      
      private var _breakTime:Date;
      
      private var _roomIntroduction:String;
      
      private var _serverID:int;
      
      public function HotSpringRoomInfo()
      {
         super();
      }
      
      public function get roomID() : int
      {
         return this._roomID;
      }
      
      public function set roomID(param1:int) : void
      {
         this._roomID = param1;
      }
      
      public function get roomType() : int
      {
         return this._roomType;
      }
      
      public function set roomType(param1:int) : void
      {
         this._roomType = param1;
      }
      
      public function get roomName() : String
      {
         return this._roomName;
      }
      
      public function set roomName(param1:String) : void
      {
         this._roomName = param1;
      }
      
      public function get playerID() : int
      {
         return this._playerID;
      }
      
      public function set playerID(param1:int) : void
      {
         this._playerID = param1;
      }
      
      public function get playerName() : String
      {
         return this._playerName;
      }
      
      public function set playerName(param1:String) : void
      {
         this._playerName = param1;
      }
      
      public function get roomIsPassword() : Boolean
      {
         return this._roomIsPassword;
      }
      
      public function set roomIsPassword(param1:Boolean) : void
      {
         this._roomIsPassword = param1;
      }
      
      public function get roomPassword() : String
      {
         return this._roomPassword;
      }
      
      public function set roomPassword(param1:String) : void
      {
         this._roomPassword = param1;
         this._roomIsPassword = this._roomPassword && this._roomPassword != "" && this._roomPassword.length > 0;
      }
      
      public function get effectiveTime() : int
      {
         return this._effectiveTime;
      }
      
      public function set effectiveTime(param1:int) : void
      {
         this._effectiveTime = param1;
      }
      
      public function get maxCount() : int
      {
         return this._maxCount;
      }
      
      public function set maxCount(param1:int) : void
      {
         this._maxCount = param1;
      }
      
      public function get curCount() : int
      {
         return this._curCount;
      }
      
      public function set curCount(param1:int) : void
      {
         this._curCount = param1;
      }
      
      public function get startTime() : Date
      {
         return this._startTime;
      }
      
      public function set startTime(param1:Date) : void
      {
         this._startTime = param1;
      }
      
      public function get breakTime() : Date
      {
         return this._breakTime;
      }
      
      public function set breakTime(param1:Date) : void
      {
         this._breakTime = param1;
      }
      
      public function get roomIntroduction() : String
      {
         return this._roomIntroduction;
      }
      
      public function set roomIntroduction(param1:String) : void
      {
         this._roomIntroduction = param1;
      }
      
      public function get serverID() : int
      {
         return this._serverID;
      }
      
      public function set serverID(param1:int) : void
      {
         this._serverID = param1;
      }
      
      public function get roomNumber() : int
      {
         return this._roomNumber;
      }
      
      public function set roomNumber(param1:int) : void
      {
         this._roomNumber = param1;
      }
   }
}
