package ddt.manager
{
   import ddt.events.CrazyTankSocketEvent;
   import flash.display.Stage;
   import flash.events.Event;
   import overSeasCommunity.OverSeasCommunController;
   
   public class QueueManager
   {
      
      private static var _executable:Array = new Array();
      
      public static var _waitlist:Array = new Array();
      
      private static var _lifeTime:int = 0;
      
      private static var _running:Boolean = true;
      
      private static var _diffTimeValue:int = 0;
      
      private static var _speedUp:int = 2;
      
      private static var _fbSendID:int = -1;
      
      private static var _fbAction:String;
      
      private static var _fbObject:String;
      
      private static var _fbParam:String;
      
      private static var _fbMessage:String;
      
      private static var facebookRunning:Boolean = false;
      
      private static var facebookTime:int = 0;
      
      public static var facebookResumeEnable:Boolean = false;
       
      
      public function QueueManager()
      {
         super();
      }
      
      public static function get lifeTime() : int
      {
         return _lifeTime;
      }
      
      public static function setup(param1:Stage) : void
      {
         param1.addEventListener(Event.ENTER_FRAME,frameHandler);
      }
      
      public static function pause() : void
      {
         _running = false;
      }
      
      public static function resume() : void
      {
         _running = true;
      }
      
      public static function setLifeTime(param1:int) : void
      {
         _lifeTime = param1;
         _executable.concat(_waitlist);
      }
      
      public static function addQueue(param1:CrazyTankSocketEvent) : void
      {
         _waitlist.push(param1);
      }
      
      private static function frameHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:CrazyTankSocketEvent = null;
         ++_lifeTime;
         if(_running)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _waitlist.length)
            {
               _loc5_ = _waitlist[_loc3_];
               if(_loc5_.pkg.extend2 > _lifeTime)
               {
                  break;
               }
               _executable.push(_loc5_);
               _loc2_++;
               _loc3_++;
            }
            _waitlist.splice(0,_loc2_);
            _loc2_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _executable.length)
            {
               if(_running)
               {
                  dispatchEvent(_executable[_loc4_]);
                  _loc2_++;
               }
               _loc4_++;
            }
            _executable.splice(0,_loc2_);
         }
         if(facebookRunning)
         {
            if(++facebookTime >= 700)
            {
               feedFaceBookQuest();
            }
         }
      }
      
      private static function dispatchEvent(param1:Event) : void
      {
         var event:Event = null;
         event = param1;
         try
         {
            SocketManager.Instance.dispatchEvent(event);
            return;
         }
         catch(err:Error)
         {
            SocketManager.Instance.out.sendErrorMsg("type:" + event.type + "msg:" + err.message + "\r\n" + err.getStackTrace());
            return;
         }
      }
      
      public static function addFeedQueue(param1:int, param2:String, param3:String, param4:String, param5:String) : void
      {
         _fbSendID = param1;
         _fbAction = param2;
         _fbObject = param3;
         _fbParam = param4;
         _fbMessage = param5;
         facebookResumeEnable = true;
      }
      
      public static function pauseFaceBookFeed() : void
      {
         facebookRunning = false;
      }
      
      public static function resumeFaceBookFeed() : void
      {
         facebookRunning = true;
      }
      
      public static function feedFaceBookQuest() : void
      {
         facebookResumeEnable = false;
         facebookRunning = false;
         facebookTime = 0;
         OverSeasCommunController.instance().setFacebookParam(_fbSendID,_fbAction,_fbObject,_fbParam,_fbMessage);
         _fbSendID = -1;
         _fbAction = "";
         _fbObject = "";
         _fbParam = "";
         _fbMessage = "";
      }
   }
}
