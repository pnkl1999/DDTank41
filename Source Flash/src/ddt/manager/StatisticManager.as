package ddt.manager
{
   public class StatisticManager
   {
      
      public static var StatisticPage:String = "ddt_game/List_BI_Click.ashx";
      
      public static var siteName:String = "";
      
      public static var loginRoomListNum:int = 0;
      
      public static const LOADING:String = "loading";
      
      public static const CHECKSEX:String = "checkSex";
      
      public static const LOGINSERVER:String = "loginServer";
      
      public static const LOGINHALL:String = "loginHall";
      
      public static const LOGINROOMLIST:String = "loginRoomList";
      
      public static const LOGINROOM:String = "loginRoom";
      
      public static const GAME:String = "game";
      
      public static const MAPLOADING:String = "mapLoading";
      
      public static const GAMEOVER:String = "gameOver";
      
      public static const SAVEFILE:String = "saveFile";
      
      public static const NEWBOOK:String = "newBook";
      
      public static const USERGUIDE:String = "userGuide";
      
      public static const REGISTERCHARACTER:String = "registerCharacter";
      
      public static const TRAINER1OVER:String = "tra1Over";
      
      public static const TRAINER1ENTERTIP:String = "tra1EnterTip";
      
      public static const TRAINER1LOADING:String = "tra1Loading";
      
      public static const TRAINER1QUESTION1:String = "tra1Question1";
      
      public static const TRAINER1QUESTION2:String = "tra1Question2";
      
      private static var _instance:StatisticManager;
       
      
      public var isStatistic:Boolean = true;
      
      public var IsNovice:Boolean = false;
      
      private var _loginServer:Boolean = true;
      
      private var _loginHall:Boolean = true;
      
      private var _loginRoomList:Boolean = true;
      
      private var _loginRoom:Boolean = true;
      
      private var _gameOver:Boolean = true;
      
      private var _game:Boolean = true;
      
      private var _gameNum:int = 0;
      
      private var _saveFile:Boolean = true;
      
      private var _newbook:Boolean = true;
      
      private var _checkSex:Boolean = true;
      
      private var _loading:Boolean = true;
      
      private var _mapLoading:Boolean = true;
      
      public var gameNumII:Number = 0;
      
      public function StatisticManager()
      {
         super();
      }
      
      public static function Instance() : StatisticManager
      {
         if(_instance == null)
         {
            _instance = new StatisticManager();
         }
         return _instance;
      }
      
      public function startAction(param1:String, param2:String) : void
      {
         var _loc3_:Object = null;
         if(this.isStatistic)
         {
            _loc3_ = new Object();
            _loc3_.appid = "1";
            _loc3_.style = param1 + "_" + param2;
            _loc3_.subid = ServerManager.Instance.AgentID;
         }
      }
      
      public function get gameNum() : int
      {
         return this._gameNum;
      }
   }
}
