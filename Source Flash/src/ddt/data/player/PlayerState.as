package ddt.data.player
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   
   public class PlayerState
   {
      
      public static const OFFLINE:int = 0;
      
      public static const ONLINE:int = 1;
      
      public static const AWAY:int = 2;
      
      public static const BUSY:int = 3;
      
      public static const SHOPPING:int = 4;
      
      public static const NO_DISTRUB:int = 5;
      
      public static const CLEAN_OUT:int = 6;
      
      public static const AUTO:int = 0;
      
      public static const MANUAL:int = 1;
       
      
      private var _stateID:int;
      
      private var _autoReply:String;
      
      private var _priority:int;
      
      public function PlayerState(param1:int, param2:int = 0)
      {
         super();
         this._stateID = param1;
         this._priority = param2;
      }
      
      public function get StateID() : int
      {
         return this._stateID;
      }
      
      public function get Priority() : int
      {
         return this._priority;
      }
      
      public function get AutoReply() : String
      {
         switch(this._stateID)
         {
            case AWAY:
               if(SharedManager.Instance.awayAutoReply[PlayerManager.Instance.Self.ID] != undefined)
               {
                  return SharedManager.Instance.awayAutoReply[PlayerManager.Instance.Self.ID];
               }
               return LanguageMgr.GetTranslation("im.playerState.awayReply");
               break;
            case BUSY:
               if(SharedManager.Instance.busyAutoReply[PlayerManager.Instance.Self.ID] != undefined)
               {
                  return SharedManager.Instance.busyAutoReply[PlayerManager.Instance.Self.ID];
               }
               return LanguageMgr.GetTranslation("im.playerState.busyReply");
               break;
            case NO_DISTRUB:
               if(SharedManager.Instance.noDistrubAutoReply[PlayerManager.Instance.Self.ID] != undefined)
               {
                  return SharedManager.Instance.noDistrubAutoReply[PlayerManager.Instance.Self.ID];
               }
               return LanguageMgr.GetTranslation("im.playerState.noDisturbReply");
               break;
            case SHOPPING:
               if(SharedManager.Instance.shoppingAutoReply[PlayerManager.Instance.Self.ID] != undefined)
               {
                  return SharedManager.Instance.shoppingAutoReply[PlayerManager.Instance.Self.ID];
               }
               return LanguageMgr.GetTranslation("im.playerState.shoppingReply");
               break;
            case CLEAN_OUT:
               if(SharedManager.Instance.shoppingAutoReply[PlayerManager.Instance.Self.ID] != undefined)
               {
                  return SharedManager.Instance.shoppingAutoReply[PlayerManager.Instance.Self.ID];
               }
               return LanguageMgr.GetTranslation("im.playerState.cleanOutReply");
               break;
            default:
               return "";
         }
      }
      
      public function set AutoReply(param1:String) : void
      {
         switch(this._stateID)
         {
            case AWAY:
               SharedManager.Instance.awayAutoReply[PlayerManager.Instance.Self.ID] = param1;
               break;
            case BUSY:
               SharedManager.Instance.busyAutoReply[PlayerManager.Instance.Self.ID] = param1;
               break;
            case NO_DISTRUB:
               SharedManager.Instance.noDistrubAutoReply[PlayerManager.Instance.Self.ID] = param1;
               break;
            case SHOPPING:
               SharedManager.Instance.shoppingAutoReply[PlayerManager.Instance.Self.ID] = param1;
               break;
            case CLEAN_OUT:
               SharedManager.Instance.shoppingAutoReply[PlayerManager.Instance.Self.ID] = param1;
         }
         SharedManager.Instance.save();
      }
      
      public function convertToString() : String
      {
         switch(this._stateID)
         {
            case AWAY:
               return LanguageMgr.GetTranslation("im.playerState.away");
            case OFFLINE:
               return LanguageMgr.GetTranslation("im.playerState.offline");
            case BUSY:
               return LanguageMgr.GetTranslation("im.playerState.busy");
            case NO_DISTRUB:
               return LanguageMgr.GetTranslation("im.playerState.noDisturb");
            case ONLINE:
               return LanguageMgr.GetTranslation("im.playerState.online");
            case SHOPPING:
               return LanguageMgr.GetTranslation("im.playerState.shopping");
            case CLEAN_OUT:
               return LanguageMgr.GetTranslation("im.playerState.cleanOut");
            default:
               return "未知";
         }
      }
   }
}
