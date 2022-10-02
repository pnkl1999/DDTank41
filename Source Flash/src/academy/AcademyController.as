package academy
{
   import academy.view.AcademyView;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.AcademyMemberListAnalyze;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.display.Sprite;
   
   public class AcademyController extends BaseStateView
   {
       
      
      private var _model:AcademyModel;
      
      private var _view:AcademyView;
      
      private var _chatFrame:Sprite;
      
      public function AcademyController()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this.init();
         MainToolBar.Instance.show();
         this.loadAcademyMemberList(AcademyManager.ACADEMY,this._model.state,1,"",true);
         if(PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.NONE_STATE)
         {
            AcademyManager.Instance.myAcademy();
         }
      }
      
      private function init() : void
      {
         this._model = new AcademyModel();
         this._view = new AcademyView(this);
         addChild(this._view);
         ChatManager.Instance.state = ChatManager.CHAT_ACADEMY_VIEW;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         this._model = null;
         if(this._chatFrame && this._chatFrame.parent)
         {
            this._chatFrame.parent.removeChild(this._chatFrame);
         }
      }
      
      public function loadAcademyMemberList(param1:Boolean = true, param2:Boolean = false, param3:int = 1, param4:String = "", param5:Boolean = false) : void
      {
         AcademyManager.Instance.loadAcademyMemberList(this.__loadAcademyMemberList,param1,param2,param3,param4,0,true,param5);
      }
      
      public function get model() : AcademyModel
      {
         return this._model;
      }
      
      public function set currentAcademyInfo(param1:AcademyPlayerInfo) : void
      {
         this._model.info = param1;
         dispatchEvent(new AcademyEvent(AcademyEvent.ACADEMY_PLAYER_CHANGE));
      }
      
      private function __loadAcademyMemberList(param1:AcademyMemberListAnalyze) : void
      {
         this._model.list = param1.academyMemberList;
         this._model.totalPage = param1.totalPage;
         AcademyManager.Instance.isSelfPublishEquip = param1.isSelfPublishEquip;
         if(param1.isAlter)
         {
            AcademyManager.Instance.selfIsRegister = param1.selfIsRegister;
         }
         if(param1.selfDescribe && param1.selfDescribe != "")
         {
            AcademyManager.Instance.selfDescribe = param1.selfDescribe;
         }
         if(this._model.list.length != 0)
         {
            this.currentAcademyInfo = this._model.list[0];
         }
         dispatchEvent(new AcademyEvent(AcademyEvent.ACADEMY_UPDATE_LIST));
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         MainToolBar.Instance.hide();
         super.leaving(param1);
         this.dispose();
      }
      
      override public function getType() : String
      {
         return StateType.ACADEMY_REGISTRATION;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
   }
}
