package ddt.data
{
   public class InviteInfo
   {
       
      
      public var playerid:int;
      
      public var roomid:int;
      
      public var mapid:int;
      
      public var secondType:int;
      
      public var gameMode:int;
      
      public var hardLevel:int;
      
      public var levelLimits:int;
      
      public var nickname:String;
      
      public var IsVip:Boolean = false;
      
      public var VIPLevel:int = 1;
      
      public var password:String;
      
      public var barrierNum:int;
      
      public var RN:String;
      
      public var isOpenBoss:Boolean;
      
      public function InviteInfo()
      {
         super();
      }
   }
}
