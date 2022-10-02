package ddt.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.AcademyMemberListAnalyze;
   import ddt.data.analyze.MyAcademyPlayersAnalyze;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.socket.AcademyPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.academyCommon.data.SimpleMessger;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class AcademyManager extends EventDispatcher
   {
      
      public static const SELF_DESCRIBE:String = "selfDescribe";
      
      public static const LEVEL_GAP:int = 5;
      
      public static const TARGET_PLAYER_MIN_LEVEL:int = 6;
      
      public static const ACADEMY_LEVEL_MIN:int = 20;
      
      public static const FARM_PLAYER_MIN_LEVEL:int = 25;
      
      public static const ACADEMY_LEVEL_MAX:int = 16;
      
      public static const RECOMMEND_MAX_NUM:int = 3;
      
      public static const GRADUATE_NUM:Array = [1,5,10,50,99];
      
      public static const MASTER:Boolean = false;
      
      public static const APPSHIP:Boolean = true;
      
      public static const ACADEMY:Boolean = true;
      
      public static const RECOMMEND:Boolean = false;
      
      public static const NONE_STATE:int = 0;
      
      public static const APPRENTICE_STATE:int = 1;
      
      public static const MASTER_STATE:int = 2;
      
      public static const MASTER_FULL_STATE:int = 3;
      
      private static var _instance:AcademyManager;
       
      
      public var isShowRecommend:Boolean = true;
      
      public var freezesDate:Date;
      
      public var selfIsRegister:Boolean;
      
      public var isSelfPublishEquip:Boolean;
      
      private var _showMessage:Boolean = true;
      
      private var _recommendPlayers:Vector.<AcademyPlayerInfo>;
      
      private var _myAcademyPlayers:DictionaryData;
      
      private var _messgers:Vector.<SimpleMessger>;
      
      private var _selfDescribe:String;
      
      public function AcademyManager()
      {
         super();
      }
      
      public static function get Instance() : AcademyManager
      {
         if(_instance == null)
         {
            _instance = new AcademyManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
         this._messgers = new Vector.<SimpleMessger>();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.APPRENTICE_SYSTEM_ANSWER,this.__apprenticeSystemAnswer);
      }
      
      private function __apprenticeSystemAnswer(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:Boolean = false;
         var _loc2_:int = param1.pkg.readByte();
         switch(_loc2_)
         {
            case AcademyPackageType.ACADEMY_FOR_APPRENTICE:
               _loc3_ = param1.pkg.readInt();
               _loc4_ = param1.pkg.readUTF();
               _loc5_ = param1.pkg.readUTF();
               AcademyFrameManager.Instance.showAcademyAnswerMasterFrame(_loc3_,_loc4_,_loc5_);
               break;
            case AcademyPackageType.ACADEMY_FOR_MASTER:
               _loc6_ = param1.pkg.readInt();
               _loc7_ = param1.pkg.readUTF();
               _loc8_ = param1.pkg.readUTF();
               if(PlayerManager.Instance.Self.apprenticeshipState == AcademyManager.APPRENTICE_STATE)
               {
                  return;
               }
               AcademyFrameManager.Instance.showAcademyAnswerApprenticeFrame(_loc6_,_loc7_,_loc8_);
               break;
            case AcademyPackageType.UPDATE_APP_STATES:
               PlayerManager.Instance.Self.apprenticeshipState = param1.pkg.readInt();
               PlayerManager.Instance.Self.masterID = param1.pkg.readInt();
               PlayerManager.Instance.Self.setMasterOrApprentices(param1.pkg.readUTF());
               _loc9_ = param1.pkg.readInt();
               PlayerManager.Instance.Self.graduatesCount = param1.pkg.readInt();
               PlayerManager.Instance.Self.honourOfMaster = param1.pkg.readUTF();
               PlayerManager.Instance.Self.freezesDate = param1.pkg.readDate();
               if(this._myAcademyPlayers && _loc9_ != -1)
               {
                  this._myAcademyPlayers.remove(_loc9_);
               }
               if(this._myAcademyPlayers && PlayerManager.Instance.Self.apprenticeshipState == NONE_STATE)
               {
                  this._myAcademyPlayers.clear();
               }
               if(PlayerManager.Instance.Self.apprenticeshipState != NONE_STATE)
               {
                  TaskManager.requestCanAcceptTask();
               }
               break;
            case AcademyPackageType.APPRENTICE_GRADUTE:
               _loc10_ = param1.pkg.readInt();
               _loc11_ = param1.pkg.readInt();
               _loc12_ = param1.pkg.readUTF();
               if(_loc10_ == 0)
               {
                  AcademyFrameManager.Instance.showApprenticeGraduate();
               }
               else if(_loc10_ == 1)
               {
                  AcademyFrameManager.Instance.showMasterGraduate(_loc12_);
               }
               break;
            case AcademyPackageType.APPRENTICE_CONFIRM:
            case AcademyPackageType.MASTER_CONFIRM:
               _loc13_ = param1.pkg.readInt();
               _loc14_ = param1.pkg.readUTF();
               break;
            case AcademyPackageType.APPRENTICESHIPSYSTEM_ALERT:
               _loc15_ = param1.pkg.readUTF();
               _loc16_ = param1.pkg.readBoolean();
               this.academyAlert(_loc15_,_loc16_);
         }
      }
      
      private function academyAlert(param1:String, param2:Boolean) : void
      {
         var _loc3_:BaseAlerFrame = null;
         if(param2)
         {
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),param1,LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE,this.__onCancel);
         }
         else if(!this.isFighting())
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),param1,LanguageMgr.GetTranslation("ddt.manager.AcademyManager.alertSubmit"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         }
         else if(StateManager.currentStateType == StateType.HOT_SPRING_ROOM || StateManager.currentStateType == StateType.CHURCH_ROOM)
         {
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),param1,LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE,this.__onCancel);
         }
      }
      
      private function __onCancel(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         (param1.currentTarget as BaseAlerFrame).dispose();
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         (param1.currentTarget as BaseAlerFrame).dispose();
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               StateManager.setState(StateType.ACADEMY_REGISTRATION);
         }
      }
      
      public function loadAcademyMemberList(param1:Function, param2:Boolean = true, param3:Boolean = false, param4:int = 1, param5:String = "", param6:int = 0, param7:Boolean = true, param8:Boolean = false) : void
      {
         var _loc9_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc9_["requestType"] = param2;
         _loc9_["appshipStateType"] = param3;
         _loc9_["page"] = param4;
         _loc9_["name"] = param5;
         _loc9_["Grade"] = param6;
         _loc9_["sex"] = param7;
         _loc9_["isReturnSelf"] = param8;
         var _loc10_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ApprenticeshipClubList.ashx"),BaseLoader.REQUEST_LOADER,_loc9_);
         _loc10_.loadErrorMessage = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.infoError");
         _loc10_.analyzer = new AcademyMemberListAnalyze(param1);
         LoaderManager.Instance.startLoad(_loc10_);
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("aler"),param1.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function recommend() : void
      {
         if(this.isOpenSpace(PlayerManager.Instance.Self) || !this.isRecommend())
         {
            return;
         }
         if(!DateUtils.isToday(new Date(PlayerManager.Instance.Self.LastDate)) || !SharedManager.Instance.isRecommend)
         {
            this._showMessage = false;
            if(PlayerManager.Instance.Self.Grade < ACADEMY_LEVEL_MIN)
            {
               this.loadAcademyMemberList(this.__recommendPlayersComplete,RECOMMEND,MASTER,1,"",PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.Sex);
            }
            else
            {
               this.loadAcademyMemberList(this.__recommendPlayersComplete,RECOMMEND,APPSHIP,1,"",PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.Sex);
            }
         }
      }
      
      public function recommends() : void
      {
         if(this.isOpenSpace(PlayerManager.Instance.Self))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warning8"));
            return;
         }
         this._showMessage = true;
         if(PlayerManager.Instance.Self.Grade < ACADEMY_LEVEL_MIN)
         {
            this.loadAcademyMemberList(this.__recommendPlayersComplete,RECOMMEND,MASTER,1,"",PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.Sex);
         }
         else
         {
            this.loadAcademyMemberList(this.__recommendPlayersComplete,RECOMMEND,APPSHIP,1,"",PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.Sex);
         }
      }
      
      private function __recommendPlayersComplete(param1:AcademyMemberListAnalyze) : void
      {
         this._recommendPlayers = param1.academyMemberList;
         if(this._recommendPlayers.length >= 3)
         {
            if(PlayerManager.Instance.Self.Grade < ACADEMY_LEVEL_MIN)
            {
               AcademyFrameManager.Instance.showAcademyApprenticeMainFrame();
            }
            else
            {
               AcademyFrameManager.Instance.showAcademyMasterMainFrame();
            }
         }
         else if(this._showMessage)
         {
            if(PlayerManager.Instance.Self.Grade >= AcademyManager.ACADEMY_LEVEL_MIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.data.analyze.AcademyMemberListAnalyze.info"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.data.analyze.AcademyMemberListAnalyze.infoI"));
            }
         }
         this.isShowRecommend = false;
      }
      
      public function get recommendPlayers() : Vector.<AcademyPlayerInfo>
      {
         return this._recommendPlayers;
      }
      
      public function get myAcademyPlayers() : DictionaryData
      {
         return this._myAcademyPlayers;
      }
      
      public function myAcademy() : void
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["RelationshipID"] = PlayerManager.Instance.Self.masterID;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("UserApprenticeshipInfoList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
         _loc2_.analyzer = new MyAcademyPlayersAnalyze(this.__myAcademyPlayersComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      private function __myAcademyPlayersComplete(param1:MyAcademyPlayersAnalyze) : void
      {
         this._myAcademyPlayers = param1.myAcademyPlayers;
         if(this._myAcademyPlayers.length == 0)
         {
            return;
         }
         if(PlayerManager.Instance.Self.Grade < ACADEMY_LEVEL_MIN)
         {
            AcademyFrameManager.Instance.showMyAcademyApprenticeFrame();
         }
         else
         {
            AcademyFrameManager.Instance.showMyAcademyMasterFrame();
         }
      }
      
      public function compareState(param1:BasePlayer, param2:PlayerInfo) : Boolean
      {
         if(this.isOpenSpace(param1))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warning7"));
            return false;
         }
         if(this.isOpenSpace(param2))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warning8"));
            return false;
         }
         if(param2.Grade < TARGET_PLAYER_MIN_LEVEL)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warning6"));
            return false;
         }
         if(param1.Grade < TARGET_PLAYER_MIN_LEVEL)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warningII"));
            return false;
         }
         if(param2.apprenticeshipState == APPRENTICE_STATE)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.WarningApprenticeState"));
            return false;
         }
         if(param2.apprenticeshipState == MASTER_FULL_STATE)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.WarningMasterFullState"));
            return false;
         }
         if(param2.Grade >= ACADEMY_LEVEL_MIN)
         {
            if(param1.Grade >= ACADEMY_LEVEL_MIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warningIII"));
               return false;
            }
            if(param2.Grade - param1.Grade >= LEVEL_GAP)
            {
               return true;
            }
            if(param2.Grade - param1.Grade < LEVEL_GAP)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warning"));
               return false;
            }
         }
         else
         {
            if(param1.Grade < ACADEMY_LEVEL_MIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warningIIII"));
               return false;
            }
            if(param1.Grade - param2.Grade >= LEVEL_GAP)
            {
               return true;
            }
            if(param1.Grade - param2.Grade < LEVEL_GAP)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warningI"));
               return false;
            }
         }
         return false;
      }
      
      public function gotoAcademyState() : void
      {
         var _loc1_:BaseAlerFrame = null;
         if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.MISSION_ROOM || StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.FRESHMAN_ROOM)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.manager.AcademyManager.warning10"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         else
         {
            StateManager.setState(StateType.ACADEMY_REGISTRATION);
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         (param1.currentTarget as BaseAlerFrame).dispose();
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               StateManager.setState(StateType.ACADEMY_REGISTRATION);
         }
      }
      
      public function getMasterHonorLevel(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < GRADUATE_NUM.length)
         {
            if(param1 >= GRADUATE_NUM[_loc3_])
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function isFreezes(param1:Boolean) : Boolean
      {
         var _loc2_:Date = TimeManager.Instance.serverDate;
         if(PlayerManager.Instance.Self.freezesDate > _loc2_)
         {
            if(param1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.academyManager.Freezes"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.academyManager.FreezesII"));
            }
            return false;
         }
         return true;
      }
      
      public function set messgers(param1:Vector.<SimpleMessger>) : void
      {
         this._messgers = param1;
      }
      
      public function get messgers() : Vector.<SimpleMessger>
      {
         return this._messgers;
      }
      
      public function showAlert() : void
      {
         while(this.messgers.length != 0)
         {
            if(this.messgers[0] && this.messgers[0].type == SimpleMessger.ANSWER_APPRENTICE)
            {
               AcademyFrameManager.Instance.showAcademyAnswerApprenticeFrame(this.messgers[0].id,this.messgers[0].name,this.messgers[0].messger);
            }
            else
            {
               AcademyFrameManager.Instance.showAcademyAnswerMasterFrame(this.messgers[0].id,this.messgers[0].name,this.messgers[0].messger);
            }
            this.messgers.shift();
         }
      }
      
      public function isFighting() : Boolean
      {
         if(StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.HOT_SPRING_ROOM && StateManager.currentStateType != StateType.CHURCH_ROOM && StateManager.currentStateType != StateType.LITTLEGAME)
         {
            return false;
         }
         return true;
      }
      
      public function isRecommend() : Boolean
      {
         return AcademyManager.Instance.isShowRecommend && !SharedManager.Instance.isRecommend && PlayerManager.Instance.Self.Grade > AcademyManager.TARGET_PLAYER_MIN_LEVEL && (PlayerManager.Instance.Self.apprenticeshipState == AcademyManager.NONE_STATE || PlayerManager.Instance.Self.apprenticeshipState == AcademyManager.MASTER_STATE);
      }
      
      public function isOpenSpace(param1:BasePlayer) : Boolean
      {
         return param1.Grade < ACADEMY_LEVEL_MIN && param1.Grade > ACADEMY_LEVEL_MAX;
      }
      
      public function get selfDescribe() : String
      {
         return this._selfDescribe;
      }
      
      public function set selfDescribe(param1:String) : void
      {
         this._selfDescribe = param1;
         dispatchEvent(new Event(SELF_DESCRIBE));
      }
   }
}
