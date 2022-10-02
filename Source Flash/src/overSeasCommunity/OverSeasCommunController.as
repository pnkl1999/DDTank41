package overSeasCommunity
{
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   
   public class OverSeasCommunController extends EventDispatcher
   {
      
      public static const ACHIEVE:String = "Achieve";
      
      public static const COMPLETE:String = "Complete";
      
      public static const JOIN:String = "Join";
      
      public static const DEFEAT:String = "Defeat";
      
      public static const PUBLISH:String = "Publish";
      
      public static const LEVEL:String = "Level";
      
      public static const STRENGTH:String = "Strength";
      
      public static const FUSION:String = "Fusion";
      
      public static const MARRIAGE:String = "Marriage";
      
      public static const CONSORTIA:String = "Consortia";
      
      public static const BOSS:String = "Boss";
      
      public static const PVP:String = "PVP";
      
      public static const GUILD:String = "Guild";
      
      public static const PVP2V2:String = "PvP2V2";
      
      private static var _instance:OverSeasCommunController;
       
      
      private var _fbSendID:int = -1;
      
      private var _fbAction:String;
      
      private var _fbObject:String;
      
      private var _fbParam:String;
      
      private var _fbMessage:String;
      
      private var _fbUserName:String;
      
      private var _fbUserID:int;
      
      private var _fbServerID:int;
      
      public var firstStrength:Boolean = true;
      
      public var firstCompose:Boolean = true;
      
      public var firstMarry:Boolean = true;
      
      public var firstClub:Boolean = true;
      
      public var antEasy:Boolean = true;
      
      public var boguEasy:Boolean = true;
      
      public var boguNormal:Boolean = true;
      
      public var boguHard:Boolean = true;
      
      public var xieshenHard:Boolean = true;
      
      public var PVPDaily:Boolean = true;
      
      public var guildWarDaily:Boolean = true;
      
      public var PVPVictoryDaily:Boolean = true;
      
      public var PVP2V2Daily:Boolean = true;
      
      public function OverSeasCommunController()
      {
         super();
      }
      
      public static function instance() : OverSeasCommunController
      {
         if(!_instance)
         {
            _instance = new OverSeasCommunController();
         }
         return _instance;
      }
      
      public function facebookFeedSetUp() : void
      {
      }
      
      public function setFacebookParam(param1:int, param2:String, param3:String, param4:String, param5:String) : void
      {
         this._fbSendID = param1;
         this._fbAction = param2;
         this._fbObject = param3;
         this._fbParam = param4;
         this.sendQuest();
         this.facebookSendToFeed(param5);
      }
      
      public function sendQuest() : void
      {
         if(this._fbSendID == -1)
         {
            return;
         }
         switch(this._fbSendID)
         {
            case 6:
               if(TaskManager.getQuestByID(2005) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2005,1,0);
               }
            case 5:
               if(TaskManager.getQuestByID(2004) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2004,1,0);
               }
            case 4:
               if(TaskManager.getQuestByID(2003) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2003,1,0);
               }
            case 3:
               if(TaskManager.getQuestByID(2002) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2002,1,0);
               }
            case 2:
               if(TaskManager.getQuestByID(2001) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2001,1,0);
               }
            case 1:
               if(TaskManager.getQuestByID(2000) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2000,1,0);
               }
               break;
            case 7:
               this.firstStrength = false;
               if(TaskManager.getQuestByID(2006) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2006,1,0);
               }
               break;
            case 8:
               this.firstCompose = false;
               if(TaskManager.getQuestByID(2007) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2007,1,0);
               }
               break;
            case 9:
               this.firstMarry = false;
               if(TaskManager.getQuestByID(2008) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2008,1,0);
               }
               break;
            case 10:
               this.firstClub = false;
               if(TaskManager.getQuestByID(2009) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2009,1,0);
               }
               break;
            case 11:
               this.antEasy = false;
               if(TaskManager.getQuestByID(2010) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2010,1,0);
               }
               break;
            case 14:
               this.boguEasy = false;
               if(TaskManager.getQuestByID(2013) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2013,1,0);
               }
               break;
            case 15:
               this.boguNormal = false;
               if(TaskManager.getQuestByID(2014) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2014,1,0);
               }
               break;
            case 17:
               this.boguHard = false;
               if(TaskManager.getQuestByID(2016) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2016,1,0);
               }
               break;
            case 18:
               this.xieshenHard = false;
               if(TaskManager.getQuestByID(2017) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2017,1,0);
               }
               break;
            case 13:
               this.guildWarDaily = false;
               if(TaskManager.getQuestByID(2012) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2012,1,0);
               }
            case 12:
               this.PVPDaily = false;
               if(TaskManager.getQuestByID(2011) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2011,1,0);
               }
               break;
            case 16:
               this.PVPVictoryDaily = false;
               if(TaskManager.getQuestByID(2015) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2015,1,0);
               }
               break;
            case 19:
               this.PVP2V2Daily = false;
               if(TaskManager.getQuestByID(2018) != null)
               {
                  SocketManager.Instance.out.sendQuestCheck(2018,1,0);
               }
         }
      }
      
      public function get serverID() : int
      {
         return this._fbServerID;
      }
      
      public function set serverID(param1:int) : void
      {
         this._fbServerID = param1;
      }
      
      public function facebookSendToFeed(param1:String) : void
      {
         var _loc2_:Object = {
            "share_type":"1",
            "picture_type":"1",
            "picture":"",
            "caption":"",
            "description":param1
         };
         ExternalInterface.call("facebookSend",_loc2_);
      }
   }
}
