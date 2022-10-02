package ddt.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.player.BasePlayer;
   import ddt.states.StateType;
   import ddt.view.academyCommon.academyRequest.AcademyAnswerApprenticeFrame;
   import ddt.view.academyCommon.academyRequest.AcademyAnswerMasterFrame;
   import ddt.view.academyCommon.academyRequest.AcademyRequestApprenticeFrame;
   import ddt.view.academyCommon.academyRequest.AcademyRequestMasterFrame;
   import ddt.view.academyCommon.data.SimpleMessger;
   import ddt.view.academyCommon.graduate.ApprenticeGraduate;
   import ddt.view.academyCommon.graduate.MasterGraduate;
   import ddt.view.academyCommon.myAcademy.MyAcademyApprenticeFrame;
   import ddt.view.academyCommon.myAcademy.MyAcademyMasterFrame;
   import ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame;
   import ddt.view.academyCommon.recommend.AcademyMasterMainFrame;
   import ddt.view.academyCommon.register.AcademyRegisterFrame;
   
   public class AcademyFrameManager
   {
      
      private static var _instance:AcademyFrameManager;
       
      
      private var _academyRegisterFrame:AcademyRegisterFrame;
      
      private var _myAcademyMasterFrame:MyAcademyMasterFrame;
      
      private var _myAcademyApprenticeFrame:MyAcademyApprenticeFrame;
      
      private var _academyMasterMainFrame:AcademyMasterMainFrame;
      
      private var _academyApprenticeMainFrame:AcademyApprenticeMainFrame;
      
      private var _academyRequestMasterFrame:AcademyRequestMasterFrame;
      
      private var _academyAnswerMasterFrame:AcademyAnswerMasterFrame;
      
      private var _academyAnswerApprenticeFrame:AcademyAnswerApprenticeFrame;
      
      private var _apprenticeGraduate:ApprenticeGraduate;
      
      private var _masterGraduate:MasterGraduate;
      
      public function AcademyFrameManager()
      {
         super();
      }
      
      public static function get Instance() : AcademyFrameManager
      {
         if(_instance == null)
         {
            _instance = new AcademyFrameManager();
         }
         return _instance;
      }
      
      public function showRegisterFrame(param1:Boolean) : void
      {
         this._academyRegisterFrame = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRegisterFrame");
         this._academyRegisterFrame.isAmend(param1);
         this._academyRegisterFrame.show();
      }
      
      public function showMyAcademyMasterFrame() : void
      {
         if(this._myAcademyMasterFrame)
         {
            this._myAcademyMasterFrame.dispose();
            this._myAcademyMasterFrame = null;
         }
         this._myAcademyMasterFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterFrame");
         this._myAcademyMasterFrame.show();
         this._myAcademyMasterFrame.addEventListener(FrameEvent.RESPONSE,this.__clearMyAcademyMasterFrame);
      }
      
      private function __clearMyAcademyMasterFrame(param1:FrameEvent) : void
      {
         this._myAcademyMasterFrame.removeEventListener(FrameEvent.RESPONSE,this.__clearMyAcademyMasterFrame);
         this._myAcademyMasterFrame.dispose();
         this._myAcademyMasterFrame = null;
      }
      
      public function showMyAcademyApprenticeFrame() : void
      {
         if(this._myAcademyApprenticeFrame)
         {
            this._myAcademyApprenticeFrame.dispose();
            this._myAcademyApprenticeFrame = null;
         }
         this._myAcademyApprenticeFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyApprenticeFrame");
         this._myAcademyApprenticeFrame.show();
         this._myAcademyApprenticeFrame.addEventListener(FrameEvent.RESPONSE,this.__clearMyAcademyApprenticeFrame);
      }
      
      private function __clearMyAcademyApprenticeFrame(param1:FrameEvent) : void
      {
         this._myAcademyApprenticeFrame.removeEventListener(FrameEvent.RESPONSE,this.__clearMyAcademyApprenticeFrame);
         this._myAcademyApprenticeFrame.dispose();
         this._myAcademyApprenticeFrame = null;
      }
      
      public function showAcademyMasterMainFrame() : void
      {
         this._academyMasterMainFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyMasterMainFrame");
         this._academyMasterMainFrame.show();
         this._academyMasterMainFrame.addEventListener(FrameEvent.RESPONSE,this.__clearAcademyMasterMainFrame);
      }
      
      private function __clearAcademyMasterMainFrame(param1:FrameEvent) : void
      {
         this._academyMasterMainFrame.removeEventListener(FrameEvent.RESPONSE,this.__clearAcademyMasterMainFrame);
         this._academyMasterMainFrame.dispose();
         this._academyMasterMainFrame = null;
      }
      
      public function showAcademyApprenticeMainFrame() : void
      {
         this._academyApprenticeMainFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyApprenticeMainFrame");
         this._academyApprenticeMainFrame.show();
         this._academyApprenticeMainFrame.addEventListener(FrameEvent.RESPONSE,this.__clearAcademyApprenticeMainFrame);
      }
      
      private function __clearAcademyApprenticeMainFrame(param1:FrameEvent) : void
      {
         this._academyApprenticeMainFrame.removeEventListener(FrameEvent.RESPONSE,this.__clearAcademyApprenticeMainFrame);
         this._academyApprenticeMainFrame.dispose();
         this._academyApprenticeMainFrame = null;
      }
      
      public function showAcademyRequestMasterFrame(param1:BasePlayer) : void
      {
         this._academyRequestMasterFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.AcademyRequestMasterFrame");
         this._academyRequestMasterFrame.show();
         this._academyRequestMasterFrame.setInfo(param1);
      }
      
      public function showAcademyRequestApprenticeFrame(param1:BasePlayer) : void
      {
         var _loc2_:AcademyRequestApprenticeFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.AcademyRequestApprenticeFrame");
         _loc2_.show();
         _loc2_.setInfo(param1);
      }
      
      public function showAcademyAnswerMasterFrame(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:SimpleMessger = null;
         if(StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.LITTLEGAME)
         {
            this._academyAnswerMasterFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.AcademyAnswerMasterFrame");
            this._academyAnswerMasterFrame.show();
            this._academyAnswerMasterFrame.setMessage(param1,param2,param3);
         }
         else
         {
            _loc4_ = new SimpleMessger(param1,param2,param3,SimpleMessger.ANSWER_MASTER);
            AcademyManager.Instance.messgers.push(_loc4_);
         }
      }
      
      public function showAcademyAnswerApprenticeFrame(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:SimpleMessger = null;
         if(StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.LITTLEGAME)
         {
            this._academyAnswerApprenticeFrame = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.AcademyAnswerApprenticeFrame");
            this._academyAnswerApprenticeFrame.show();
            this._academyAnswerApprenticeFrame.setMessage(param1,param2,param3);
         }
         else
         {
            _loc4_ = new SimpleMessger(param1,param2,param3,SimpleMessger.ANSWER_APPRENTICE);
            AcademyManager.Instance.messgers.push(_loc4_);
         }
      }
      
      public function showApprenticeGraduate() : void
      {
         if(StateManager.currentStateType == StateType.FIGHT_LIB || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.LITTLEGAME)
         {
            return;
         }
         this._apprenticeGraduate = ComponentFactory.Instance.creatComponentByStylename("academyCommon.graduate.apprenticeGraduate");
         this._apprenticeGraduate.show();
      }
      
      public function showMasterGraduate(param1:String) : void
      {
         if(StateManager.currentStateType == StateType.FIGHT_LIB || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.LITTLEGAME)
         {
            return;
         }
         this._masterGraduate = ComponentFactory.Instance.creatComponentByStylename("academyCommon.graduate.masterGraduate");
         this._masterGraduate.setName(param1);
         this._masterGraduate.show();
      }
      
      public function showAcademyPreviewFrame() : void
      {
         var _loc1_:Boolean = PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.MASTER_FULL_STATE && PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.APPRENTICE_STATE;
         if(PlayerManager.Instance.Self.Grade >= 20)
         {
            PreviewFrameManager.Instance.createsPreviewFrame(LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree"),"asset.PreviewFrame.PreviewContent","view.common.apprenticeAcademyPreviewFrame","view.common.masterAcademyPreviewFrame.PreviewScroll",AcademyManager.Instance.recommends,_loc1_);
         }
         else
         {
            PreviewFrameManager.Instance.createsPreviewFrame(LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree"),"asset.PreviewFrame.PreviewContent","view.common.masterAcademyPreviewFrame","view.common.masterAcademyPreviewFrame.PreviewScroll",AcademyManager.Instance.recommends,_loc1_);
         }
      }
      
      public function showRecommendAcademyPreviewFrame() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 20)
         {
            PreviewFrameManager.Instance.createsPreviewFrame(LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree"),"asset.PreviewFrame.PreviewContent","view.common.apprenticeAcademyPreviewFrame","view.common.masterAcademyPreviewFrame.PreviewScroll");
         }
         else
         {
            PreviewFrameManager.Instance.createsPreviewFrame(LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree"),"asset.PreviewFrame.PreviewContent","view.common.masterAcademyPreviewFrame","view.common.masterAcademyPreviewFrame.PreviewScroll");
         }
      }
   }
}
