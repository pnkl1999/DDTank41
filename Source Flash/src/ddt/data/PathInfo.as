package ddt.data
{
   public class PathInfo
   {
      
      public static var GAME_BOXPIC:int;
      
      public static var LANGUAGE:String = "";
      
      public static var MUSIC_LIST:Array;
      
      public static var GAME_WIDTH:Number = 1000;
      
      public static var GAME_HEIGHT:Number = 600;
      
      public static var SUCIDE_TIME:int = 120;
      
      public static var ISTOPDERIICT:Boolean = false;
      
      public static var isUserAddFriend:Boolean = false;
      
      public static var SERVER_NUMBER:int = 4;
       
      
      public var FLASHSITE:String = "";
      
      public var BACKUP_FLASHSITE:String = "";
      
      public var SITE:String = "";
      
      public var REQUEST_PATH:String = "";
      
      public var RES_PATH:String = "";
      
      public var MAP_PATH:String = "";
      
      public var STYLE_PATH:String = "style/";
      
      public var RTMP_PATH:String = "";
      
      public var LOGIN_PATH:String = "";
      
      public var USER_NAME:String;
      
      public var FIRSTPAGE:String;
      
      public var REGISTER:String;
      
      public var FILL_PATH:String;
      
      public var CLIENT_DOWNLOAD:String;
      
      public var TRAINER_PATH:String;
      
      public var COUNT_PATH:String;
      
      public var PARTER_ID:String;
      
      public var SITEII:String;
      
      public var PHP_PATH:String;
      
      public var PHP_IMAGE_LINK:Boolean = true;
      
      public var WEB_PLAYER_INFO_PATH:String;
      
      public var OFFICIAL_SITE:String;
      
      public var GAME_FORUM:String;
      
      public var COMMUNITY_FRIEND_PATH:String;
      
      public var COMMUNITY_INVITE_PATH:String;
      
      public var COMMUNITY_FRIEND_LIST_PATH:String;
      
      public var SNS_PATH:String;
      
      public var MICROCOBOL_PATH:String;
      
      public var COMMUNITY_EXIST:Boolean;
      
      public var COMMUNITY_FRIEND_INVITED_SWITCH:Boolean;
      
      public var COMMUNITY_FRIEND_INVITED_ONLINE_SWITCH:Boolean;
      
      public var IS_VISIBLE_EXISTBTN:Boolean;
      
      public var ALLOW_POPUP_FAVORITE:Boolean;
      
      public var FILL_JS_COMMAND_ENABLE:Boolean;
      
      public var FILL_JS_COMMAND_VALUE:String;
      
      public var SERVERLISTINDEX:int = -1;
      
      public var EXTERNAL_INTERFACE_PATH:String;
      
      public var EXTERNAL_INTERFACE_ENABLE:Boolean;
      
      public var FEEDBACK_ENABLE:Boolean;
      
      public var FEEDBACK_TEL_NUMBER:String;
      
      public var SPA_ENABLE:Boolean = true;
      
      public var CIVIL_ENABLE:Boolean = true;
      
      public var CHURCH_ENABLE:Boolean = true;
      
      public var WEEKLY_ENABLE:Boolean = true;
      
      public var ACHIEVE_ENABLE:Boolean = true;
      
      public var FORTH_ENABLE:Boolean = true;
      
      public var STHRENTH_MAX:int = 12;
      
      public var USER_GUILD_ENABLE:Boolean = true;
      
      public var COMMUNITY_MICROBLOG:Boolean = false;
      
      public var COMMUNITY_SINA_SECOND_MICROBLOG:Boolean = false;
      
      public var CHAT_FACE_DISABLED_LIST:Array;
      
      public var FIGHTLIB_ENABLE:Boolean = true;
      
      public var FRAME_TIME_OVER_TAG:int = 67;
      
      public var FRAME_OVER_COUNT_TAG:int = 25;
      
      public var DUNGEON_OPEN:Array;
      
      public var TRAINER_STANDALONE:Boolean = true;
      
      public var STATISTICS:Boolean = true;
      
      public var EXTERNAL_INTERFACE_PATH_360:String;
      
      public var EXTERNAL_INTERFACE_ENABLE_360:Boolean;
      
      public var DISABLE_TASK_ID:String = "";
      
      public var LITTLEGAMEMINLV:int;
      
      public var WEEKLY_SITE:String = "";
      
      public var LOTTERY_ENABLE:Boolean = false;
      
      public var CROSSBUGGlLEBTN_ENABLE:Boolean = false;
      
      public var SHORTCUT_ENABLE:Boolean;
      
      public var LUCKY_NUMBER_ENABLE:Boolean = true;
      
      public var FACEBOOK_ENABLE:Boolean;
      
      public var FACEBOOK_FEEDPAGE_LINK:String;
      
      public var PETS_EAT:Boolean;
      
      public var SUIT_ENABLE:Boolean;
	  
	  public var HOTSPRING_CONTINUE:Boolean;
	  
	  public var GEMSTONE_ENABLE:Boolean = true;
	  
	  public var TOTEM_ENABLE:Boolean;
	  
	  public var NECKLACE_ENABLE:Boolean;
      
      public function PathInfo()
      {
         this.DUNGEON_OPEN = [];
         super();
      }
   }
}
